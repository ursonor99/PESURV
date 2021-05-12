`timescale 1ns / 1ps


module pc_tb(

    );
    
reg clk=1'b0;
reg rst_n,stall,is_b_true,writing_first;
reg[31:0] b_addr,first_addr;
wire[31:0] pc ;
pc uut (clk,rst_n,stall,is_b_true,b_addr,writing_first,first_addr,pc);

always #5 clk <= !clk; 

initial

begin

rst_n<= 1'b1;
stall<=1'b0;
writing_first <= 1'b0;
is_b_true=1'b0;
#10
writing_first <=1'b1;
first_addr<=32'h00004000;
#10
writing_first <=1'b0;
#50
stall<=1'b1;
#20
stall<=1'b0;
is_b_true=1'b1;
b_addr<=32'h00004040;
#10
is_b_true=1'b0;
#20
rst_n<=1'b0;
#10
rst_n<=1'b1;
writing_first <=1'b1;
first_addr<=32'h00008040;
#10
writing_first <=1'b0;
#20;

end




endmodule
