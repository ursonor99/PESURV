`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.05.2021 12:24:44
// Design Name: 
// Module Name: regs_sim
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


module regs_sim(

    );
reg clk=1'b0;
reg rst_n=1'b1;
reg[4:0] rs1_addr;
reg[4:0] rs2_addr;
reg[4:0] rd_addr;
reg[31:0] rd_data;
reg write_en;

wire[31:0] rs1_data;
wire[31:0] rs2_data;    
    
regs uut (clk,rst_n,rs1_addr,rs2_addr,rd_addr,rd_data,write_en,rs1_data,rs2_data);

always #5 clk= !clk;

initial
begin
#10
write_en=1'b1;
#10
rd_addr <= 5'b00001;
rd_data <= 32'h00000001;
#10
rd_addr <= 5'b00101;
rd_data <= 32'h00000fff;
#10
write_en<=1'b0;
rs1_addr<=5'b00001;
rs2_addr<=5'b00101;
#10
rs1_addr<=5'b00000;
rs2_addr<=5'b00110;

#10
write_en=1'b1;
rd_addr <= 5'b00010;
rd_data <= 32'h00000f0f;
rs1_addr <= 5'b00010;

#10
rst_n<=1'b0;
#10
rst_n<=1'b1;
rs1_addr<=5'b00000;
rs2_addr<=5'b00110;


end    
    
    

endmodule
