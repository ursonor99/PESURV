`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.02.2021 19:24:52
// Design Name: 
// Module Name: ripple_tb
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



module ripple_tb ();
 
  parameter WIDTH = 4;
 
  reg [WIDTH-1:0] r_ADD_1 = 0;
  reg [WIDTH-1:0] r_ADD_2 = 0;
  wire [WIDTH:0]  w_RESULT;
   
  ripple ripple_carry_inst
    (
     .i_add_term1(r_ADD_1),
     .i_add_term2(r_ADD_2),
     .o_result(w_RESULT)
     );
 
  initial
    begin
      #10;
      r_ADD_1 = 4'b0000;
      r_ADD_2 = 4'b0001;
      #10;
      r_ADD_1 = 4'b1010;
      r_ADD_2 = 4'b0101;
      #10;
      r_ADD_1 = 4'b0001;
      r_ADD_2 = 4'b0111;
      #10;
      r_ADD_1 = 4'b1100;
      r_ADD_2 = 4'b1001;
      #10;$finish;
    end
 
endmodule