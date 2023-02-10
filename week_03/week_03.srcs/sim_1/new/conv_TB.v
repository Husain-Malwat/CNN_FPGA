`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.11.2022 17:40:50
// Design Name: 
// Module Name: conv_TB
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


module conv_TB();
    reg [7:0]data_in;
    reg reset;
    reg clk_in;
    wire data_out;
    
    initial begin
        clk_in=0;
        forever 
            #1 clk_in=~clk_in;
    end
    conv cc(clk_in, reset, data_in, data_out);
    initial begin
    
        reset=0;
        //data_in=8'b0;
        #5;
        reset=1;
        //data_in=8'b0;
        #5;
        reset=0;
        data_in=8'b0;
        #5;
        
        
        $finish;
    end
endmodule
