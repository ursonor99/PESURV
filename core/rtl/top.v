module top1(
      input wire clk,
      input wire rst_n
    );
s_core_pipelined uuts_core(
     clk,
     rstn,
     o_pc[31:0],
     o_inst_data[31:0],
     o_rs1_data[31:0],
     o_rs2_data[31:0],
     o_imm_out[31:0],
     o_ALU_out[31:0],
     o_adder_out[31:0],
     o_ALU_br_cond,
     o_br_jump_addr[31:0],
     o_RAM_data_out[31:0],
     o_writeback_sel[1:0],
     o_rd_writeback[31:0],
     o_if_id[64:0],
     o_id_ex[182:0],
     o_ex_mem[169:0],
     o_mem_wb[162:0]
);
 wire [31:0]o_pc;
 wire [31:0]o_inst_data;
 wire  [31:0]o_rs1_data;
 wire   [31:0]o_rs2_data;
 wire    [31:0]o_imm_out;
 wire    [31:0]o_ALU_out;
 wire    [31:0]o_adder_out;
 wire    o_ALU_br_cond;
 wire    [31:0]o_br_jump_addr;
 wire    [31:0]o_RAM_data_out;
 wire    [1:0]o_writeback_sel;
 wire    [31:0]o_rd_writeback;
 wire    [64:0]o_if_id;
  wire   [182:0]o_id_ex;
  wire   [169:0]o_ex_mem;
   wire  [162:0]o_mem_wb;
   
blk_mem_gen_0 bram_isnt (
  .clka(clk),    // input wire clk
  .wea(wea),      // input wire [3 : 0] wea
  .addra(ram_word_aligned_addr),  // input wire [31 : 0] addra
  .dina(dina),    // input wire [31 : 0] 
  .douta(data_read)  // wire[31:0] data_read ;
);
endmodule
