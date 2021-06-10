`timescale 1ns / 1ps

`include "GLOBALS.v"

module imm_tb(

    );
    
reg[31:0] INSTR;
reg[2:0] IMM_TYPE;
wire[31:0] IMM;

imm uut (INSTR,IMM_TYPE,IMM);

initial
begin
//IMM= 3'b001;
#10
INSTR = `OPCODE_OP_IMM;
IMM_TYPE = `I_TYPE;
#10
INSTR = `OPCODE_LOAD;
IMM_TYPE= `I_TYPE;
#10
INSTR = `OPCODE_STORE;
IMM_TYPE = `S_TYPE;
#10
INSTR = `OPCODE_BRANCH;
IMM_TYPE = `B_TYPE;
#10
INSTR = `OPCODE_JALR;
IMM_TYPE = `I_TYPE;
#10
INSTR = `OPCODE_JAL;
IMM_TYPE = `J_TYPE;
#10
INSTR = `OPCODE_LUI;
IMM_TYPE = `U_TYPE;
#10
INSTR = `OPCODE_AUIPC;
IMM_TYPE = `U_TYPE;
#10
INSTR = `OPCODE_SYSTEM;
IMM_TYPE = `R_TYPE;

end 
endmodule
