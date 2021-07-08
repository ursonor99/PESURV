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
//reg[31:0] i_pc_instr_start_addr;
//reg[31:0] inst_mem_addr;
//reg[31:0] inst_mem_data;
//reg[4:0] load_reg_addr;
//reg[31:0] load_reg_data;
//reg setup;

wire[31:0] o_pc;
wire[31:0] o_inst_data;
wire[31:0] o_rs1_data;
wire[31:0] o_rs2_data;
wire[31:0] o_imm_out;
wire[31:0] o_ALU_out;
wire[31:0] o_adder_out;
wire o_ALU_br_cond;
wire[31:0] o_br_jump_addr;
wire[31:0] o_RAM_data_out;
wire[1:0] o_writeback_sel;
wire[31:0] o_rd_writeback;


s_core uut(
clk,
rst_n,
//i_pc_instr_start_addr,
//inst_mem_addr,
//inst_mem_data,
//load_reg_addr,
//load_reg_data,
//setup,

o_pc,
o_inst_data,
o_rs1_data,
o_rs2_data,
o_imm_out,
o_ALU_out,
o_adder_out,
o_ALU_br_cond,
o_br_jump_addr,
o_RAM_data_out,
o_writeback_sel,
 o_rd_writeback
);


always 
#5 clk=~clk;
initial 
begin
rst_n=0;
clk=1;
#10
rst_n=1;
//setup=1;

//inst_mem_addr=32'h00000004;
//inst_mem_data=32'b00000000000100100111010000010011;  //and immediate
//load_reg_addr=5'b00100;  //rs1
//load_reg_data=32'h00000001;  
//#10
//inst_mem_addr=32'h00000008;
//inst_mem_data=32'b00000000011000100000000000110011;//addition
//load_reg_addr=5'b00110;  //rs2
//load_reg_data=32'h00000004;  

//#10
//inst_mem_addr=32'h0000000c;
//inst_mem_data=32'b10000000000010101010100100110111;//lui 

//#10

//inst_mem_addr=32'h00000010;
//inst_mem_data=32'b00000000001000100010100110010111;//auipc

//#10
//inst_mem_addr=32'h00000014;
//inst_mem_data=32'b00000010000000000000101111101111;//jal

//#10
//inst_mem_addr=32'h00000034;
//inst_mem_data=32'b00000001001000110000101010110011;//add
//load_reg_addr=5'b10001;                             //rs2
//load_reg_data=32'h00001101;  


//#10
//inst_mem_addr=32'h00000038;
//inst_mem_data=32'b00000001000100110010000000100011;  //str
//                //rs2=10001 rs1=00110

//#10
//inst_mem_addr=32'h0000003c;
//inst_mem_data=32'b00000000000000110010011000000011;     //load                //src=00110  dst=01100


//#10
//inst_mem_addr=32'h00000040;
//inst_mem_data=32'b00000000010000000000000110010011; //loading data to 00011 reg



////#10
////inst_mem_addr=32'h00000042;
////inst_mem_data=32'b00000000010000011000110001100111; // jalr to pc 8 

//#10


//inst_mem_addr=32'h00000044;
//inst_mem_data=32'b00000000110000000000001000010011; //loading data 4 to 00100 reg

//#10
//inst_mem_addr=32'h00000048;        ///
//inst_mem_data=32'b00000000001100100101100001100011; 

////inst_mem_data=32'b11111110001100100101111111100011; 

//#5
//i_pc_instr_start_addr=32'h00000004;
//#5
//setup=0;

#120
$finish;



end

endmodule