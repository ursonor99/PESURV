`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.02.2021 18:56:57
// Design Name: 
// Module Name: f_a
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


module f_a(
i_a,
i_b,
i_c_in,
o_sum,
o_carry
    );
    input i_a,i_b,i_c_in;
    output o_sum,o_carry;
    assign o_sum=i_a^i_b^i_c_in;
    assign o_carry=(i_a&i_b) | (i_b&i_c_in) | (i_c_in&i_a);
    
    
    
    
endmodule
