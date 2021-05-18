`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2021 11:12:08 PM
// Design Name: 
// Module Name: ram_2_tb
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


module ram_2_tb;
  reg  clk;
  reg   rst_n;
  reg  [31:0]ram_wdat;
  reg   ram_we;
  reg  [3:0] ram_type;
  reg ram_rd_store;
  reg ram_rd_load;
  reg  [31:0]ram_addr;
  wire  [31:0]ram_dout;
  reg ram_re;
  wire [31:0] data_reg;
  
 integer i;
 
 ram_2 uut(
    clk,
    rst_n,
    ram_wdat,
    ram_we,
    ram_type,
    ram_rd_store,
    ram_rd_load,
    ram_addr,
    ram_dout,
    ram_re,
    data_reg
    );
    
    always 
    #5 clk=~clk;
    initial 
    begin
    clk=0;
    rst_n=0;
    ram_we=0;
    ram_re=0;
    ram_rd_store=0;
    ram_rd_load=0;
    for(i=0;i<64;i=i+1)begin
        ram_wdat=484484*i;
        #5;
        end
    #10;
    ram_we=1;
    ram_type=4'b1111;
    ram_addr=8'h10240043;
    ram_rd_store=1;
    
    
    #50;
    ram_rd_store=0;
    ram_we=0;
    ram_type=4'b0000;
    ram_wdat=8'h00000000;
    
    
    #30;
    ram_wdat=8'h00012567;
    ram_we=1;
    ram_type=4'b1111;
    ram_addr=8'h10240083;
    ram_rd_store=1;
   
    #30;
    ram_re=1;
    ram_we=0;
    //ram_rd_store=0;
    ram_type=4'b1111;
    ram_addr=8'h10240043;
    
    ram_rd_load=1;
    
    
    #30;
    ram_re=0;
    ram_rd_load=0;
    
    end
    
  
endmodule
