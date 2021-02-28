`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.02.2021 12:24:04
// Design Name: 
// Module Name: blink
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


module blink(
clk,
en,
s1,
s2,
led
    );
    
    
input clk,en,s1,s2;
output led;

reg selected_out=1'b0;

reg[31:0] counter_25=0;    
reg[31:0] counter_10=0;
reg[31:0] counter_5=0;
reg[31:0] counter_1=0;

reg toggle25=1'b0;
reg toggle10=1'b0;
reg toggle5=1'b0;
reg toggle1=1'b0;

parameter val25=500;
parameter val10=1250;
parameter val5=2500;
parameter val1=12500;


always @(posedge clk)
    begin
    if(counter_25==val25-1)
        begin
            toggle25<=!toggle25;
            counter_25=0;
        end 
    else
        counter_25<=counter_25+1;
    end

assign led=en & toggle25;
    
endmodule
