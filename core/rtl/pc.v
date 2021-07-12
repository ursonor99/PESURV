`timescale 1ns / 1ps

`include "GLOBALS.v"

module pc(
input wire i_clk,
input wire i_rst_n,
//for multi cycle instr
//input wire i_stall,
input wire[2:0] trap,
input wire i_is_branch_true,
input wire[31:0] i_branch_addr,

//loading initial addr
//input wire i_writing_first_addr,
//input wire[31:0] i_instr_start_addr,
output reg[31:0] o_r_pc
//output wire o_branch_address_misaligned
);

reg branch_address_misaligned;
always @(*)
begin
if (i_is_branch_true==1'b1 && i_branch_addr[1:0]!=2'b00)
    branch_address_misaligned <= 1'b1;
else
    branch_address_misaligned <= 1'b0;
end
//assign o_branch_address_misaligned = branch_address_misaligned;



wire[32:0] pc_plus4_addr;
wire[31:0] pc_nxt;
carry_lookahead_adder uut(.i_add1(o_r_pc),.i_add2(4),.o_result(pc_plus4_addr));






always@(posedge i_clk,negedge i_rst_n) 
begin
if (i_rst_n == 0)
    o_r_pc<=32'b0;
else 
    o_r_pc<=pc_nxt;
end


//selects btw first address , branch address and pc+4
assign pc_nxt = branch_address_misaligned==0 && i_is_branch_true==1 ?   i_branch_addr :
                branch_address_misaligned==1 ? 1020:
                trap==`E_CALL ?  2050 :
                trap==`E_BREAK ?  2051 :
                trap==`MEM_MISALIGN ?  2052 :
                trap==3'b100 ? o_r_pc:
                pc_plus4_addr[31:0] ;


endmodule
