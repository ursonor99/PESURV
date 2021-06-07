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
    wire [31:0] inst_data;
    reg [31:0]  pc;
    reg         re;
    reg        is_write;
    
    reg [31:0] im_inst;
    
inst_ram1 uut(
    clk,
    inst_data,
    pc,
    re,
    is_write,
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
    im_inst=484484*20;
     //write
    #10;
    is_write=1;
    pc=8'h10240823;
    
    
    #50;
    
    is_write=0;
    im_inst=8'h00000000;
    
    //write
    #30;
    im_inst=8'h00012567;
    is_write=1;
    pc=8'h10240143;
    
   
   //read
    #30;
    re=1;
    is_write=0;
    pc=8'h10240823;
    
    
    
    #30;
    re=0;
   
    
    end
    
endmodule
