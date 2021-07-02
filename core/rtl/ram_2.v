
`timescale 1ns / 1ps
`include "GLOBALS.v"

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
    output  wire     [w-1:0] data_reg;
    input wire sign;
    



//wire unsign=1'b1;



 
(* ram_style = "block" *)reg [h-1:0] Bram [2**h-1:0];
//reg [w-1:0] ram_data={w{1'b0}};
//always@(posedge clk)

wire [h-1:0] address1;
wire [h-1:0] address2;
wire [h-1:0] address3;
wire [h-1:0] address4;
assign address1 = ram_addr+1'b0;
assign  address2 =ram_addr+1'b1;
assign address3=ram_addr+2'b10;
assign address4=ram_addr+2'b11;





always@(posedge clk)

begin
        if(ram_we)begin
            if(ram_type[0])
                Bram[address1]=ram_wdat[h-1:0];
             
                
            if(ram_type[1])
                Bram[address2]= ram_wdat[2*h-1:h];
                
           

            if(ram_type[2])
                Bram[address3]=ram_wdat[3*h-1:2*h];
                
            

            if(ram_type[3])
                Bram[address4]=ram_wdat[4*h-1:3*h];
                
            $display("ram2= %h %h %b %b %b %b ",{Bram[address4],Bram[address3],Bram[address2],Bram[address1]},address1,ram_type[3:0],ram_we,ram_re,sign);
           
         end

end


//read
reg[h-1:0] data1;
reg[h-1:0] data2;
reg[h-1:0] data3;
reg[h-1:0] data4;
always @(address1 || address2 || address3 || address4 || ram_re)
begin
data1=Bram[address1];
data2=Bram[address2];
data3=Bram[address3];
data4=Bram[address4];
end
/////////////////////////////////////////////////////////////////////////////////////////
//byte
wire [w-1:0]signedbyte;
wire [w-1:0]unsignedbyte;

//halfword
wire [w-1:0]signedhalfword;
wire [w-1:0]unsignedhalfword;

//threequaters
wire [w-1:0]signedthreequaters;
wire [w-1:0]unsignedthreequaters;

//fullword
wire [w-1:0]fullword;

//////////////////////////////////////////////////////////////////////////////////
//sign extension
assign signedbyte={{24{data1[7]}},data1};
assign unsignedbyte={24'b0,data1};
assign signedhalfword={{16{data2[7]}},data2,data1};           
assign unsignedhalfword={16'b0,data2,data1};
assign signedthreequaters={{8{data3[7]}},data3,data2,data1};
assign unsignedthreequaters={8'b0,data3,data2,data1};
assign fullword={data4,data3,data2,data1};


assign data_reg=(sign==1 && ram_type==`BYTE && ram_re==1)?signedbyte:
                (sign==0 && ram_type==`BYTE && ram_re==1)?unsignedbyte:
                (sign==1 && ram_type==`HALFWORD && ram_re==1)?signedhalfword:
                (sign==0 && ram_type==`HALFWORD && ram_re==1)?unsignedhalfword:
                (sign==1 && ram_type==`THREEQUATER && ram_re==1)?signedthreequaters:
                (sign==0 && ram_type==`THREEQUATER && ram_re==1)?unsignedthreequaters:
                ((sign==0 || sign==1) && ram_type==`FULLWORD && ram_re==1)?fullword:
                32'h0;




   
                                                 

           

endmodule


