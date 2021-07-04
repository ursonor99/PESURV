`timescale 1ns / 1ps

`include "GLOBALS.v"


module branch(
input wire i_branch_cond,
input wire[31:0] i_jump_br_addr,
input wire[1:0] i_br_type,
// jal or jalr or br or none 
//00    none
//01    jal
//10    jalr
//11    br
output wire o_is_branching,
output wire[31:0] o_branch_addr
);


wire[31:0] jalr_jump_addr;

assign jalr_jump_addr = {i_jump_br_addr[31:1],1'b0};

assign o_is_branching = i_br_type== `NONE ? 1'b0 :  
                                            i_br_type== `JAL ? 1'b1 : 
                                                               i_br_type== `JALR ?  1'b1 :  
                                                                                    i_br_type==`BR && i_branch_cond==1'b1 ? 1'b1:
                                                                                                                            1'b0;
assign o_branch_addr = 
                        i_br_type== `JAL ? i_jump_br_addr : 
                                            i_br_type== `JALR ? jalr_jump_addr :  
                                                                i_br_type==`BR && i_branch_cond==1 ?   i_jump_br_addr: 32'b0  ;



endmodule

