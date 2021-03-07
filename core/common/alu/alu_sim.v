`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.03.2021 10:02:22
// Design Name: 
// Module Name: alu_sim
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


module alu_sim();

reg [31:0 ] r_input_1=31'b0;
reg [31:0 ] r_input_2=31'b0;
reg [3:0] r_operator=4'b0000;
wire [31:0] w_output ;

alu uut(.i_alu_operator(r_operator),.i_alu_operand_1(r_input_1),.i_alu_operand_2(r_input_2),.o_alu_output(w_output));

initial
    begin
        #10
        r_input_1=32'b11110000000000000000000000000011;
        r_input_2=32'b00000000000000000000000000000011;
        r_operator=4'b0000;
        #200 
            r_operator=4'b0001;
        #200 
            r_operator=4'b0010;
        #200 
            r_operator=4'b0011;
        #200
            r_input_1=32'b00000001111111111111111000000000;
            r_input_2=32'b00000000000000000000000000001111;
            r_operator=4'b0100;
        #200
            r_input_1=32'b00000000000000000000000001111111;
            r_input_2=32'b00000000000000000000000000001111;
            r_operator=4'b0101;
        #200 
            r_operator=4'b0110;
        #200 
            r_operator=4'b0111;
        #200 
            r_operator=4'b1000;
        
        #200
            r_input_2=32'b11111000000000000000000000000011;
            r_input_1=32'b00000000000000000000000001111111;
            r_operator=4'b1010;
        #200 
            r_operator=4'b1011;    
        
    end
        
 

endmodule
