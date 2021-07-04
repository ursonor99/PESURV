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
  reg ram_re;
  wire [31:0] data_reg;
  reg sign;
    
    
    ram_2 uut(
    clk,
    ram_wdat,
    ram_we,
    ram_type,
    ram_addr,
    //ram_dout,
    ram_re,
    data_reg,
    sign
    );
    
    
    always 
    #5 clk=~clk;
    initial 
    begin
    
    clk=0;
    sign=0;
    ram_we=0;
    ram_re=0;
    ram_type=4'b0000;
      
    //write
    #10;
    ram_we=1;
    sign=0;
    ram_type=4'b1111;
    ram_wdat=32'h00000011;
    ram_addr=32'h00000004;
    //ram_rd_store=1;
    
    //write
    #10;
    ram_we=1;
    sign=0;
    ram_type=4'b1111;
    ram_wdat=32'h00000100;
    ram_addr=32'h00000040;
    
    //write
    #10;
    ram_we=1;
    sign=0;
    ram_type=4'b1111;
    ram_wdat=32'h000000b4;
    ram_addr=32'h00000044;
    
    //read word 
    #10;
    ram_we=0;
    ram_re=1;
    ram_type=4'b1111;
    sign=0;
    ram_addr=32'h00000004;
    
    
    //write halfword
    #10;
    ram_re=0;
    ram_we=1;
    sign=0;
    ram_type=4'b0011;
    ram_wdat=32'h000000ab;
    ram_addr=32'h00000022;
    
    //write 3 quater
    #10;
    ram_we=1;
    sign=0;
    ram_type=4'b0111;
    ram_wdat=32'h000000de;
    ram_addr=32'h00000045;
    
    //write byte
    #10;
    ram_we=1;
    sign=0;
    ram_type=4'b0001;
    ram_wdat=32'h000000c1;
    ram_addr=32'h0000000d;
    
    //read halfword 
    #10;
    ram_we=0;
    ram_re=1;
    ram_type=4'b0011;
    sign=1;
    ram_addr=32'h00000022;
    
    //read 3 quater
    #10;
    ram_we=0;
    ram_re=1;
    ram_type=4'b0111;
    sign=1;
    ram_addr=32'h00000045;
    
    //read byte
    #10;
    ram_we=0;
    ram_re=1;
    ram_type=4'b0001;
    sign=1;
    ram_addr=32'h0000000d;

    #100;
    $finish;
    
    
    end
    
  
endmodule
