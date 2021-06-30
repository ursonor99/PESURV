`timescale 1ns/1ps


`include "GLOBALS.v"



module alu (
    input wire[4:0] i_alu_operator,
    input  wire[31:0] i_alu_operand_1,
    input  wire[31:0] i_alu_operand_2,
    output wire[31:0] o_alu_output,
    output wire o_alu_br_cond
);
wire [32:0] r_adder_out;
wire [32:0] r_substract_out;
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
                


wire[31:0] lsl_val;
wire[31:0] lru_val;
wire[31:0] lra_val;
wire[31:0] add_val;
wire[31:0] sub_val;
wire[31:0] and_val;
wire[31:0] or_val;
wire[31:0] xor_val;
wire[31:0] sltu_val;
wire[31:0] slt_val;


assign lsl_val = i_alu_operand_1 << i_alu_operand_2[4:0];
assign lru_val = i_alu_operand_1 >> i_alu_operand_2[4:0];
assign lra_val = $signed(i_alu_operand_1) >>> $signed(i_alu_operand_2[4:0]);
assign add_val = r_adder_out[31:0];
assign sub_val = r_substract_out[31:0];
assign and_val = i_alu_operand_1 & i_alu_operand_2;
assign or_val = i_alu_operand_1 | i_alu_operand_2;
assign xor_val = i_alu_operand_1 ^ i_alu_operand_2;
assign sltu_val = i_alu_operand_1 < i_alu_operand_2;
assign slt_val = $signed(i_alu_operand_1) < $signed(i_alu_operand_2);


assign o_alu_output = i_alu_operator == `PASSTHROUGH_RS1 ? i_alu_operand_1 :
                      i_alu_operator == `LSL             ? lsl_val         :
                      i_alu_operator == `LSR_UNSIGN      ? lru_val         :
                      i_alu_operator == `LSR_SIGN        ? lra_val         :
                      i_alu_operator == `ADD             ? add_val         :
                      i_alu_operator == `SUB             ? sub_val         :
                      i_alu_operator == `AND             ? and_val         :
                      i_alu_operator == `OR              ? or_val          :
                      i_alu_operator == `XOR             ? xor_val         :
                      i_alu_operator == `SLT_UNSIGN      ? sltu_val         :
                      i_alu_operator == `SLT_SIGN        ? slt_val        :
                      i_alu_operator == `PASSTHROUGH_RS2 ? i_alu_operand_2 :
                      32'b0;
                      
                      
                      
assign o_alu_br_cond = i_alu_operator == `BR_EQ && sub_val==32'b0   ?  1'b1 :
                       i_alu_operator == `BR_NE && sub_val!=32'b0   ?  1'b1 :
                       i_alu_operator == `BR_LTS && slt_val==32'b1  ?  1'b1 :
                       i_alu_operator == `BR_LTU && sltu_val==32'b1 ?  1'b1 :
                       i_alu_operator == `BR_GES && slt_val==32'b0  ?  1'b1 :
                       i_alu_operator == `BR_GEU && sltu_val==32'b0 ?  1'b1 :
                       1'b0;
//always @(*) 
//begin

//    case (i_alu_operator)
//        4'b0000:
//            begin
//                o_alu_output <=i_alu_operand_1;
          
//            end
//        4'b0001:
//            begin
//              o_alu_output <= i_alu_operand_1 << i_alu_operand_2[4:0];
//            end 
//        4'b0010:
//            begin
//              o_alu_output <= i_alu_operand_1 >> i_alu_operand_2[4:0];
//            end
//        4'b0011:
//            begin
//              o_alu_output <= $signed(i_alu_operand_1) >>> $signed(i_alu_operand_2[4:0]);
//            end
//        4'b0100:
//            begin
//              o_alu_output <=r_adder_out[31:0];
//            end
//        4'b0101:
//            begin
//               o_alu_output <=r_substract_out[31:0];
//            end
        
//        4'b0110:
//            begin
//              o_alu_output <= i_alu_operand_1 & i_alu_operand_2;
//            end
        
//        4'b0111:
//            begin
//              o_alu_output <= i_alu_operand_1 | i_alu_operand_2;
//            end
//        4'b1000:
//            begin
//              o_alu_output <= i_alu_operand_1 ^ i_alu_operand_2;
//            end
        
//        4'b1001:
//            begin
//              o_alu_output <= i_alu_operand_1 < i_alu_operand_2;
//            end
        
//        4'b1011:
//            begin
//              o_alu_output <= $signed(i_alu_operand_1) < $signed(i_alu_operand_2);
              
//            end
        
//        default: o_alu_output <=i_alu_operand_1;
//    endcase
    
//end



    
endmodule