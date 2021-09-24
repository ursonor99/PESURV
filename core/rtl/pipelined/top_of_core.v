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
 //////
 
   //wire [3:0] web;
   //wire [31:0] addrb;
   //wire [31:0] dinb;
   //wire [31:0] doutb;
   
//   wire [3:0] wea=0;
//   wire [31:0] addra=0;
//   wire [31:0] dina=0;
//   wire [31:0] douta;

   parameter c_CLOCK_PERIOD_NS = 2;
   parameter c_CLKS_PER_BIT    = 4;
   parameter c_BIT_PERIOD      = 8;
   parameter SIZE_BIT	= 5;
   
   
    //reg r_Clock = 0;
    //reg r_Reset = 0;
    //reg r_read_flag =0;
    //reg r_Tx_Send  = 0;
    //reg r_Tx_DV = 0;
    //reg [7:0] r_Tx_Byte = 0 ;
    
    //reg [1:0] r_control  = 2'b10;
    //reg r_Bus_Grant = 1'b1;
    //reg r_Rx_Serial = 1;
        
    //reg [SIZE_BIT:0] r_dma_word_count;
    
    //wire [31:0] w_bram_pointer = 32'h00fc;//32'hFFFFFFFF;
    wire [7:0] w_Rx_Byte;
    
    wire w_read_flag_dma;
    wire w_Tx_Send_dma; 
    wire [7:0] w_Tx_Byte_dma;
    wire w_Tx_DV_dma;
    wire [2:0] state_tx;
    wire w_Tx_Done;
    wire [2:0] dma_state;
    wire [2:0] state_rx;
    wire w_Tx_Byte;


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

dma_word_controller  #(.SIZE_BIT(5)) dma_word_controller_inst
 (
  .i_Clock(clk),
  .i_Reset(rst_n),//Dummy?
  .i_Control(o_dma_type),
  .i_Bus_Grant(o_dma_grant),
  .bram_pointer(o_dma_addr),
  
  .o_Read_Flag(w_read_flag_dma),
  .i_uart_rx(w_Rx_Byte),
  
  .o_Tx_Send(w_Tx_Send_dma),
  .o_uart_tx(w_Tx_Byte_dma),
  .o_uart_tx_dv(w_Tx_DV_dma),
  .i_Data_Counter(o_dma_count),
  .i_Tx_Done(w_Tx_Done),
  .w_Acknowlege(dma_ack),
  .r_SM_Main(dma_state),
  
  .i_bram_read_b(doutb),
  .o_bram_write_b(dinb),
  .o_web(web),
  .o_bram_addr(addrb)
 );
 
    uart_fifo_tx #(.CLKS_PER_BIT(c_CLKS_PER_BIT)) UART_TX_INST
    (.i_Clock(clk),
     .i_Reset(rst_n),
     //.i_Tx_Send(r_Tx_Send),
     .i_Tx_Send(w_Tx_Send_dma),
     //.i_Tx_DV(r_Tx_DV),
     .i_Tx_DV(w_Tx_DV_dma),
     //.i_Tx_Byte(r_Tx_Byte),
     .i_Tx_Byte(w_Tx_Byte_dma),
     .o_Tx_Active(),
     .o_Tx_Serial(w_Tx_Byte),
     .o_Tx_Done(w_Tx_Done),
     //.o_Tx_Byte(o_byte)
     .r_SM_Main(state_tx)
     );
     
  uart_fifo_rx #(.CLKS_PER_BIT(c_CLKS_PER_BIT)) UART_RX_INST
    (.i_Clock(clk),
     .i_Reset(rst_n),
     //.i_Rx_Serial(r_Rx_Serial),
     .i_Rx_Serial(w_Tx_Byte),
     .o_Rx_DV(),
     .o_Rx_Byte(w_Rx_Byte),
     //.i_Read_Flag(r_read_flag),
     .i_Read_Flag(w_read_flag_dma),
     .r_SM_Main(state_rx)
     ); 
endmodule