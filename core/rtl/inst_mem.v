`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/16/2021 04:44:25 PM
// Design Name: 
// Module Name: inst_mem
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


module inst_mem(
    clk,
    data,
    address,
    en

    );
    input clk;
    input [4:0]address;
    input en;
    output [31:0]data;
    
  reg [255:0] mem[31:0];
  reg data1;
  
 always@(posedge clk)
 begin
    if(en==1)
        data1<=mem[address];
    else
        data1<=31'bz;
 end
endmodule
  
module inst_tb;
    reg clk;
    reg en;
    reg [4:0]address;
    wire [31:0]data;
 

 
 inst_mem uut(
 clk,
 data,
 address,
 en
 );
 
  always 
    #5 clk=~clk;
 
 integer i;
 
 
 initial 
 begin
    en=1;
    address=1;
#10;
 //write
for(i=1;i<32;i=i+1)begin
   address=i+1;
 end
en=0;
#20;
    
end
endmodule
 
 
  














