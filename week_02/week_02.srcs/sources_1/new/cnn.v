`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.11.2022 15:04:01
// Design Name: 
// Module Name: cnn
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
module cnn(input clk,input rst, input [7:0]op,input[7:0]dim, input [7:0]img, output [3:0]class);
reg [3:0]state;
reg[2:0]internalState;
reg [7:0]W,w;
reg [7:0]H,h;
reg [7:0]R,r;
reg [7:0]S,s;
reg [7:0]C,c;
reg [7:0]M,m;
reg P;
reg Q;
reg p,q;
reg [7:0]convShapeIn,MaxpoolShapeIn,denseShapeIn;
reg [7:0]inputarray[0:32*32*3-1];
reg [7:0]result[0:30*30-1];
integer counter=0;

always @(posedge clk, negedge rst)
begin
if(!rst)
begin
state<=4'b0;
internalState<=0;
counter=0;
end
else
begin
case(state)
0 : begin
    if(op==0)
    begin
        convShapeIn=1;
        MaxpoolShapeIn=0;
        denseShapeIn=0;
        state=1;
    end
    else if(op==1)
    begin
        convShapeIn=0;
        MaxpoolShapeIn=1;
        denseShapeIn=0;
    //state=
    end
    else
    begin
        convShapeIn=0;
        MaxpoolShapeIn=0;
        denseShapeIn=1;
    //state=
    end
end
1 : begin
    
    case(internalState)
        0:
        begin 
            W=dim;
            internalState=1; 
        end
        1:begin H=dim; internalState=2; end
        2:begin R=dim; internalState=3; end
        3:begin S=dim; internalState=4; end
        4:begin C=dim; internalState=5; end
        5:begin M=dim; internalState=0; state=state+1; end
    endcase
    end
    
 2 : begin
        if(counter<W*C*H)
        begin
            inputarray[counter]=img;
            counter=counter+1;
        end
        else
        begin
            counter=0;
            state=state+1;
        end
    end
3 : begin w=0;h=0;r=0;s=0;c=0;m=0;p=0;q=0;result[P*Q*q+P*p+m]=0; end

4 : begin
    result[P*Q*q+P*p+m]=result[P*Q*q+P*p+m]+inputarray[H*W*h+W*w+c];
    if(w<W) w=w+1;
    else 
    begin 
        w=0; 
        if(h<H) 
            h=h+1; 
        else 
        begin 
            h=0;
            if(c<C) 
                c=c+1; 
            else
            begin 
                c=0;
                q=q+1;
                result[P*Q*q+P*p+m]=0; 
                if(q<Q) 
                    q=q+1; 
                else 
                begin
                    q=0;
                    if(p<P)
                        p=p+1;
                        else 
                        begin 
                            p=0; 
                            if(m<M) 
                                m=m+1; 
                                else 
                                begin 
                                    m=0;
                                    state=state+1; 
                                end 
                        end 
                end 
            end 
        end 
    end
    end
endcase
end
end
endmodule
