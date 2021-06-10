`timescale 1ns / 1ps
`define R_TYPE              3'b000
`define I_TYPE              3'b001
`define S_TYPE              3'b010
`define B_TYPE              3'b011
`define U_TYPE              3'b100
`define J_TYPE              3'b101
`define CSR_TYPE            3'b110

`timescale 1ns / 1ps
//`include "globals.vh"

module imm_generator(
    
    input wire [31:7] INSTR,
    input wire [2:0] IMM_TYPE,
    output wire [31:0] IMM
    
    );
    
    wire [31:0] i_type;
    wire [31:0] s_type;
    wire [31:0] b_type;
    wire [31:0] u_type;
    wire [31:0] j_type;
    wire [31:0] r_type;
    
    assign i_type = { {20{INSTR[31]}}, INSTR[31:20] };
    assign s_type = { {20{INSTR[31]}}, INSTR[31:25], INSTR[11:7] };
    assign b_type = { {19{INSTR[31]}}, INSTR[31], INSTR[7], INSTR[30:25], INSTR[11:8], 1'b0 };
    assign u_type = { INSTR[31:12], 12'h000 };
    assign j_type = { {11{INSTR[31]}}, INSTR[31], INSTR[19:12], INSTR[20], INSTR[30:21], 1'b0 };
    assign r_type = { 27'b0, INSTR[19:15] };
//always @(*)
//       begin
//         case (IMM_TYPE)
//               3'b000:  assign IMM = i_type; 
//               `I_TYPE: assign IMM = i_type;
//               `S_TYPE:  assign IMM = s_type;
//               `B_TYPE: assign IMM = b_type;
//               `U_TYPE: assign IMM = u_type;
//               `J_TYPE: assign IMM = j_type;
//               `CSR_TYPE: assign IMM = r_type;
//               3'b111: assign IMM = i_type;
//           endcase
//        end
     
//           assign IMM = r_type;
//    if  (  IMM_TYPE == `I_TYPE)
//           assign IMM = i_type;
//    if  (  IMM_TYPE == `S_TYPE)
//            assign IMM = s_type;
//    if (   IMM_TYPE ==  `B_TYPE)
//            assign IMM = b_type;
//    if (   IMM_TYPE == `U_TYPE)
//            assign IMM = u_type;
//    if (   IMM_TYPE ==  `J_TYPE)
//            assign IMM = j_type); 

assign IMM = `I_TYPE == IMM_TYPE ? i_type :
                                    `S_TYPE == IMM_TYPE ? s_type :
                                                         `B_TYPE == IMM_TYPE ? b_type :
                                                                          `U_TYPE == IMM_TYPE ? u_type :
                                                                                                `J_TYPE == IMM_TYPE ? j_type : 
                                                                                                                    `CSR_TYPE == IMM_TYPE ? r_type :
                                                                                                                                              i_type ;
                                                                                                       
                                             
                                                                               

    
                    
        
        
endmodule
