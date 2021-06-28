`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/21/2021 09:16:32 PM
// Design Name: 
// Module Name: test_s_core
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


module test_s_core;
reg clk;
reg rst_n;
reg[31:0] i_pc_instr_start_addr;
reg[31:0] inst_mem_addr;
reg[31:0] inst_mem_data;
reg[4:0] load_reg_addr;
reg[31:0] load_reg_data;
reg setup;

wire[31:0] o_pc;
wire[31:0] o_inst_data;
wire[31:0] o_rs1_data;
wire[31:0] o_rs2_data;
wire[31:0] o_ALU_out;
wire o_ALU_br_cond;
wire[31:0] o_RAM_data_out;



s_core uut(
clk,
rst_n,
i_pc_instr_start_addr,
inst_mem_addr,
inst_mem_data,
load_reg_addr,
load_reg_data,
setup,

o_pc,
o_inst_data,
o_rs1_data,
o_rs2_data,
o_ALU_out,
o_ALU_br_cond,
o_RAM_data_out
);


always 
#5 clk=~clk;
initial 
begin
rst_n=1;
clk=0;
setup=1;

inst_mem_addr=32'h00000004;
inst_mem_data=32'b00000000000100100111010000010011;  //and immediate
load_reg_addr=5'b00100;  //rs1
load_reg_data=32'h00000001;  

#10
inst_mem_addr=32'h00000008;
inst_mem_data=32'b00000000011000100000100010110011;
load_reg_addr=5'b00110;  //rs2
load_reg_data=32'h00000001;  

#10

setup=0;
#10;
setup=1;
inst_mem_addr=32'h0000000c;
inst_mem_data=32'b00000000011001110010000000100011; //src 00110 dst 01110 
#10;
inst_mem_addr=32'h00000010;
inst_mem_data=32'b0000000000001110010000110000011;  
i_pc_instr_start_addr=32'h00000004;              //imm=0000000 src 01110 drst 00011
//load_reg_addr=5'b00010;
//load_reg_data=32'h00000111;
#10
setup=0;

#40

$finish;
end
endmodule






