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

    
    
    
    
    //write
    always@(posedge i_clk)
    begin
    if(i_rst_n==0)
    begin
    for(i=1;i<32;i=i+1)
                reg_x[i]<=32'b0;  
    end
    else if(i_write_en==1'b1 &&  i_rd_addr != 5'b00000)
    begin
            reg_x[i_rd_addr]<=i_rd_data;
            //$display("writing to reg address %b the value %b",i_rd_addr,reg_x[i_rd_addr]);


    end        
        //$display("%h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h",reg_x[1],reg_x[2],reg_x[3],reg_x[4],reg_x[5],reg_x[6],reg_x[7],reg_x[8],reg_x[9],reg_x[10],reg_x[11],reg_x[12],reg_x[13],reg_x[14],reg_x[15],reg_x[16],reg_x[17],reg_x[18],reg_x[19],reg_x[20],reg_x[21],reg_x[22],reg_x[23],reg_x[24],reg_x[25],reg_x[26],reg_x[27],reg_x[28],reg_x[29],reg_x[30],reg_x[31],reg_x[32]);
    end
    
    
    assign is_i_rs1_addr_zero= i_rs1_addr==5'b00000;
    assign is_i_rs2_addr_zero= i_rs2_addr==5'b00000;
    
////    assign is_rd_fwd_rs1= (i_rs1_addr==i_rd_addr) && (i_write_en==1);
////    assign is_rd_fwd_rs2= (i_rs2_addr==i_rd_addr) && (i_write_en==1);
    
//    assign o_rs1_data = is_i_rs1_addr_zero==1 ? 32'b0 :  reg_x[i_rs1_addr];
//    assign o_rs2_data = is_i_rs2_addr_zero==1 ? 32'b0 : reg_x[i_rs2_addr];
    
assign is_rd_fwd_rs1= (i_rs1_addr==i_rd_addr) && (i_write_en==1);
assign is_rd_fwd_rs2= (i_rs2_addr==i_rd_addr) && (i_write_en==1);
    
    assign o_rs1_data = is_i_rs1_addr_zero==1 ? 32'b0 : is_rd_fwd_rs1==1? i_rd_data : reg_x[i_rs1_addr];
assign o_rs2_data = is_i_rs2_addr_zero==1 ? 32'b0 : is_rd_fwd_rs2==1? i_rd_data : reg_x[i_rs2_addr];  
    
endmodule
