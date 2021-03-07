`timescale 1ns/1ps


module alu (
    input [3:0] i_alu_operator,
    input  [31:0] i_alu_operand_1,
    input  [31:0] i_alu_operand_2,
    output reg[31:0] o_alu_output
);
wire [31:0] r_adder_out;
wire [31:0] r_substract_out;
wire [31:0] i_alu_operand_2_comp;
carry_lookahead_adder uut1
                (
                .i_add1(i_alu_operand_1),
                .i_add2(i_alu_operand_2),
                .o_result(r_adder_out)
                );
                
assign i_alu_operand_2_comp=((~i_alu_operand_2)+1);

carry_lookahead_adder  uut2
                (
                .i_add1(i_alu_operand_1),
                .i_add2(i_alu_operand_2_comp),
                .o_result(r_substract_out)
                );
                



always @(*) 
begin

    case (i_alu_operator)
        4'b0000:
            begin
                $display("no op");
          
            end
        4'b0001:
            begin
              o_alu_output <=i_alu_operand_1 << i_alu_operand_2[4:0];
            end 
        4'b0010:
            begin
              o_alu_output <= i_alu_operand_1 >> i_alu_operand_2[4:0];
            end
        4'b0011:
            begin
              o_alu_output <= $signed(i_alu_operand_1) >>> $signed(i_alu_operand_2[4:0]);
            end
        4'b0100:
            begin
              o_alu_output <=r_adder_out;
            end
        4'b0101:
            begin
               o_alu_output <=r_substract_out;
            end
        
        4'b0110:
            begin
              o_alu_output <= i_alu_operand_1 & i_alu_operand_2;
            end
        
        4'b0111:
            begin
              o_alu_output <= i_alu_operand_1 | i_alu_operand_2;
            end
        4'b1000:
            begin
              o_alu_output <= i_alu_operand_1 ^ i_alu_operand_2;
            end
        
        4'b1001:
            begin
              o_alu_output <= i_alu_operand_1 < i_alu_operand_2;
            end
        
        4'b1011:
            begin
              o_alu_output <= $signed(i_alu_operand_1) < $signed(i_alu_operand_2);
              
            end
        
        default: o_alu_output=1;
    endcase
    
end



    
endmodule