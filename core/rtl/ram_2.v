`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2021 09:41:06 PM
// Design Name: 
// Module Name: ram_2
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


module ram_2(
    clk,
    rst_n,
    ram_wdat,
    ram_we,
    ram_type,
    ram_rd_store,
    ram_rd_load,
    ram_addr,
    ram_dout,
    ram_re,
    data_reg
    );

    input             clk;
    input             rst_n;
    input     [31:0]  ram_wdat;
    input             ram_we;
    input     [3:0]   ram_type;
    input             ram_rd_store;
    input             ram_rd_load;
    input      [31:0]  ram_addr;
    output     [31:0]  ram_dout;
    input              ram_re;
    output      [31:0] data_reg;
 
integer i=0;   
reg  [31:0] dram [0:255];
initial begin
    for(i=0;i<256;i=i+1)begin
        dram[i]=0;
        
        //$display(dram);
        end
end
//writie in the memory
always@(posedge clk)begin
    if(ram_we)begin
        if(ram_type[0])
            dram[ram_addr+8'h0][7:0]   <= ram_wdat[7:0];
        if(ram_type[1])
            dram[ram_addr+8'h1][15:8]  <= ram_wdat[15:8];
        if(ram_type[2])
            dram[ram_addr+8'h2][23:16] <= ram_wdat[23:16];
        if(ram_type[3])
            dram[ram_addr+8'h3][31:24] <= ram_wdat[31:24];
    end
    $display("%h %b %b",dram[ram_addr+8'h2],ram_addr,ram_addr+8'h3);
    
end

            
        

reg [31:0] ram_dout_tmp;
always@(*)
    if(ram_rd_store)begin
            ram_dout_tmp ={dram[ram_addr+8'h3][31:24],dram[ram_addr+8'h2][23:16],dram[ram_addr+8'h1][15:8],dram[ram_addr+8'h0][7:0]};
        end
    else
        ram_dout_tmp = 0;
assign ram_dout = ram_dout_tmp;

//assign ram_dout = dram[ram_addr+1'h1];


////loading the value to register

assign data_reg[7:0]=(ram_re && ram_type[0])?dram[ram_addr+8'h0][7:0]:2'h00;
assign data_reg[15:8]=(ram_re && ram_type[1])?dram[ram_addr+8'h1][15:8]:2'h00;
assign data_reg[23:16]=(ram_re && ram_type[2])?dram[ram_addr+8'h2][23:16]:2'h00;
assign data_reg[31:24]=(ram_re && ram_type[3])?dram[ram_addr+8'h3][31:24]:2'h00;


 always@(*)
    if(ram_rd_load)begin
        ram_dout_tmp=data_reg[31:0];
    end
   else
        ram_dout_tmp=0;    
assign   ram_dout=ram_dout_tmp;

endmodule
