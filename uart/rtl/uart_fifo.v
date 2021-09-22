`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/11/2021 04:09:12 PM
// Design Name: 
// Module Name: uart_fifo
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


module uart_fifo
#(
	parameter SIZE_BIT	= 5, // bits per word
	parameter WIDTH 	= 8  // words in the fifo
	)
(
    input  CLK,
    input  RST,
    input  read_flag,
    output [7:0] read_data,
    input  write_flag,
    input  [7:0] write_data,
    output empty, //to indicate that info cant be read
    output full,  // to indicate that info cant be written
    output reg [SIZE_BIT-1:0] w_ptr,
    output reg [SIZE_BIT-1:0] r_ptr
    );
    
    parameter SIZE = 1 << SIZE_BIT;
    reg [WIDTH-1:0] buffer[SIZE-1:0];
    //reg [SIZE_BIT-1:0] r_ptr; // independent of read pointer
    //reg [SIZE_BIT-1:0] w_ptr; // independent of writer pointer, it chases the write pointer around the fifo
    reg [SIZE_BIT:0] buffer_size;
    reg [WIDTH-1:0] r_read_value;

    integer i;
    
    //Generate indicators for the Tx and Rx modules
    assign empty = buffer_size==0;
    assign full = buffer_size==1<<SIZE_BIT;
    
    wire read,write;
    
    //Generate "valid condition" check 
    assign read = read_flag && !empty;
    assign write = write_flag && !full;
    
    //Drive the output byte, cant drive it within always loop
    assign read_data = buffer[r_ptr];
   
    //fifo operation
    always@(posedge CLK or posedge RST)
    
    if(RST)
        begin
        w_ptr<=0;
        r_ptr<=0;
        buffer_size<=0;
        for(i=0;i<(SIZE-1);i=i+1)
            buffer[i]<=8'hFF;
        end                  
    else 
        begin // The order of read first and write later is crucial
            $display("time =%0t   w_ptr = 0x%0h",$time,w_ptr);
            $display("time =%0t   r_ptr = 0x%0h",$time,r_ptr);
            
            if(read)
                begin
                r_ptr =r_ptr+1;
                buffer_size =buffer_size+1;
                end 
            if(write)
                begin
                buffer[w_ptr]  =write_data;
                w_ptr = w_ptr +1;
                buffer_size =buffer_size-1;
                end 
//            if(write && read)
//                begin
//                buffer[w_ptr] <=write_data;
//                r_ptr<=r_ptr+1;
//                w_ptr<= w_ptr +1;
//                end
//             else if(read)
//                begin
//                r_ptr<=r_ptr+1;
//                buffer_size<=buffer_size+1;
//                end
//             else if(write)
//                begin
//                buffer[w_ptr] <=write_data;
//                w_ptr<= w_ptr +1;
//                buffer_size<=buffer_size-1;
//                end               
            r_read_value <= buffer[r_ptr];
        end       
    //assign read_data = r_read_value; 
endmodule