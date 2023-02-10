`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.11.2022 01:56:05
// Design Name: 
// Module Name: confor
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


module confor(clk,data,fil,out,rst);
parameter bit=8;
parameter W=32;
parameter H=32;
parameter C=3;
parameter R=3;
parameter S=3;
parameter M=16;
parameter P=H-S+1;
parameter Q=W-R+1;
//parameter [1:0]X0=2'b00,X=2'b01,Y=2'b10,Z=2'b11;
input [H*W*C*bit-1:0]data;
input clk,rst;
input [C*R*S*M*bit-1:0]fil;
output reg[P*Q*M*bit-1:0]out;
//reg [7:0]in[0:W*H*C-1];
//reg [7:0]filter[0:R*S*C*M-1];
//reg [7:0]out[0:P*Q*M-1];
reg [7:0]temp_in[0:C-1][0:H-1][0:W-1];
reg [7:0]temp_filter[0:M-1][0:C-1][0:S-1][0:R-1];
reg [7:0]temp_out[0:M-1][0:H-S][0:W-R];
reg [1:0]y;
integer m=0,t=0,w=0,h=0,c=0,k=0,r=0,s=0,p=0,q=0;




always@(posedge clk,negedge rst) 
begin
    if(!rst)
    begin
        y<=0;
        out<=0;
    end   
    else
    begin
    case(y)
//        for(c=0;c<C;c=c+1)
    2'b00: begin
        if(c<C)
        begin
            if(h<H)
            begin
                if(w<W)
                begin
                    temp_in[c][h][w]= data[k+:bit];
                    k=k+bit;
                    w=w+1;
                end
                else
                begin
                w=0;
                h=h+1;
                end
               
            end
            else
                begin
                h=0;
                c=c+1;
                w=0;
                end
         
        end
        else begin
            c=0;
            k=0;
            h=0;
            w=0;
            y=2'b01;
            end
            end
           
       2'b01: begin
       if(m<M) begin
         if(c<C)
        begin
            if(s<S)
            begin
                if(r<R)
                begin
                    temp_filter[m][c][s][r]= fil[k+:bit];
                    k=k+bit;

                     $display("r=%d,s=%d,c=%d,m=%d",r,s,c,m);
                   r=r+1;
                end
                else begin
                r=0;
                s=s+1;
                 end
               
            end
            else begin
            s=0;
            r=0;
            c=c+1;
            end
                 
        end
        else
            begin
            c=0;
            r=0;
            s=0;
            m=m+1;
             end
       
      end    
      else begin
      c=0; r=0; s=0; m=0; k=0;y=2'b10; temp_out[m][h][w]=0;end end 
      2'b10: 
      begin
        if(m<M)
        begin
            if(c<C)
            begin
                if(h<P)
                begin
                    if(w<Q) 
                    begin
                        if(s<S) 
                        begin
                            if(r<R) 
                            begin
                            
                                temp_out[m][h][w] = temp_out[m][h][w] + temp_in[c][h+s][w+r]*temp_filter[m][c][s][r];
//                                $display("temp_in = %d, c = %d",temp_in,c);
                             $display("r=%d,s=%d,w=%d,h=%d,c=%d,m=%d",r,s,w,h,c,m);
//                            $display("s=%d","h=%d","m=%d","r=%d","w=%d",s,h,m,r,w);
                                r=r+1;
                          
                                
                            end
                            else 
                            begin
                                r=0;
                                s=s+1;
                            end
                        end
                        else 
                        begin
                              w=w+1; s=0; r=0;
                            temp_out[m][h][w] = 0; end
                        end
                    else 
                    begin
                        w=0;r=0;h=h+1; s=0; temp_out[m][h][w] = 0;
                    end
                end
                else 
                begin
                    h=0;w=0;s=0;r=0;c=c+1; 
                end
            end
            else 
            begin
                c=0;h=0;s=0;r=0;w=0;m=m+1; temp_out[m][h][w] = 0;
            end
        end
        else 
        begin
            m=0; k=0; c=0;h=0;s=0;r=0;w=0;y=2'b11; 
        end 
    end
     2'b11: begin
      if(m<M) begin
      if(h<P) begin
      if(w<S)
        begin
        out[k+:bit]= temp_out[m][h][w];
        k=k+bit;
        w=w+1;
        end
      else begin
      w=0; h=h+1; end
      end
      else begin
      h=0; w=0;m=m+1; end
     end
     else begin
     m=0; k=0; h=0;w=0; y=2'b00;end end
     default: y=2'b00;
    endcase
    end
    end
    endmodule