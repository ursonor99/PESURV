`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2021 12:09:02 AM
// Design Name: 
// Module Name: ram1_tb
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


module ram1_tb;
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
