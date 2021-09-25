`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/24/2021 07:49:20 PM
// Design Name: 
// Module Name: fipo_tb
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


module fipo_tb(

    );  
    parameter c_CLOCK_PERIOD_NS = 20;
    parameter c_RESET_PERIOD_NS = 200;
    
    reg Clk,Rst,r_flag=0,w_flag=0,i_start=0;
    reg[7:0] Written_value=0;
    
    wire no_read,no_write;
    wire [7:0] read_value;
    wire [2:0] w_ptr;
    wire [2:0] r_ptr;
    wire [31:0] word;
    wire read_fifo;
    
    uart_fifo uut(Clk,Rst,read_fifo,read_value,w_flag,Written_value,no_read,no_write, w_ptr, r_ptr);
    pipo_uart uub(Clk,Rst,i_start,no_read,read_fifo,read_value,word);
    
     always
    #(c_CLOCK_PERIOD_NS/2) Clk <= !Clk;
    
    initial 
        begin
            Rst<=1;
            Clk<=1;
            
            r_flag<=0;
            i_start<=0;
            #20;
            Rst<=0;
            #20;
            w_flag <=1;  
            Written_value <= 8'h01;
            #20
            Written_value = 8'h02;
            #20
            Written_value = 8'h03;
            //r_flag =1;
            #20
            Written_value = 8'h04;
            #20
            Written_value <= 8'h05;
            #20
            Written_value = 8'h06;
            #20
            Written_value = 8'h07;
            //r_flag =1;
            #20
            Written_value = 8'h08;
            #20
            i_start<=1;
            #20;
            i_start<=0;
        end
    
    
endmodule
