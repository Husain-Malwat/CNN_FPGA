`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.10.2022 19:45:45
// Design Name: 
// Module Name: matrix_mult_TB
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


module matrix_mult_TB();


reg [0:71] A;
reg [0:71] B;
wire [0:71] C;
reg clk, res, En;

wire [7:0] matC[0:2][0:2];
wire done;

initial begin
    clk=0;
    forever #2 clk = ~clk;
end

matrix_mult m1(.clk(clk), 
        .res(res), 
        .En(En), 
        .A(A),
        .B(B), 
        .C(C),
        .done(done));

initial begin

    res = 1;
    
    #10;
    
    res = 0;
    En = 1;
    #20
        
    A = {8'd0,8'd0,8'd0,8'd1,8'd0,8'd0,8'd3,8'd2,8'd1};
    B = {8'd0,8'd0,8'd0,8'd2,8'd0,8'd0,8'd1,8'd0,8'd1};
    #100
    
    
    $finish;  
    end

endmodule