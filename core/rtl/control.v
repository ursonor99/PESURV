`timescale 1ns / 1ps
`include "GLOBALS.v"
`define NOP_INSTR           32'b000000000000_00000_000_00000_0010011
//10010011
`define OPCODE_OP           5'b01100 //0B
`define OPCODE_OP_IMM       5'b00100 //04 I
`define OPCODE_LOAD         5'b00000 //00 I
`define OPCODE_STORE        5'b01000 //08 S
`define OPCODE_BRANCH       5'b11000 //18 B
`define OPCODE_JAL          5'b11011 //1C J
`define OPCODE_JALR         5'b11001 //19 I
`define OPCODE_LUI          5'b01101 //0D U
`define OPCODE_AUIPC        5'b00101 //05 U





module control(
input wire[31:0] instr_in,
//input wire       setup ,

output wire[4:0] ALU_OP,
output wire REG_write_en,
//output wire IROM_write_en,
//output wire IROM_read_en,
output wire[1:0] BR_type,
//output wire PC_is_stall ,
//output wire PC_is_writing_first_addr,
output wire RAM_write_en ,
output wire RAM_read_en ,
output wire[3:0] RAM_ram_type ,
output wire RAM_sign,
output wire MUX_op1_select,
output wire MUX_op2_select,
output wire MUX_br_ret_addr_select,
output wire MUX_br_Addr_sel,
output wire[1:0] MUX_writeback 
//output wire reg_rd_ctrl


    );
    
    
    
    //opcodes
    wire is_branch;
    wire is_jal;
    wire is_jalr;
    wire is_auipc;
    wire is_lui;
    wire is_load;
    wire is_store;
    wire is_system;
    //wire is_csr;
    wire is_op;
    wire is_op_imm;
    
    assign is_branch = instr_in[6] & instr_in[5] & ~instr_in[4] & ~instr_in[3] & ~instr_in[2];
    assign is_jal = instr_in[6] & instr_in[5] & ~instr_in[4] & instr_in[3] & instr_in[2];
    assign is_jalr = instr_in[6] & instr_in[5] & ~instr_in[4] & ~instr_in[3] & instr_in[2];
    assign is_auipc = ~instr_in[6] & ~instr_in[5] & instr_in[4] & ~instr_in[3] & instr_in[2];
    assign is_lui = ~instr_in[6] & instr_in[5] & instr_in[4] & ~instr_in[3] & instr_in[2];
    assign is_op = ~instr_in[6] & instr_in[5] & instr_in[4] & ~instr_in[3] & ~instr_in[2];
    assign is_op_imm = ~instr_in[6] & ~instr_in[5] & instr_in[4] & ~instr_in[3] & ~instr_in[2];
    
    assign is_load = ~instr_in[6] & ~instr_in[5] & ~instr_in[4] & ~instr_in[3] & ~instr_in[2];
    assign is_store = ~instr_in[6] & instr_in[5] & ~instr_in[4] & ~instr_in[3] & ~instr_in[2];
    //assign is_system = instr_in[6] & instr_in[5] & instr_in[4] & ~instr_in[3] & ~instr_in[2];
    //assign is_misc_mem = ~instr_in[6] & ~instr_in[5] & ~instr_in[4] & instr_in[3] & instr_in[2];
    
    
    wire[2:0] FN3;
    wire FN7_BIT30;
    assign FN3 =  instr_in[14:12];
    assign FN7_BIT30=instr_in[30];
    
    assign ALU_OP = is_load || is_store || is_auipc || is_jal || is_jalr || (is_op && FN3==`FN3_ADD_SUB && FN7_BIT30==0) || (is_op_imm && FN3==`FN3_ADD_SUB) ? `ADD :
                      is_op && FN3==`FN3_ADD_SUB && FN7_BIT30==1                                                                                             ? `SUB :
                      ( is_op && FN3==`FN3_SLL ) || (is_op_imm && FN3==`FN3_SLL)                                                                             ? `LSL :
                      (is_op && FN3==`FN3_SLT) || (is_op_imm && FN3==`FN3_SLT)                                                                               ? `SLT_SIGN :
                      (is_op && FN3==`FN3_SLTU) || (is_op_imm && FN3==`FN3_SLTU)                                                                             ? `SLT_UNSIGN :
                      (is_op && FN3==`FN3_XOR) || (is_op_imm && FN3==`FN3_XOR)                                                                               ? `XOR :
                      (is_op && FN3==`FN3_OR) || (is_op_imm && FN3==`FN3_OR)                                                                                 ? `OR :
                      (is_op && FN3==`FN3_AND) || (is_op_imm && FN3==`FN3_AND)                                                                               ? `AND :
                      (is_op && FN3==`FN3_SRL_SRA && FN7_BIT30==0)|| (is_op_imm && FN3==`FN3_SRL_SRA && FN7_BIT30==0)                                        ? `LSR_UNSIGN :
                      (is_op && FN3==`FN3_SRL_SRA && FN7_BIT30==1)|| (is_op_imm && FN3==`FN3_SRL_SRA && FN7_BIT30==1)                                        ? `LSR_SIGN :
                       is_lui == 1                                                                                                                           ? `PASSTHROUGH_RS2:
                       is_branch && FN3==`FN3_BEQ                                                                                                            ? `BR_EQ :
                       is_branch && FN3==`FN3_BNE                                                                                                            ? `BR_NE :
                       is_branch && FN3==`FN3_BLT                                                                                                            ? `BR_LTS :
                       is_branch && FN3==`FN3_BGE                                                                                                            ? `BR_GES :
                       is_branch && FN3==`FN3_BLTU                                                                                                           ? `BR_LTU :
                       is_branch && FN3==`FN3_BGEU                                                                                                           ? `BR_GEU :
                       
                      5'b00000;
                    
    assign REG_write_en = is_op || is_op_imm || is_lui || is_auipc || is_jal || is_jalr || is_load   ? 1'b1 :
                          1'b0 ;
                          
//    assign IROM_write_en = setup == 1 ? 1'b1 :
//                          1'b0 ;
                          
//    assign IROM_read_en  = setup == 1 ? 1'b0 :
//                           1'b1 ;
                           
    assign BR_type       =  is_jal      ?  `JAL :
                            is_jalr     ?  `JALR:
                            is_branch   ?  `BR  :
                            `NONE ;
//    assign  PC_is_stall =   setup == 1 ? 1'b1 :
//                            1'b0 ;           
    
//    assign  PC_is_writing_first_addr =   setup == 1 ? 1'b1 :
//                                         1'b0 ; 
    
    
    assign RAM_write_en  = is_store ? 1'b1 :
                           1'b0 ;
    
    assign RAM_read_en  = is_load ? 1'b1 :
                           1'b0 ;
    assign RAM_ram_type = (is_load && FN3==`FN3_LB)|| (is_load && FN3==`FN3_LBU) || (is_store && FN3==`FN3_SB)  ?  `BYTE :
                          (is_load && FN3==`FN3_LH)|| (is_load && FN3==`FN3_LHU) || (is_store && FN3==`FN3_SH)  ?  `HALFWORD :
                          (is_load && FN3==`FN3_LW)  || (is_store && FN3==`FN3_SW)                         ?  `FULLWORD :
                          4'b0000 ; 
    assign RAM_sign    = (is_load && `FN3_LBU) || (is_load && `FN3_LHU) ? 1'b0 : 
                          1'b1 ;
                          
    
    assign MUX_op1_select = is_auipc || is_jal ?  1'b0 :
                            1'b1 ;
                            
    assign MUX_op2_select = is_op || is_branch ? 1'b1 :
                            1'b0 ;
                            
    assign MUX_br_ret_addr_select =  is_branch  ? 1'b1 :
                                     1'b0 ;
    assign MUX_br_Addr_sel =         is_branch  ? 1'b1 :
                                     1'b0 ;
    
    
    assign MUX_writeback = is_jal || is_jalr                         ? `WB_RET_ADDR:
                           is_op || is_op_imm ||  is_lui || is_auipc ? `WB_ALU_OUT :
                           is_load                                   ?  `WB_LOAD_DATA :
                                                                         `WB_NO_DATA ; // is_store , is_branch  
                           
    
//    assign reg_rd_ctrl = setup == 1 ? 1'b1 :
//                                    1'b0 ;
    
    
endmodule
