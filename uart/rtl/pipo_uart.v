`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/24/2021 05:52:59 PM
// Design Name: 
// Module Name: pipo_uart
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

//   uart_fifo #(.WIDTH(8)) r_buffer(i_Clock, i_Reset, i_Read_Flag, o_Rx_Byte, write_flag, write_data, empty, full);

module pipo_uart(
    input i_Clock,
    input i_Reset,
    input i_prime,
    input i_empty,
    output o_Read_Flag,
    input  [7:0]  i_Read_Byte,
    
    output [31:0] o_Read_Word
    );
    
    reg [31:0] r_Word;
    reg [2:0] Pos;
    reg Read_Flag;
    reg start;

   
    
    
    always@(posedge i_Clock)
    begin
        Read_Flag <=0;
        if(i_Reset==1'b1) // Reset 
            begin
                r_Word <= 32'hFFFFFFFF;
                Pos <= 0;
            end
        else if(i_prime) // Primes the decoder, initates read one clock pulse earlier and avoids resampling
            begin
            Read_Flag <=1;
            start<=1;
            end
        else if(!i_empty && start) 
            begin
            r_Word[Pos*8 +: 8] <= i_Read_Byte; //2000 verilog syntax for variable vector part select            
            Pos = (Pos<3)? Pos+1 : 0;
            Read_Flag <=1;
            end
               
    end 
    
    assign o_Read_Flag = Read_Flag;
    assign o_Read_Word = (Pos==0) ? r_Word: o_Read_Word ; // 32'hFFFFFFFF;
endmodule



