`timescale 1ns / 1ps

module ctrl_sim( );


reg[31:0] instr_in;
reg       setup;
wire[4:0] ALU_OP;
wire REG_write_en;
wire IROM_write_en;
wire IROM_read_en;
wire[1:0] BR_type;
wire PC_is_stall ;
wire PC_is_writing_first_addr;
wire RAM_write_en ;
wire RAM_read_en ;
wire[3:0] RAM_ram_type;
wire RAM_sign;
wire MUX_op1_select;
wire MUX_op2_select;
wire MUX_br_ret_addr_select;
wire MUX_br_Addr_sel;
wire[1:0] MUX_writeback ;


control uut ( 
instr_in,
setup,
ALU_OP,
REG_write_en,
IROM_write_en,
IROM_read_en,
BR_type,
PC_is_stall,
PC_is_writing_first_addr,
RAM_write_en ,
RAM_read_en ,
RAM_ram_type,
RAM_sign,
MUX_op1_select,
MUX_op2_select,
MUX_br_ret_addr_select,
MUX_br_Addr_sel,
MUX_writeback );



initial
begin 
setup<=0;
instr_in <= 32'b00011110000000100111010000010011;//andi

#10

instr_in <= 32'b01000000011001001000001000110011;//sub

#10
instr_in <= 32'b00000000000000000000011100110111;//lui

#10
instr_in <= 32'b00000000000000000000000010010111;//AUIPC

#10
instr_in <= 32'b00000000000000000000100011101111;//jal

#10
instr_in <= 32'b00100000011001101100010011100011;//blt

#10
instr_in <= 32'b00000000000000000010000000000011;//LB

#10
instr_in <= 32'b00000000000000000000000000100011;//SB
#10

setup<=1;

$finish;

end









endmodule
