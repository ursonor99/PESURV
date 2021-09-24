module top(
      input wire clk,
      input wire rst_n,
      
    input  wire [3:0] web,
    input wire [31:0] addrb,
    input wire [31:0] dinb
     
    );
   
   wire [31:0] doutb;
    
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

wire [31:0] o_dma_addr; 
wire [31:0] o_dma_count;
wire [2:0] o_dma_type;
wire o_dma_grant;
wire dma_ack ;
assign dma_ack = 0;
 
wire [3 : 0] o_wea;
wire [31 : 0] o_dina; 
wire[31:0] i_bram_read ;
wire[31:0] o_bram_addr ;

wire [3 : 0] wea;
wire [31 : 0] dina; 
wire[31:0] data_read_a ;
wire[31:0] bram_addr ;
 
 


assign dina = o_dina ;
assign wea = o_wea ;
assign i_bram_read = data_read_a;
assign bram_addr = o_bram_addr ;

//assign web =0;
//assign addrb =0;
//assign dinb =0;

s_core_pipelined uuts_core(
     clk,
     rst_n,
     i_bram_read,
     dma_ack,
     
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
     o_mem_wb[162:0],
      o_wea, 
      o_dina,
      o_bram_addr,
      o_dma_addr,
      o_dma_count,
      o_dma_type,
      o_dma_grant
      
);

   
blk_mem_gen_0 bram_isnt (
  .clka(clk),    // input wire clka
  .wea(wea),      // input wire [3 : 0] wea
  .addra( bram_addr),  // input wire [31 : 0] addra
  .dina(dina),    // input wire [31 : 0] dina
  .douta(data_read_a),  // output wire [31 : 0] douta
  .clkb(clk),    // input wire clkb
  .web(web),      // input wire [3 : 0] web
  .addrb(addrb),  // input wire [31 : 0] addrb
  .dinb(dinb),    // input wire [31 : 0] dinb
  .doutb(doutb)  // output wire [31 : 0] doutb
);
endmodule