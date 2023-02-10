`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.11.2022 00:50:09
// Design Name: 
// Module Name: maxpool
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

module maxpool(clk, data, out,reset);
parameter C=16,H=28,W=28;
parameter Z=C*W*H/4;
parameter bit=8;

 
input clk;
input reset;
output reg[Z*bit-1:0] out;
input [C*W*H*bit-1:0] data;
reg [7:0]temp[0:C-1][0:H-1][0:W-1];
reg y;
integer w=0,h=0,c=0,k=0,m=0,n=0;


always@(posedge clk, negedge reset)    
    begin
    if(!reset)begin
        out<=0;
        y=0; end
    else
    begin
        case(y)
        0: begin
            if(c<C)
            begin
                if(h<H)
                begin
                    if(w<W)
                    begin
                        temp[c][h][w]= data[k+:bit];
                        k=k+bit;
                        w=w+1;
                    end
                    else
                    begin
                        w=0;h=h+1;
                    end
                end 
                else
                begin
                    w=0;h=0;c=c+1;
                end
            end
            else 
            begin
                c=0;h=0;w=0;k=0;
            end 
        end
       1:
       begin 
            if(c<C)
            begin
                if(m<H) 
                begin
                    if(n<W) 
                    begin
                        out[k+:bit] = (temp[c][m][n]>=temp[c][m][n+1]&temp[c][m][n]>=temp[c][m+1][n]&temp[c][m][n]>=temp[c][m+1][n+1])?temp[c][m][n]:(temp[c][m+1][n]>=temp[c][m][n]&temp[c][m+1][n]>=temp[c][m][n+1]&temp[c][m+1][n]>=temp[c][m+1][n+1])?temp[c][m+1][n]:(temp[c][m][n+1]>=temp[c][m][n]&temp[c][m][n+1]>=temp[c][m+1][n]&temp[c][m][n+1]>=temp[c][m+1][n+1])?temp[c][m][n+1]:temp[c][m+1][n+1];
                        k=k+bit;
                        n=n+2;
                    end     
                    else 
                    begin
                        m=m+2; n=0;
                    end
                end
                else
                begin
                    m=0;c=c+1;n=0;
                end
            end
            else
            begin
                m=0;c=0;n=0;k=0;
            end 
        end
        default:y=0;
        endcase
    end
end
endmodule
