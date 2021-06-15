`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/20/2021 05:31:33 PM
// Design Name: 
// Module Name: im_tb
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


module im_tb;
    reg         clk;
    reg [31:0]  pc;
    reg         re;
    wire [31:0] inst_data;
   
    reg        is_write;
    reg [31:0] im_addr;
    reg [31:0] im_inst;
    
inst_ram1 uut(
    clk,
    //read
    pc,
    re,
    inst_data,
    //write
    is_write,
    im_addr,
    im_inst
    
    );
    
    always 
    #5 clk=~clk;
    initial 
    begin
    clk=0;
    re=0;
    is_write=0;
    pc=0;
    
     //write
    #5;
    im_inst=8'h124678f8;
    is_write=1;
    im_addr=8'h10240823;
    
    
    //write
    #5;
    im_inst=8'h00012567;
    is_write=1;
    im_addr=8'h10240143;
    
   
   //read
    #5;
    re=1;
    is_write=0;
    pc=8'h10240823;
    
    
    #10;
    re=0;
   
    
    end
    
endmodule
