`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.09.2021 21:52:43
// Design Name: 
// Module Name: top_tb
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


module top_tb();


reg clk;
reg rst_n;

top uut (
clk ,
rst_n 
);

always 
#10 clk=~clk;
initial 
begin
rst_n=0;
clk=1;
#5
rst_n=1;



#120
$finish;



end



endmodule
