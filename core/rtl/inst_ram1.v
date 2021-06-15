`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/20/2021 05:08:11 PM
// Design Name: 
// Module Name: inst_ram1
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


module inst_ram1#(
    parameter w=32,
    parameter h=8)(
    clk,
    inst_data,
    pc,
    re,
    is_write,
    //im_addr,
    im_inst
    //im_dout
    //im_dout2
   
    );
    input         clk;
    output [w-1:0] inst_data;

    //from pc 
    input [w-1:0]  pc;
    input         re;
    input        is_write;

    //ext input
    input [w-1:0] im_addr;
    input [w-1:0] im_inst;
    //output[31:0] im_dout;
    //output[31:0] im_dout2;
    
    wire[w-1:0] shifted_addr_pc;
    assign shifted_addr_pc[w-1:0]=pc>>2;

    wire[w-1:0] shifted_addr_load;
    assign shifted_addr_load[w-1:0]=pc>>2;
    
integer i=0;
(* ram_style = "block" *)reg [w-1:0] inst[2**h-1:0];


always@(posedge clk)begin
    if(is_write)begin
        inst[shifted_addr_load][w-1:0]<=im_inst[w-1:0];
        $display("%h %h %h %h",shifted_addr_pc[w-1:0],shifted_addr_load[w-1:0],im_inst[w-1:0],inst[shifted_addr_load][w-1:0]);
        
    end
    
end
begin
assign inst_data[w-1:0]=(re)?inst[shifted_addr_pc][w-1:0]:2'h00;

end


endmodule