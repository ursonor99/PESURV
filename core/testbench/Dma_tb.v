`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/20/2021 10:58:54 PM
// Design Name: 
// Module Name: Dma_tb
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


module Dma_tb(

    );
    
    reg r_Clock = 0;
    reg r_Reset = 0;
    
    wire [1:0] w_control  = 2'b01;
    reg r_Bus_Grant = 1'b1;
    wire [31:0] w_bram_pointer = 32'hFFFFFFFF;
    
    
    wire w_read_flag_dma;
    wire w_Tx_Send_dma; 
    wire [7:0] w_Tx_Byte_dma;
    wire w_Tx_DV_dma;
    wire [2:0] State;
    
    wire [7:0] w_Rx_Byte;
    
DMA_controller_IO  DMA_controller_IO_INST
 ( .i_Clock(r_Clock),
  .i_Reset(r_Reset),//Dummy?
  .i_Control(w_control),
  .i_Bus_Grant(r_Bus_Grant),
  .bram_pointer(w_bram_pointer),
  
  .o_Read_Flag(w_read_flag_dma),
  .i_uart_rx(w_Rx_Byte),
  
  .o_Tx_Send(w_Tx_Send_dma),
  .o_uart_tx(w_Tx_Byte_dma),
  .o_uart_tx_dv(w_Tx_DV_dma),
  .i_Data_Counter(),
  
  .r_SM_Main(State)
  //.bram_read_port(),
  //.bram_write_port()
 );
 
 always
    #2 r_Clock <= !r_Clock;
 
 
 //assign  w_Rx_Byte = 8'h55;
 
 reg [7:0] r_test_wire_write;
 initial
    begin
    r_Bus_Grant<=1'b0;
    
    @(posedge r_Clock)
    r_Bus_Grant<=1'b1;
    
    @(posedge r_Clock)
    //r_Tx_DV <= 1'b1;
    r_test_wire_write <= w_Rx_Byte;
    end
endmodule
