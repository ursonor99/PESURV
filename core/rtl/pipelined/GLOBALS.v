`define GLOBALS


// input branch type to branch.h

`define NONE 2'b00
`define JAL 2'b01
`define JALR 2'b10
`define BR 2'b11

//exceptions
`define E_CALL 2'b001
`define E_BREAK 2'b010
`define MEM_MISALIGN 2'b011

// ALU Control Codes 
`define PASSTHROUGH_RS1 5'b00000
`define LSL 5'b00001
`define LSR_UNSIGN 5'b00010
`define LSR_SIGN 5'b00011
`define ADD 5'b00100
`define SUB 5'b00101
`define AND 5'b00110
`define OR 5'b00111
`define XOR 5'b01000
`define SLT_UNSIGN 5'b01001
`define SLT_SIGN 5'b01010
`define PASSTHROUGH_RS2 5'b01011

`define BR_EQ 5'b01100
`define BR_NE 5'b01101
`define BR_LTS 5'b01110
`define BR_LTU 5'b01111
`define BR_GES 5'b10000
`define BR_GEU 5'b10001


//writeback types
`define WB_NO_DATA 2'b00
`define WB_RET_ADDR 2'b01
`define WB_ALU_OUT 2'b10
`define WB_LOAD_DATA 2'b11

//Function7
`define FN3_ADD_SUB        3'b000
`define FN3_SLL            3'b001
`define FN3_SLT            3'b010
`define FN3_SLTU           3'b011
`define FN3_XOR            3'b100
`define FN3_SRL_SRA        3'b101
`define FN3_OR             3'b110
`define FN3_AND            3'b111

`define FN3_BEQ            3'b000
`define FN3_BNE            3'b001
`define FN3_BLT            3'b100
`define FN3_BGE            3'b101
`define FN3_BLTU           3'b110
`define FN3_BGEU           3'b111

`define FN3_LB             3'b000
`define FN3_LH             3'b001
`define FN3_LW             3'b010
`define FN3_LBU            3'b100
`define FN3_LHU            3'b101

`define FN3_SB             3'b000
`define FN3_SH             3'b001
`define FN3_SW             3'b010

//control 
`define OPCODE_OP           7'b0110011 //0B
`define OPCODE_OP_IMM       7'b0010011 //04 I
`define OPCODE_JAL          7'b1101111 //1C J
`define OPCODE_JALR         7'b1100111 //19 I
`define OPCODE_BRANCH       7'b1100011 //18 B
//RAM TYPE 
`define BYTE 4'b0001
`define HALFWORD 4'b0011
`define THREEQUATER 4'b0111
`define FULLWORD 4'b1111