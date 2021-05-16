`timescale 1ns / 1ps

`include "GLOBALS.v"

module branch_tb(

    );
    
    
reg br_cond =1'b0;
reg[31:0] j_b_addr;
reg[1:0] b_type ;
wire is_br;
wire[31:0] br_addr;

branch uut (br_cond , j_b_addr , b_type , is_br, br_addr);

initial 
begin
b_type<=2'b0;
#10
b_type<= `JAL;
j_b_addr<=32'h00004000;
#10
b_type<= `JALR;
j_b_addr<=32'h00008011;
#10
b_type<= `BR;
br_cond=1'b0;
j_b_addr<=32'h0008400;
#10
b_type<= `BR;
br_cond=1'b1;
j_b_addr<=32'h0074000;

end
endmodule
