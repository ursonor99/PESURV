`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/16/2021 04:12:15 PM
// Design Name: 
// Module Name: ram1
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


module ram1(
    we,
    re,
    clk,
    prt_en1,
    prt_en0,
    data_0,
    address_0,
    data_1,
    address_1
    //data_out0,

    );

    input we;
    input re;
    input clk;
    input prt_en1;
    input prt_en0;
    input [31:0] data_0;
    input [4:0] address_0;
    output [31:0] data_1;
    input [4:0] address_1;
    //reg [31:0] data_out0;
    
   
   
 parameter RAM_DEPTH = 1 << 8;
 
 
 //reg [31:0] data_out;
 reg [31:0] mem [RAM_DEPTH-1:0];
 
 //write is enabled
 always @ (posedge clk)
 begin 
    if (prt_en0==1 && we==1) 
        mem[address_0] <= data_0;
 end

//buffer state
 //assign data = (oe &&  ! we) ? data_out : 8'bz; 
 
 
 //read
assign data_1=(prt_en1 && re)?mem[address_1]:31'bz;
 
 
 endmodule
 
 
 
 
 
 



 
 
 
      
    


 

