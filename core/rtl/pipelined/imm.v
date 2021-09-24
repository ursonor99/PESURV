`timescale 1ns / 1ps
// Implemented instructions opcodes

`define NOP_INSTR           32'b000000000000_00000_000_00000_0010011
//10010011
//`define OPCODE_OP           5'b01100 //0B
//`define OPCODE_OP_IMM       5'b00100 //04 I
//`define OPCODE_LOAD         5'b00000 //00 I
//`define OPCODE_STORE        5'b01000 //08 S
//`define OPCODE_BRANCH       5'b11000 //18 B
//`define OPCODE_JAL          5'b11011 //1C J
//`define OPCODE_JALR         5'b11001 //19 I
//`define OPCODE_LUI          5'b01101 //0D U
//`define OPCODE_AUIPC        5'b00101 //05 U
//`define OPCODE_MISC_MEM     5'b00011 //03 
//`define OPCODE_SYSTEM       5'b11100 //1c I

// immediate format selection

//`define R_TYPE              3'b000 //0
`define I_TYPE              3'b001 //1
`define S_TYPE              3'b010 //2
`define B_TYPE              3'b011 //3
`define U_TYPE              3'b100 //4
`define J_TYPE              3'b101 //5
//`define CSR_TYPE            3'b110 //6
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/11/2021 10:46:54 PM
// Design Name: 
// Module Name: IMM_OP
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



module IMM_OP (
    
    input  [31:0] INSTR,
    output [31:0] IMM_OP
    
    );
    
    wire [31:0] i_type;
    wire [31:0] s_type;
    wire [31:0] b_type;
    wire [31:0] u_type;
    wire [31:0] j_type;
    wire [31:0] csr_type;
    wire [31:0] dma_type;
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
    wire is_dmaw;
    wire is_dmab;
    wire [2:0] IMM_TYPE;
    
    assign is_branch = INSTR[6] & INSTR[5] & ~INSTR[4] & ~INSTR[3] & ~INSTR[2];
    assign is_jal = INSTR[6] & INSTR[5] & ~INSTR[4] & INSTR[3] & INSTR[2];
    assign is_jalr = INSTR[6] & INSTR[5] & ~INSTR[4] & ~INSTR[3] & INSTR[2];
    assign is_auipc = ~INSTR[6] & ~INSTR[5] & INSTR[4] & ~INSTR[3] & INSTR[2];
    assign is_lui = ~INSTR[6] & INSTR[5] & INSTR[4] & ~INSTR[3] & INSTR[2];
    assign is_op = ~INSTR[6] & INSTR[5] & INSTR[4] & ~INSTR[3] & ~INSTR[2];
    assign is_op_imm = ~INSTR[6] & ~INSTR[5] & INSTR[4] & ~INSTR[3] & ~INSTR[2];
    
    assign is_load = ~INSTR[6] & ~INSTR[5] & ~INSTR[4] & ~INSTR[3] & ~INSTR[2];
    assign is_store = ~INSTR[6] & INSTR[5] & ~INSTR[4] & ~INSTR[3] & ~INSTR[2];
    //assign is_system = INSTR[6] & INSTR[5] & INSTR[4] & ~INSTR[3] & ~INSTR[2];
    //assign is_misc_mem = ~INSTR[6] & ~INSTR[5] & ~INSTR[4] & INSTR[3] & INSTR[2];
    assign is_dmaw =INSTR[6] & INSTR[5] & INSTR[4] & INSTR[3] & ~INSTR[2];
    assign is_dmab =INSTR[6] & INSTR[5] & INSTR[4] & ~INSTR[3] & INSTR[2];

    
    //assign IMM_TYPE[1] =  | is_csr;
    //assign IMM_TYPE[2] = is_lui | is_auipc | is_jal | is_csr;
    
    assign i_type = { {20{INSTR[31]}}, INSTR[31:20] };
    assign s_type = { {20{INSTR[31]}}, INSTR[31:25], INSTR[11:7] };
    assign b_type = { {19{INSTR[31]}}, INSTR[31], INSTR[7], INSTR[30:25], INSTR[11:8], 1'b0 };
    assign u_type = { INSTR[31:12], 12'h0 };
    assign j_type = { {11{INSTR[31]}}, INSTR[31], INSTR[19:12], INSTR[20], INSTR[30:21], 1'b0 };
    assign csr_type = { 27'b0, INSTR[19:15] };
    assign dma_type={ {20{1'b0}}, INSTR[31:20] };
    assign IMM_TYPE = {is_lui | is_auipc | is_jal , is_store | is_branch , is_op_imm | is_load | is_jalr | is_branch | is_jal } ;
    
//    always @(*)
//    begin
//    IMM_OP=0;
//    #10;
       
//       case (IMM_TYPE)
//            3'b000: IMM_OP = i_type; 
//           `I_TYPE: IMM_OP = i_type;
//           `S_TYPE: IMM_OP = s_type;
//           `B_TYPE: IMM_OP = b_type;
//           `U_TYPE: IMM_OP = u_type;
//           `J_TYPE: IMM_OP = j_type;
//           `CSR_TYPE: IMM_OP = csr_type;
//           3'b111: IMM_OP = i_type;
//       endcase
//       IMM_OP=1; 
//    end
    


assign IMM_OP = `S_TYPE == IMM_TYPE ? s_type :
                `B_TYPE == IMM_TYPE ? b_type :
                `U_TYPE == IMM_TYPE ? u_type :
                `J_TYPE == IMM_TYPE ? j_type : 
                is_dmab || is_dmaw  ? dma_type:
                //`R_TYPE == IMM_TYPE ? r_type : //R_type just returns I_type which is default
                i_type ; // i_type is default, no error checking...     
endmodule
                    
        
        
