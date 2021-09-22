`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/10/2021 05:15:01 PM
// Design Name: 
// Module Name: DMA_controller_IO
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

//Dma acknowledge will have to be implemented somehow in the control side, so that we can just enter off state. This is required otherwise idle isnt a valid dma state,it has to relenquish the bus
//Handle the fifo overwrites better in case the number to be written to fifo and the values in that exist in the fifo, together exceed the  buffer size

module DMA_controller_IO(
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
    input  [5:0] i_Data_Counter, //No of bytes to be sent in burst mode
    input        i_Tx_Done, //Uart has successfully sent a bram_pointer
    
    output reg [2:0]    r_SM_Main     = 0
    //inout [7:0]  bram_read_port,
    //inout [7:0]  bram_write_port
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
    reg [5:0]    r_Data_Counter=0;  //counts the number of bytes to be sent to the Uart, use integer datatype ?
    reg [5:0]    r_Byte_Counter=0; 
    reg r_Tx_Send_buffer =0; //Buffers the value
    
    reg r_uart_tx = 0;
    reg r_Read_Flag_dma = 0;
    reg [7:0] r_uart_tx_dma =0 ;
    reg r_uart_tx_dv_dma =0; 
    reg r_delay_send_flag = 0;
    
    
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
            if(i_Bus_Grant ==1'b1) //Maybe check the address from control as well ?
                begin
                    r_SM_Main <=s_DMA_SETUP;
                    //$display(" Bus granted");
                end
            else
                begin //Basic initializationw_Tx_Byte_dma
                    r_Read_Flag_dma <=0; //Dont read from Rx buffer
                    //r_Tx_Send_buffer <=0; //Dont Write to Uart,comment this out to make it state independent and dependent only on the counter
                    
                    r_uart_tx_dma <=8'hFE; //Hold the Tx value high as default, default is not ff as it gets confusing to debug ff default state of the fifo buffer value
                    r_Address <= bram_pointer;
                    r_uart_tx_dv_dma <= 1'b0;//Write data is not valid
                    //$display(" Bus not granted");
                end
                
          end 
        s_DMA_SETUP ://Decide what to do read to mem or from mem
            begin //Could be made more efficient by choosing based on a single bit at a time ?
                if(i_Control == 2'b00) //Write a single byte to I/O reo_uart_txdundant ?
                    begin
                        r_SM_Main <= s_DMA_IO_READ;
                        r_Data_Counter <= 1;
                    end
                else if (i_Control == 2'b01) //Read a single byte from I/O
                    begin
                        r_SM_Main <= s_DMA_IO_WRITE;
                        //r_Data_Counter <= 1;
                    end
                else if (i_Control == 2'b10) //Write a burst to I/O
                    begin
                        r_SM_Main <= s_DMA_IO_READ_BURST;
                        r_Data_Counter <= i_Data_Counter;
                        r_Byte_Counter <= i_Data_Counter;
                    end
                else if (i_Control == 2'b11) //Read a burst from I/O
                    begin
                        r_SM_Main <= s_DMA_IO_WRITE_BURST;
                        r_Data_Counter <= i_Data_Counter;
                        r_Byte_Counter <= i_Data_Counter;
                    end
                 
            end 
            
        s_DMA_IO_READ : //Read from the memory and write to a particular given address
            begin
             r_Read_Flag_dma <= 1'b1;
             r_uart_tx_dma <= i_uart_rx; //write to bram cell            
             r_SM_Main <= s_IDLE;
            end 
        s_DMA_IO_WRITE ://Read from the memory and write to a particular given address
            begin
                if(r_delay_send_flag == 0)
                    begin
                        r_uart_tx_dma <=8'h56;// Read from bram address
                        r_uart_tx_dv_dma <= 1'b1;
                        r_delay_send_flag <=1'b1;
                    end 
                else
                    begin
                    r_uart_tx_dv_dma <= 1'b0;//No writing to buffer twice
                    r_Tx_Send_buffer <= 1'b1;
                    r_delay_send_flag <=1'b0;
                    r_SM_Main <= s_IDLE;
                    $display("0x%0h",r_Data_Counter);
                    end
                
            end
        s_DMA_IO_WRITE_BURST : //Read from the memory and write to a particular given address
            begin 
                if(r_Byte_Counter!=0)
                    begin
                        r_uart_tx_dma <=r_Byte_Counter ;
                        r_uart_tx_dv_dma <= 1'b1;
                        r_Byte_Counter <= r_Byte_Counter -1;
                    end
                else
                    begin
                        r_uart_tx_dv_dma <= 1'b0;
                        r_Tx_Send_buffer <= 1'b1;
                        r_SM_Main <= s_IDLE;
                    end
                $display("0x%0h",r_Byte_Counter);
            end
            //write one word 
            //set data valid 
            //set send reset data valid  
            //write second byte 
            //set data valid 
            //set send byte reset data valid 
            //write third byte 
            //
            
             
    //create loopback module to test the I/O first
        default :
            r_SM_Main<= s_IDLE;
        endcase
    end
   
   
   
    assign o_uart_tx_dv = r_uart_tx_dv_dma;
    assign o_uart_tx = r_uart_tx_dma;
    assign o_Read_Flag = r_Read_Flag_dma;
    assign o_Tx_Send = r_Tx_Send_buffer;
    //assign o_uart_tx  = r_uart_tx;
endmodule
