`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.02.2021 12:34:14
// Design Name: 
// Module Name: blink_tb
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


module blink_tb();

reg clk=1'b0;
reg s1=1'b0;
reg s2=1'b0;
reg en=1'b0;
wire led;

blink uut(clk,en,s1,s2,led);

always 
    #20 clk<=!clk;

initial 
begin
    en=1'b1;
    #160000 $finish;
    
    
end



endmodule
