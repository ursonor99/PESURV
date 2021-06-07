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


module ram_2 #(
    parameter w=32,
    parameter h=8,
    parameter l=4
    )(
    clk,
    ram_wdat,
    ram_we,
    ram_type,
    ram_addr,
    ram_re,
    data_reg
    );
    

    input             clk;
    input     [w-1:0]  ram_wdat;
    input             ram_we;
    input     [l-1:0]   ram_type;
    input      [w-1:0]  ram_addr;
    input               ram_re;
    output     [w-1:0] data_reg;

wire [h-1:0] address1;
wire [h-1:0] address2;
wire [h-1:0] address3;
wire [h-1:0] address4;

 
(* ram_style = "block" *)reg [h-1:0] Bram [2**h-1:0];
//reg [w-1:0] ram_data={w{1'b0}};
//always@(posedge clk)

assign address1 = ram_addr+1'b0;
assign  address2 =ram_addr+1'b1;
assign address3=ram_addr+2'b10;
assign address4=ram_addr+2'b11;





always@(posedge clk)

begin
        if(ram_we)begin
            if(ram_type[0])
                Bram[address1][h-1:0] <=ram_wdat[h-1:0];
             
                
            if(ram_type[1])
                Bram[address2][h-1:0]<= ram_wdat[2*h-1:h];
                
           

            if(ram_type[2])
                Bram[address3][h-1:0] <=ram_wdat[3*h-1:2*h];
                
            

            if(ram_type[3])
                Bram[address4][h-1:0] <=ram_wdat[4*h-1:3*h];
                
            $display(Bram[address1][h-1:0]);
           
         end

end


    

    begin:outputk
//    reg  [w-1:0] douta_reg={w{1'b0}};
  //always@(posedge clk) 
  
    assign data_reg[7:0] = (ram_re && ram_type[0] && Bram[address1])?Bram[address1]:8'b0000000;
    assign data_reg[15:8]=(ram_re && ram_type[1] && Bram[address2])?Bram[address2]:8'b00000000; 
    assign data_reg[23:16]=(ram_re && ram_type[2] && Bram[address3])?Bram[address3]:8'b00000000;
    assign data_reg[31:24]=(ram_re && ram_type[3] && Bram[address4])?Bram[address4]:8'b00000000;
    
    
    end
                                                 

           

endmodule
