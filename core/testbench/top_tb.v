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
reg[3:0] web;
reg [31:0] addrb;
reg [31:0] dinb;


top uut (
clk ,
rst_n ,
web,
addrb,
dinb
);

always 
#10 clk=~clk;
initial 
begin
rst_n=0;
clk=1;
#15
rst_n=1;
#10
web<=4'b1111;
addrb<=32'h800;
dinb <=32'h5544;

#20
web<=0000;
addrb<=32'h000;

#120
$finish;



end



endmodule
