`timescale 1ns / 1ps

module f_a_tb();

reg r_a,r_b,r_cin;
wire w_sum,w_carry;

f_a UUT(r_a,r_b,r_cin,w_sum,w_carry);


initial
    begin
        r_a=1'b0;r_b=1'b0;r_cin=1'b0; #10
        r_a=1'b0;r_b=1'b0;r_cin=1'b1; #10
        r_a=1'b0;r_b=1'b1;r_cin=1'b0; #10
        r_a=1'b0;r_b=1'b1;r_cin=1'b1; #10
        r_a=1'b1;r_b=1'b0;r_cin=1'b0; #10
        $finish;
end

endmodule