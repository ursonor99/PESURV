`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/24/2021 02:36:13 AM
// Design Name: 
// Module Name: dma_word_controller
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module dma_word_controller
#(parameter SIZE_BIT = 5)
(
    input        i_Clock,
    input        i_Reset,//Dummy ?
    input [1:0]  i_Control,//2bit control with burst modes
    input        i_Bus_Grant, // From Control Memory
    input [31:0] bram_pointer, //Address from Control, read and write
    
    output   o_Read_Flag, // Read Trigger for Uart 
    input [7:0]  i_uart_rx, // Byte from Uart Rx fifo
    
    output       o_Tx_Send,// Trigger to send data to Uart 
    output  [7:0] o_uart_tx, // Byte to be sent to Uart
    output       o_uart_tx_dv, //Byte has finished writing and not an unstable value
    input  [SIZE_BIT:0] i_Data_Counter, //No of bytes to be sent in burst mode
    input        i_Tx_Done, //Uart has successfully sent a bram_pointer
    output       w_Acknowlege,
    output reg [2:0]    r_SM_Main     = 0,
    
    
    input  [31:0]  i_bram_read_b, //Input from bram 
    output [31:0]  o_bram_write_b,//Output to be written to bram
    output [3:0]   o_web, //Write enable 
    output [31: 0]  o_bram_addr // Output bram address 
    );
    
    
    parameter s_IDLE         = 3'b000;
    parameter s_DMA_SETUP    = 3'b001;
    parameter s_DMA_IO_READ  = 3'b010;
    parameter s_DMA_IO_READ_BURST= 3'b110;
    
    parameter s_DMA_IO_WRITE = 3'b011;
    parameter s_DMA_IO_WRITE_BURST= 3'b111;
    parameter s_CLEANUP      = 3'b100;//Exit and trigger dma ack signal
    
    //reg [2:0]    r_SM_Main     = 0;
    reg [31:0]   r_Address     = 0; //holds address given by control block 
    reg [31:0]   r_Address_output=0;//Address of bram to which word is written to.
    reg [SIZE_BIT:0]    r_Data_Counter=0;  //counts the number of bytes to be sent to the Uart, use integer datatype ?
    reg [SIZE_BIT:0]    r_Word_Counter=0; 
    reg r_Tx_Send_buffer =0; //Buffers the values_CLEANUP
    
    reg r_uart_tx = 0;
    reg r_Read_Flag_dma = 0;
    reg [7:0] r_uart_tx_dma =0 ;
    reg r_uart_tx_dv_dma =0; 
    reg [3:0] r_web=0;
    reg [31:0] r_bram_write_b=0;
    reg [31:0] r_bram_read_b=0;
    
    reg [1:0] Pos =0;
    reg r_delay_send_flag = 0;
    reg r_Acknowlege;
    
    always @(posedge i_Clock)
    begin
    if(i_Tx_Done==1'b1)
        begin
            r_Data_Counter <=r_Data_Counter-1;
            $display("0x%0h",r_Data_Counter);
            $display("Tx_Done");
        end
    if(r_Data_Counter==0) 
                r_Tx_Send_buffer<=1'b0;
                
      case (r_SM_Main)
        s_IDLE ://Await address
           
          begin
            r_Acknowlege <= 1'b0;//Irrespective of bus grant it should be reset at idle
            if(i_Bus_Grant ==1'b1) //Maybe check the address from control as well ?
                begin
                    r_SM_Main <=s_DMA_SETUP;
                    r_Address <= bram_pointer;
                    r_Address_output<=bram_pointer;
                    r_Data_Counter <= i_Data_Counter<<2;
                    r_Word_Counter <= i_Data_Counter<<2;
                    r_bram_read_b <= i_bram_read_b;
                    //$display(" Bus granted");
                end
            else
                begin //Basic initializationw_Tx_Byte_dma
                    r_Read_Flag_dma <=0; //Dont read from Rx buffer
                    //r_Tx_Send_buffer <=0; //Dont Write to Uart,comment this out to make it state independent and dependent only on the counter
                    
                    r_uart_tx_dma <=8'hFE; //Hold the Tx value high as default, default is not ff as it gets confusing to debug ff default state of the fifo buffer value
                    //r_Address <= bram_pointer;
                    r_uart_tx_dv_dma <= 1'b0;//Write data is not valid
                    r_web<=0;
                    //$display(" Bus not granted");
                end
                
          end 
        s_DMA_SETUP ://Decide what to do read to mem or from mem
            begin //Could be made more efficient by choosing based on a single bit at a time ?
                if(i_Control == 2'b10) //Write a single byte to I/O reo_uart_txdundant ?
                    begin
                        r_SM_Main <= s_DMA_IO_READ;
                        r_Word_Counter <= 4;
                        r_Read_Flag_dma <= 1'b1;
                        
                    end
                else if (i_Control == 2'b11) //Read a single byte from I/O
                    begin
                        r_SM_Main <= s_DMA_IO_WRITE;
                        r_Word_Counter <= 4;
                        //r_Address_output <= r_Address +4;
                    end
                else if (i_Control == 2'b00) //Write a burst to I/O
                    begin
                        r_SM_Main <= s_DMA_IO_READ_BURST; 
                        r_Read_Flag_dma <= 1'b1;
                        //r_Address <= r_Address-4;//Decrement here since it will get added by default next cycle
                    end
                else if (i_Control == 2'b01) //Read a burst from I/O
                    begin
                        r_SM_Main <= s_DMA_IO_WRITE_BURST;
                    end
                 
            end 
            
        s_DMA_IO_READ : //Read from the memory and write to a particular given address
            begin
               if(r_Word_Counter!=1)
                    begin
                    r_Read_Flag_dma <= 1'b1;
                    r_bram_write_b[Pos*8 +: 8]<=i_uart_rx;
                    r_Word_Counter <= r_Word_Counter -1;
                    
                    end
               else
                    begin
                         //r_uart_tx_dma <= i_uart_rx; //read once before exiting, this is required cuz we set the byte counter to 1 in the prev check. We need to only check N-1 times, if we sample all N times we would create an extra reading
                         r_bram_write_b[Pos*8 +: 8]<=i_uart_rx;
                         r_Read_Flag_dma <= 1'b0;
                         r_SM_Main <= s_CLEANUP;
                         r_web <= 4'hf; 
                         
                    end 
                $display("0x%0h",r_Word_Counter);
                //Pos <= (Pos<3)? Pos+1 : 0;
                Pos<=Pos+1; 
            end
                 
        s_DMA_IO_READ_BURST:
            begin
//                if(r_Word_Counter[2]==1) // If the word is divisible by 4, then increment address 
//                    r_Address <= r_Address+4;
                if(r_Word_Counter!=1)
                    begin
                    r_Read_Flag_dma <= 1'b1;
                    r_bram_write_b[Pos*8 +: 8]<=i_uart_rx;
                    r_Word_Counter <= r_Word_Counter -1;
                    r_web <= 4'h0;
                    end
               else
                    begin
                         //r_uart_tx_dma <= i_uart_rx; //read once before exiting, this is required cuz we set the byte counter to 1 in the prev check. We need to only check N-1 times, if we sample all N times we would create an extra reading
                         r_bram_write_b[Pos*8 +: 8]<=i_uart_rx;
                         r_Read_Flag_dma <= 1'b0;
                         r_SM_Main <= s_CLEANUP;
                         r_web <= 4'hf; 
                         
                    end 
                $display("0x%0h",r_Word_Counter);
                Pos<=Pos+1;
                //r_Address <= (Pos==3)?r_Address +4:r_Address;
                if(Pos==3)
                    r_web <= 4'hf;
                if(r_web==4'hf)
                    r_Address_output <= r_Address_output +4;                 
                //r_Address <= ((r_Word_Counter&3)==0)?r_Address +4:r_Address;
                //Pos <= (Pos<3)? Pos+1 : 0;
                
            end
            
        s_DMA_IO_WRITE ://Read from the memory and write to a particular given address
            begin
            //Read from bram, write to UartTx 
            
            if(r_Word_Counter!=0)
                begin
                    r_uart_tx_dma<= r_bram_read_b[Pos*8 +: 8];
                    r_uart_tx_dv_dma <= 1'b1;
                    r_Word_Counter <= r_Word_Counter -1;
                end
            else
                begin
                     r_uart_tx_dv_dma <= 1'b0;
                     r_Tx_Send_buffer <= 1'b1;
                     r_SM_Main <= s_CLEANUP;
                     //r_Address_output <= r_Address_output +4;
                end
                Pos<=Pos+1; 
            end
        s_DMA_IO_WRITE_BURST : //Read from the memory and write to a particular given address
            begin
            //Read from bram, write to UartTx 
            
            if(r_Word_Counter!=0)
                begin
                    r_uart_tx_dma<= r_bram_read_b[Pos*8 +: 8];
                    r_uart_tx_dv_dma <= 1'b1;
                    r_Word_Counter <= r_Word_Counter -1;
                end
            else
                begin
                     r_uart_tx_dv_dma <= 1'b0;
                     r_Tx_Send_buffer <= 1'b1;
                     r_SM_Main <= s_CLEANUP;
                end
            Pos<=Pos+1;
            if(Pos==3)
                r_Address_output <= r_Address_output +4;
            end
            
        s_CLEANUP:
            begin
                r_bram_write_b<=0;
                r_web<=0;
                r_SM_Main <= s_IDLE;
                r_Acknowlege <= 1'b1;
            end      
    //create loopback module to test the I/O first
        default :
            r_SM_Main<= s_IDLE;
        endcase
    end
   
   
   
    assign o_uart_tx_dv = r_uart_tx_dv_dma;
    assign o_uart_tx = r_uart_tx_dma;
    assign o_Read_Flag = r_Read_Flag_dma;
    assign o_Tx_Send = r_Tx_Send_buffer;
    assign w_Acknowlege =  r_Acknowlege;
    assign o_bram_addr = r_Address_output; 
    assign o_bram_write_b = r_bram_write_b;
    assign o_web = r_web;
    //assign o_uart_tx  = r_uart_tx;
endmodule
