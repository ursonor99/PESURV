`timescale 1ns / 1ps
// Implemented instructions opcodes

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
`define OPCODE_MISC_MEM     5'b00011 //03 
`define OPCODE_SYSTEM       5'b11100 //1c I

// immediate format selection

`define R_TYPE              3'b000 //0
`define I_TYPE              3'b001 //1
`define S_TYPE              3'b010 //2
`define B_TYPE              3'b011 //3
`define U_TYPE              3'b100 //4
`define J_TYPE              3'b101 //5
`define CSR_TYPE            3'b110 //6
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// OPCODE_OP
// Create Date: 06/11/2021 10:51:47 PM
// Design Name: 
// Module Name: imm_tb
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

//`include "GLOBALS.v"

module imm_tb(

    );

reg [31:0] INSTR;
wire [31:0] IMM_OP;

IMM_OP uut (INSTR,IMM_OP);//,i_type,is_branch,copy);

integer i;
    
    initial
    begin
        
        $display("Testing Immediate Generator...");
        
        INSTR = {30'b0, 2'b11};
        //FUNCT3 = 3'b0;
        
        $display("Testing immediate generator for OP-IMM_OP opcode");
        
        INSTR[6:2] = `OPCODE_OP_IMM;
        
        for(i = 0; i < 10000; i=i+1)
        begin
            
            INSTR[31:7] = $random;
            
            #10;
            
            if(IMM_OP != { {20{INSTR[31]}}, INSTR[31:20] })
            begin
                $display("FAIL. Check the results.");
                $finish;
            end
            
        end
        
        $display("OP-IMM_OP opcode successfully tested.");        
        
        $display("Testing immediate generator for LOAD opcode");
        
        INSTR[6:2] = `OPCODE_LOAD;
        
        for(i = 0; i < 10000; i=i+1)
        begin
            
            INSTR[31:7] = $random;
            
            #10;
            
            if(IMM_OP != { {20{INSTR[31]}}, INSTR[31:20] })
            begin
                $display("FAIL. Check the results.");
                $finish;
            end
            
        end
        
        $display("LOAD opcode successfully tested.");
        
        $display("Testing immediate generator for STORE opcode");
        
        INSTR[6:2] = `OPCODE_STORE;
        
        for(i = 0; i < 10000; i=i+1)
        begin
            
            INSTR[31:7] = $random;
            
            #10;
            
            if(IMM_OP != { {20{INSTR[31]}}, INSTR[31:25], INSTR[11:7] })
            begin
                $display("FAIL. Check the results.");
                $finish;
            end
            
        end
        
        $display("STORE opcode successfully tested.");
        
        $display("Testing immediate generator for BRANCH opcode");
        
        INSTR[6:2] = `OPCODE_BRANCH;
        
        for(i = 0; i < 10000; i=i+1)
        begin
            
            INSTR[31:7] = $random;
            
            #10;
            
            if(IMM_OP != { {19{INSTR[31]}}, INSTR[31], INSTR[7], INSTR[30:25], INSTR[11:8], 1'b0 })
            begin
                $display("FAIL. Check the results.");
                $finish;
            end
            
        end
        
        $display("BRANCH opcode successfully tested.");
        
        $display("Testing immediate generator for JALR opcode");
        
        INSTR[6:2] = `OPCODE_JALR;
        
        for(i = 0; i < 10000; i=i+1)
        begin
            
            INSTR[31:7] = $random;
            
            #10;
            
            if(IMM_OP != { {20{INSTR[31]}}, INSTR[31:20] })
            begin
                $display("FAIL. Check the results.");
                $finish;
            end
            
        end
        
        $display("JALR opcode successfully tested.");
        
        $display("Testing immediate generator for JAL opcode");
        
        INSTR[6:2] = `OPCODE_JAL;
        
        for(i = 0; i < 10000; i=i+1)
        begin
            
            INSTR[31:7] = $random;
            
            #10;
            
            if(IMM_OP != { {11{INSTR[31]}}, INSTR[31], INSTR[19:12], INSTR[20], INSTR[30:21], 1'b0 })
            begin
                $display("FAIL. Check the results.");
                $finish;
            end
            
        end
        
        $display("JAL opcode successfully tested.");
        
        $display("Testing immediate generator for LUI opcode");
        
        INSTR[6:2] = `OPCODE_LUI;
        
        for(i = 0; i < 10000; i=i+1)
        begin
            
            INSTR[31:7] = $random;
            
            #10;
            
            if(IMM_OP != { INSTR[31:12], 12'h000 })
            begin
                $display("FAIL. Check the results.");
                $finish;
            end
            
        end
        
        $display("LUI opcode successfully tested.");
        
        $display("Testing immediate generator for AUIPC opcode");
        
        INSTR[6:2] = `OPCODE_AUIPC;
        
        for(i = 0; i < 10000; i=i+1)
        begin
            
            INSTR[31:7] = $random;
            
            #10;
            
            if(IMM_OP != { INSTR[31:12], 12'h000 })
            begin
                $display("FAIL. Check the results.");
                $finish;
            end
            
        end
        
        $display("AUIPC opcode successfully tested.");
        
        
        $display("Immediate Generator successfully tested.");
        
    end

endmodule
