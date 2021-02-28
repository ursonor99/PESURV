`timescale 1ns / 1ps


module ripple(
    input [3:0]  i_add_term1,
    input [3:0]  i_add_term2,
    output [4:0] o_result
   );

  wire [4:0]    w_CARRY;
  wire [3:0]    w_SUM;
  assign w_CARRY[0] = 1'b0;
  
  f_a full_adder_1
    ( 
      .i_a(i_add_term1[0]),
      .i_b(i_add_term2[0]),
      .i_c_in(w_CARRY[0]),
      .o_sum(w_SUM[0]),
      .o_carry(w_CARRY[1])
      );
 
  f_a full_adder_2
    ( 
      .i_a(i_add_term1[1]),
      .i_b(i_add_term2[1]),
      .i_c_in(w_CARRY[1]),
      .o_sum(w_SUM[1]),
      .o_carry(w_CARRY[2])
      );
  f_a full_adder_3
    ( 
      .i_a(i_add_term1[2]),
      .i_b(i_add_term2[2]),
      .i_c_in(w_CARRY[2]),
      .o_sum(w_SUM[2]),
      .o_carry(w_CARRY[3])
      );
 
  f_a full_adder_4
    ( 
      .i_a(i_add_term1[3]),
      .i_b(i_add_term2[3]),
      .i_c_in(w_CARRY[3]),
      .o_sum(w_SUM[3]),
      .o_carry(w_CARRY[4])
      );
 assign o_result = {w_CARRY[4], w_SUM};
endmodule