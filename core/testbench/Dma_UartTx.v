`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/21/2021 02:54:38 AM
// Design Name: 
// Module Name: Dma_UartTx
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


module Dma_UartTx(

    );
    parameter c_CLOCK_PERIOD_NS = 4;
  parameter c_CLKS_PER_BIT    = 4;
  parameter c_BIT_PERIOD      = 16;
    
    reg r_Clock = 0;
    reg r_Reset = 0;
    
    reg r_Tx_Send  = 0;
    reg r_Tx_DV = 0;
    reg [7:0] r_Tx_Byte = 0 ;
    
    reg [1:0] r_control  = 2'b01;
    reg r_Bus_Grant = 1'b1;
    wire [31:0] w_bram_pointer = 32'hFFFFFFFF;
    
    
    wire w_read_flag_dma;
    wire w_Tx_Send_dma; 
    wire [7:0] w_Tx_Byte_dma;
    wire w_Tx_DV_dma;
    wire [2:0] dma_state;
    wire [2:0] state;
    
    wire [7:0] w_Rx_Byte;
    wire w_Tx_Byte;
    wire w_Tx_Done;
    wire [7:0] fifo_top;
    reg [5:0] r_dma_byte_count;

 uart_tx_fifo #(.CLKS_PER_BIT(c_CLKS_PER_BIT)) UART_TX_INST
    (.i_Clock(r_Clock),
     .i_Reset(r_Reset),
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
     .r_SM_Main(state),
     .r_Read_Data(fifo_top)
     );
     
DMA_controller_IO  DMA_controller_IO_INST
 ( .i_Clock(r_Clock),
  .i_Reset(r_Reset),//Dummy?
  .i_Control(r_control),
  .i_Bus_Grant(r_Bus_Grant),
  .bram_pointer(w_bram_pointer),
  
  .o_Read_Flag(w_read_flag_dma),
  .i_uart_rx(w_Rx_Byte),
  
  .o_Tx_Send(w_Tx_Send_dma),
  .o_uart_tx(w_Tx_Byte_dma),
  .o_uart_tx_dv(w_Tx_DV_dma),
  .i_Data_Counter(r_dma_byte_count),
  .i_Tx_Done(w_Tx_Done),
  .r_SM_Main(dma_state)
  //.bram_read_port(),
  //.bram_write_port()
 );
 
 always
    #(c_CLOCK_PERIOD_NS/2) r_Clock <= !r_Clock;
 
 
 //assign  w_Rx_Byte = 8'h55;
 
 reg [7:0] r_test_wire_write;
 initial
    begin
    r_Bus_Grant<=1'b0;
    r_Reset<=1'b1;
    //r_Tx_Send<=1'b0;
    @(posedge r_Clock)
    r_Reset <=1'b0;
    r_control<=2'b11;
    r_Bus_Grant<=1'b1;
    r_dma_byte_count <= 6'b00010;
    @(posedge r_Clock)
    
    
    //r_Tx_DV <= 1'b1;
//    r_Tx_Byte <= 8'b01010101;
//    r_Tx_Send <=1'b1;
    
    r_Tx_DV <= w_Tx_DV_dma;
    r_Tx_Byte <= w_Tx_Byte_dma;
    r_Tx_Send <= w_Tx_Send_dma;

    @(posedge r_Clock)
    //r_Tx_DV <= 1'b1;
    r_test_wire_write <= w_Rx_Byte;
    //r_Tx_DV <= 1'b0;
    r_Bus_Grant<=1'b0;
    
    
    
   end
endmodule
