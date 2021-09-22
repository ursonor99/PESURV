`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/21/2021 01:32:46 AM
// Design Name: 
// Module Name: Dma_UartRx
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


module Dma_UartRx(

    );
   parameter c_CLOCK_PERIOD_NS = 4;
   parameter c_CLKS_PER_BIT    = 4;
   parameter c_BIT_PERIOD      = 16;
   
   
   
    reg r_Clock = 0;
    reg r_Reset = 0;
    reg r_read_flag =0;
    
    reg [1:0] w_control  = 2'b01;
    reg r_Bus_Grant = 1'b1;
    reg r_Rx_Serial = 0;
    reg [5:0] r_dma_byte_count=0;
    reg [1:0] r_control= 2'b10;
    reg r_Rx_Serial_Parity =0;
    
    wire [31:0] w_bram_pointer = 32'hFFFFFFFF;
    wire [7:0] w_Rx_Byte;
    
    wire w_read_flag_dma;
    wire w_Tx_Send_dma; 
    wire [7:0] w_Tx_Byte_dma;
    wire w_Tx_DV_dma;
    wire [2:0] State;
    wire w_Tx_Done = 0;
    wire [2:0] dma_state;
    wire [2:0] state;
    


  task UART_WRITE_BYTE;
    input [7:0] i_Data;
    integer     ii;
    begin
       
      // Send Start Bit
      r_Rx_Serial <= 1'b0;
      #(c_BIT_PERIOD);
       
       
      // Send Data Byte
      for (ii=0; ii<8; ii=ii+1)
        begin
          r_Rx_Serial <= i_Data[ii];
          r_Rx_Serial_Parity <= r_Rx_Serial_Parity^r_Rx_Serial;
          #(c_BIT_PERIOD);
        end
       
      //Send Parity Bit 
      r_Rx_Serial <= r_Rx_Serial_Parity;
       #(c_BIT_PERIOD);
      // Send Stop Bit
      r_Rx_Serial <= 1'b1;
      #(c_BIT_PERIOD);
     end
  endtask // UART_WRITE_BYTE
   
   
  uart_rx_fifo #(.CLKS_PER_BIT(c_CLKS_PER_BIT)) UART_RX_INST
    (.i_Clock(r_Clock),
     .i_Reset(r_Reset),
     .i_Rx_Serial(r_Rx_Serial),
     //.i_Rx_Serial(w_Tx_Byte),
     .o_Rx_DV(),
     .o_Rx_Byte(w_Rx_Byte),
     //.i_Read_Flag(r_read_flag),
     .i_Read_Flag(w_read_flag_dma),
     .r_SM_Main(state)
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
    #2 r_Clock <= !r_Clock;
 
 
 //assign  w_Rx_Byte = 8'h55;
 
 reg [7:0] r_test_wire_write;
 initial
    begin
    r_Bus_Grant<=1'b0;
    //r_Rx_Serial <= 1'b0;
    r_Reset<=1'b1;
    
    @(posedge r_Clock)
    
    r_Reset <=1'b0;
    @(posedge r_Clock)
    //r_Tx_DV <= 1'b1;
    UART_WRITE_BYTE(8'hC9);
    @(posedge r_Clock)
    r_test_wire_write <= w_Rx_Byte;
    UART_WRITE_BYTE(8'h05);
    @(posedge r_Clock)
    UART_WRITE_BYTE(8'hC9);
    r_Bus_Grant<=1'b1;
    @(posedge r_Clock);
    r_dma_byte_count<=6'b000010;
    r_Bus_Grant <=1'b0;
    // Check that the correct command was received
    #24;
    if (w_Rx_Byte == 8'h05)
      $display("Test Passed - Correct Byte Received");
    else
      $display("Test Failed - Incorrect Byte Received");
    
    
    end
    
endmodule
