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
IMM= 3'b001;
#10
IMM_TYPE = `I_TYPE;
IMM= { {20{INSTR[31]}}, INSTR[31:20] };
#10
IMM_TYPE = `J_TYPE;
IMM = { {11{INSTR[31]}}, INSTR[31], INSTR[19:12], INSTR[20], INSTR[30:21], 1'b0 };
#10
IMM_TYPE = `S_TYPE;
IMM = { {20{INSTR[31]}}, INSTR[31:25], INSTR[11:7] };
#10
IMM_TYPE = `B_TYPE;
IMM = { {19{INSTR[31]}}, INSTR[31], INSTR[7], INSTR[30:25], INSTR[11:8], 1'b0 };
#10
IMM_TYPE = 'U_TYPE;
IMM = { INSTR[31:12], 12'h000 };
#10
IMM_TYPE = `R_TYPE;
IMM = { 27'b0, INSTR[19:15] };

end 
endmodule
