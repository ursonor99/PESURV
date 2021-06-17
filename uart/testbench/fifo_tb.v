`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/10/2021 06:41:55 PM
// Design Name: 
// Module Name: fifo_tb
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

module fifo_tb(
    );    
    parameter c_CLOCK_PERIOD_NS = 20;
    parameter c_RESET_PERIOD_NS = 200;
    
    reg Clk,Rst,r_flag=0,w_flag=0;
    wire no_read,no_write;
    reg[7:0] Written_value=0;
    wire [7:0] read_value;
    wire [2:0] w_ptr;
    wire [2:0] r_ptr;
    uart_fifo uut(Clk,Rst,r_flag,read_value,w_flag,Written_value,no_read,no_write, w_ptr, r_ptr);
    
     always
    #(c_CLOCK_PERIOD_NS/2) Clk <= !Clk;
    
    initial 
        begin
            Rst<=1;
            Clk<=1;
            #20;
            Rst=0;
            w_flag =1;
            Written_value = 8'h05;
            #20
            Written_value = 8'h15;
            #20
            Written_value = 8'h25;
            r_flag =1;
            #20
            Written_value = 8'h35;
            #20
            w_flag =0;
            Written_value = 8'h45;
            #20
            //r_flag =0;
            Written_value = 8'h55; 
            #20
            Written_value = 8'h65;
            #20
            Written_value = 8'h75;
            #20
            Written_value = 8'h85;
            #20
            Rst=1;
            w_flag=0;
            Written_value = 8'h95;
            #20
            Written_value = 8'h10;
            #20
            Written_value = 8'h11;
            #20
            Written_value = 8'h12;
            //$finish;
        end
    
    
endmodule
