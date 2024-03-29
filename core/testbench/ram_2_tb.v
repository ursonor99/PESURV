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
  reg sign;
  reg  [31:0]ram_addr;
  reg ram_re;
  wire [31:0] data_reg;
  
  wire o_memory_address_misaligned;  
  
reg [3:0] web;
reg [31:0] addrb;
reg [31:0] dinb;
wire [31:0] doutb;
    
    ram_2 uut(
    clk,
    ram_wdat,
    ram_we,
    ram_type,
    sign,
    ram_addr,
    //ram_dout,
    ram_re,
    data_reg,
    o_memory_address_misaligned,
    web,
    addrb,
    dinb,
    doutb
    );
    
    
    always 
    #5 clk=~clk;
    initial 
    begin
    
    clk=1;
    sign=0;
    ram_we=0;
    ram_re=0;
    ram_type=4'b0000;
      
//    //write
//    #10;
//    ram_we=1;
//    sign=0;
//    ram_type=4'b1111;
//    ram_wdat=32'h00000011;
//    ram_addr=32'h00000004;
//    //ram_rd_store=1;
    
//    //write
//    #10;
//    ram_we=1;
//    sign=0;
//    ram_type=4'b1111;
//    ram_wdat=32'h00000100;
//    ram_addr=32'h00000040;
    
//    //write
//    #10;
//    ram_we=1;
//    sign=0;
//    ram_type=4'b1111;
//    ram_wdat=32'h000000b4;
//    ram_addr=32'h00000044;
    
//    //read word 
//    #10;
//    ram_we=0;
//    ram_re=1;
//    ram_type=4'b1111;
//    sign=0;
//    ram_addr=32'h00000004;
    
    
//    //write halfword
//    #10;
//    ram_re=0;
//    ram_we=1;
//    sign=0;
//    ram_type=4'b0011;
//    ram_wdat=32'h000000ab;
//    ram_addr=32'h00000022;
    
//    //write 3 quater
//    #10;
//    ram_we=1;
//    sign=0;
//    ram_type=4'b0111;
//    ram_wdat=32'h000000de;
//    ram_addr=32'h00000045;
    
////    //write fullword
//    #10;
//    ram_we=1;
//    sign=0;
//    ram_type=4'b1111;
//    ram_wdat=32'h00001101;
//    ram_addr=32'h00000004;
    
////    //read fullword
//    #10;
//    ram_we=0;
//    ram_re=1;
//    ram_type=4'b1111;
//    sign=1;
//    ram_addr=32'h00000004;
    
////    //write half word
//    #10;
//    ram_we=1;
//    ram_re=0;
//    ram_type=4'b0011;
//    sign=1;
//    ram_wdat=32'h0000f0f0;
//    ram_addr=32'h00000040;
    
    
//    //write byte 
//    #10;
//    ram_we=1;
//    ram_re=0;
//    ram_type=4'b0001;
//    sign=1;
//    ram_wdat=32'h000000ff;
//    ram_addr=32'h00000042;

// read halfword

    #10;
//    ram_we=1;
//    ram_re=0;
//    ram_type=4'b1111;
//    sign=0;
//    ram_addr=32'h00000040;
//    ram_wdat=32'h0000f0f0;
    
    web=4'b1111;
    addrb=32'h00000040;
    dinb=32'h0000aaf0;
    
    
    
// read halfword

    #10;
    ram_we=0;
    ram_re=1;
    ram_type=4'b1111;
    sign=0;
    ram_addr=32'h00000040;

// read byte

    #10;
    ram_we=0;
    ram_re=1;
    ram_type=4'b0011;
    sign=1;
    ram_addr=32'h00000042;

//    //read fullword
    #10;
    ram_we=0;
    ram_re=1;
    ram_type=4'b0011;
    sign=1;
    ram_addr=32'h00000040;

    
    #10;
    $finish;
    
    
    end
    
  
endmodule
