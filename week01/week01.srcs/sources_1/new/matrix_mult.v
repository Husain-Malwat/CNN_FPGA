`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.10.2022 16:01:52
// Design Name: 
// Module Name: matrix_mult
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


module matrix_mult
    (   input clk,
        input res, //active high reset
        input En,   
        input [0:71] A,
        input [0:71] B,
        output reg [0:71] C,
        output reg done     //A High indicates that multiplication is done and result is availble at C.
    );   
	parameter n=3;
//temporary registers. 
reg  [7:0] matA [0:2][0:2];
reg [7:0] matB [0:2][0:2];
reg [7:0] matC [0:2][0:2];
integer i,j; 
reg [15:0] temp; 

always @(posedge clk or posedge res)    
begin
    if(res == 1) 
    begin    //Active high reset
        i = 0;
        j = 0;
        
        temp = 0;
        
        done = 0;
        
        for(i=0;i<=2;i=i+1) 
        begin
            for(j=0;j<=2;j=j+1) 
            begin
                matA[i][j] = 8'd0;
                matB[i][j] = 8'd0;
                matC[i][j] = 8'd0;
            end 
        end 
    end
    else 
    begin  
        if(En == 1) 
        begin    
            for(i=0;i<=2;i=i+1) 
            begin
                for(j=0;j<=2;j=j+1) 
                begin
                    matA[i][j] = A[((i*3)+j)*8+:8];
                    matB[i][j] = B[((i*3)+j)*8+:8];
                    matC[i][j] = 8'd0;
                end
            end
            temp = 0;
            i = 0;
            j = 0;   
        end
        else
        begin
             for(i=0;i<=2;i=i+1) 
             begin   
                for(j=0;j<=2;j=j+1) 
                begin
                    matC[i][j] = (matA[i][j]*matB[i][j]);
//                    matC[i][j] =  temp[7:0];    
                   
                    C[((i*3)+j)*8+ : 8] = matC[i][j];
                end
            end   
            done = 1;   //Set this output High, to say that C has the final result.
        end
    end
end
 
endmodule
