`timescale 1ns / 1ps

module pc(
input wire i_clk,
input wire i_rst_n,
//for multi cycle instr
input wire i_stall,
//from branch module
input wire i_is_branch_true,
input wire[31:0] i_branch_addr,

//loading initial addr
input wire i_writing_first_addr,
input wire[31:0] i_instr_start_addr,
output reg[31:0] o_r_pc
);

wire[31:0] pc_plus4_addr;
wire[31:0] pc_nxt;

carry_lookahead_adder uut(.i_add1(o_r_pc),.i_add2(32'h00000004),.o_result(pc_plus4_addr));

initial
begin
if (i_writing_first_addr==1'b1)
    o_r_pc<= i_instr_start_addr;
else
    o_r_pc<=32'h00000000;
end


//reset
always@(negedge i_rst_n) o_r_pc<=32'h00000000;



always@(posedge i_clk) 
begin
if (i_stall==0)
    o_r_pc<=pc_nxt;
end


//selects btw first address , branch address and pc+4
assign pc_nxt = i_writing_first_addr==1 ?  i_instr_start_addr : i_is_branch_true==1 ?   i_branch_addr : pc_plus4_addr ;


endmodule
