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
  reg  [31:0]ram_wdat;
  reg   ram_we;
  reg  [3:0] ram_type;
  reg  [31:0]ram_addr;
  //wire  [31:0]ram_dout;
  reg ram_re;
  wire [31:0] data_reg;
    
    
    ram_2 uut(
    clk,
    ram_wdat,
    ram_we,
    ram_type,
    ram_addr,
    //ram_dout,
    ram_re,
    data_reg
    );
    
    always 
    #5 clk=~clk;
    initial 
    begin
    clk=0;
    ram_we=0;
    ram_type=4'b0000;
    ram_addr=8'h00000000;
    ram_re=0;
    ram_wdat=32'h123DF556;
     #5;

    #10;
    ram_we=1;
    ram_type=4'b0011;
    ram_addr=32'h10240043;
    //ram_rd_store=1;
    
    #10;
    ram_we=1;
    ram_type=4'b1111;
    ram_addr=32'h10240003;
    ram_wdat=32'h123DF336;
    
    #10;
    ram_re=1;
    ram_we=0;
    ram_type=4'b1111;
    ram_addr=32'h10240043;
    
    
    end
    
  
endmodule
