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
 
 module load_tb;
    reg we;
    reg re;
    reg clk;
    reg prt_en1;
    reg prt_en0;
    reg [31:0]data_0;
    reg [31:0] address_0;
    wire [31:0] data_1;
    reg [31:0]address_1;
    
    integer i;
    
  ram1 load_inst(
        we,
        re,
        clk,
        prt_en1,
        prt_en0,
        data_0,
        address_0,
        data_1,
        address_1
        //data_out0
    );
  always
  #5 clk = ~clk;
       
 initial
 begin
    clk=0;
    we=0;
    re=0;
    prt_en0 = 0;
    prt_en1 = 0;
    address_1=1;
    //write fun
    #10;
    prt_en0=1;
    we=1;
    for(i=1;i<=32;i=i+1)begin
        data_0=i;
        address_0=i-1;
        #10;
        end
    prt_en0=0;
    we=0;
    #20;
    //read the data
    prt_en1 = 1;
    re=1;
    for(i=1;i<=32;i=i+1)begin
        address_1=i;
        #10;
        end
     prt_en1 = 0;
     re=0;
 end
endmodule
 
 
 
      
    


 

