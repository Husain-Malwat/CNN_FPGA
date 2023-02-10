module maxpool(clk, data, out);
parameter C=16,H=28,W=28;
parameter Z=C*W*H/4;
parameter bit=8;

wire A,B,C; //for max pool
 
input clk;
output reg[Z*bit-1:0] temp_out;
input [C*W*H*bit-1:0] data;
reg [7:0]temp[0:C-1][0:H-1][0:W-1];

integer w=0,h=0,c=0,k=0,m=0,n=0,bit=8;


always@(posedge clk)    
    begin
        
        if(w<W)
        begin
            tem[c][h][w] = data[k+:bit];
            w=w+1;
            k=k+bit;
        end
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
                        w=0,h=0,c=0,k=0;
                end
        end                    

    end

    begin
        if(w<W)
        begin
            A = temp[c][h][w] >= temp[c][h][w+1] & temp[c][h][w] >= temp[c][h+1][w] & temp[c][h][w] >= temp[c][h+1][w+1];
            B = temp[c][h+1][w] >= temp[c][h][w] & temp[c][h+1][w] >= temp[c][h][w+1] & temp[c][h+1][w] >= temp[c][w+1][w+1]; 
            C = temp[c][h][w+1] >= temp[c][h][w] & temp[c][h][w+1] >= temp[c][h+1][w] & temp[c][h][w+1] >= temp[c][h+1][w+1];
            out[k+:bit] = (A ? temp[c][h][w] : (B ? temp[c][h+1][w] : (C ? temp[c][h][w+1] : temp[c][h+1][w+1])));
            
            n=n+2;
        end
        else
        begin
            n=0;
            if(h<H)
                h=h+1;
                else
                begin
                    if(c<C)
                        c=c+1;
                    else
                        //terminate
                end 
        end
    end
endmodule