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
    data_reg,
    sign
    );
    

    input   wire          clk;
    input   wire   [w-1:0]  ram_wdat;
    input   wire          ram_we;
    input   wire  [l-1:0]   ram_type;
    input   wire   [w-1:0]  ram_addr;
    input   wire            ram_re;
    output  reg     [w-1:0] data_reg;
    input wire sign;
    

wire [w-1:0] data;

//wire unsign=1'b1;

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
                
            $display(Bram[address1]);
           
         end

end


always@*
    begin:outputk
    
//    reg  [w-1:0] douta_reg={w{1'b0}};
  //always@(posedge clk)
    if(sign)
        begin
        case(ram_type)  
                  4'b0001:data_reg[31:0]={{24{Bram[address1][7]}},Bram[address1]};
                  4'b0010:data_reg[31:0]={{16{Bram[address2][7]}},Bram[address2],Bram[address1]};                                                                         
                  4'b0100:data_reg[31:0]={{8{Bram[address3][7]}},Bram[address3],Bram[address2],Bram[address1]};                                            
                  4'b1000:data_reg[31:0]={Bram[address4],Bram[address3],Bram[address2],Bram[address1]};
         endcase 
         end        
   else
        begin
        case(ram_type)
                4'b0001:data_reg[31:0]={24'b0,Bram[address1]};
                4'b0010:data_reg[31:0]={16'b0,Bram[address2],Bram[address1]};     
                4'b0100:data_reg[31:0]={8'b0,Bram[address3],Bram[address2],Bram[address1]};
                4'b1000:data_reg[31:0]={Bram[address4],Bram[address3],Bram[address2],Bram[address1]};                                                             
    
        endcase
   end
   
   
 end
   
                                                 

           

endmodule
