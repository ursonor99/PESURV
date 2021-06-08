
`define GLOBALS


// input branch type to branch.h

`define NONE 2'b00
`define JAL 2'b01
`define JALR 2'b10
`define BR 2'b11


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
