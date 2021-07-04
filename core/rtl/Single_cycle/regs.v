`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.05.2021 11:49:04
// Design Name: 
// Module Name: regs
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


module regs(
input i_clk,
input wire i_rst_n,
input wire[4:0] i_rs1_addr,
input wire[4:0] i_rs2_addr,
input wire[4:0] i_rd_addr,
input wire[31:0] i_rd_data,
input wire i_write_en,
output wire[31:0] o_rs1_data,
output wire[31:0] o_rs2_data
    );
    
    wire is_i_rs1_addr_zero;
    wire is_i_rs2_addr_zero;
    wire is_rd_fwd_rs1;
    wire is_rd_fwd_rs2;
    
    
    //reg allocation and initialization
    reg[31:0] reg_x[31:1];
    
    
    integer i;
    initial
        begin
            for(i=1;i<32;i=i+1)
                reg_x[i]<=32'b0;  
        end
        
        
        
    //reset
    always@(negedge i_rst_n)
    begin
    for(i=1;i<32;i=i+1)
                reg_x[i]<=32'b0;  
    end
    
    
    
    
    //write
    always@(posedge i_clk)
    begin
    if(i_write_en==1'b1 &&  i_rd_addr != 5'b00000)
            reg_x[i_rd_addr]<=i_rd_data;
            $display("writing to reg address %b the value %b",i_rd_addr,reg_x[i_rd_addr]);
            
        
    end
    
    
    assign is_i_rs1_addr_zero= i_rs1_addr==5'b00000;
    assign is_i_rs2_addr_zero= i_rs2_addr==5'b00000;
    
    assign is_rd_fwd_rs1= (i_rs1_addr==i_rd_addr) && (i_write_en==1);
    assign is_rd_fwd_rs2= (i_rs2_addr==i_rd_addr) && (i_write_en==1);
    
    assign o_rs1_data = is_i_rs1_addr_zero==1 ? 32'b0 : is_rd_fwd_rs1==1? i_rd_data : reg_x[i_rs1_addr];
    assign o_rs2_data = is_i_rs2_addr_zero==1 ? 32'b0 : is_rd_fwd_rs2==1? i_rd_data : reg_x[i_rs2_addr];
    
    
    
endmodule
