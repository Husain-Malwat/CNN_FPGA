
module conv( clk, data, fil, out)
    input clk;
    input [H*W*C*bit-1:0]data;
    input [C*R*S*M*bit-1:0]fil;
    output  reg [P*Q*M*bit-1:0]out;
    
    parameter C=3;
    parameter H=32;
    parameter W=32;
    parameter R=3;
    parameter S=3;
    parameter M=16;
    parameter P=H-R+1;
    parameter Q=W-S+1;
    parameter bit=8;

    integer c,h,w,r,s,p,q;

    reg [7:0]temp_in[0:C-1][0:H-1][0:W-1];
    reg [7:0]temp_filter[0:C-1][0:R-1][0:S-1];    
    reg [7:0]temp_out[0:M-1][0:H-R][0:W-S];

    //reg [7:0] in[0:C*H*W-1];
    //reg [7:0] filter[0:R*S*C*M-1];
    //reg [7:0] output[0:P*Q*M-1];

    always @(posedge clk)
    begin
        

        if(w<W)
        begin
            temp_in[c]c[h][w] <=  data[k+:bit];
            k=k+bit;
            w=w+1;

        else
            begin
                w=0;
                if (h<H)
                    h=h+1;
                else
                begin
                    h=0;
                    if (c<C)
                        c=c+1;
                    else
                    begin

                    end
                end
            end
        end
    
        c=0, h=0, w=0, r=0, s=0, p=0, q=0,k=0;
        if(s<S)
        begin
            temp_filter[m][c][r][s] <=  fil[k+:bit];
            k=k+bit;
            s=s+1;
        end
        else
            begin
                s=0;
                if (r<R)
                    r=r+1;
                else
                begin
                    r=0;
                    if (c<C)
                        c=c+1;
                    else
                    begin
                       //terminate
                    end
                end
            end
    
        m=0, c=0, h=0, w=0, r=0, s=0, p=0, q=0,k=0;
        if(s<S)
            temp_out[m][p][q] <= temp_out[m][p][q] + temp_in[c][p+s][q+r]*temp_filter[m][c][r][s];
            s=s+1;
        else
        begin
            s=0;
            if(r<R)
                r=r+1;
            else
            begin
                r=0;
                if(q<Q)
                begin
                    temp_out[m][p][q] = 0;
                    q=q+1;
                    else
                    begin
                        q=0;
                        if (p<P)
                            p=p+1;
                        else
                        begin
                            p=0;
                            if (m<M)
                                m=m+1;
                            else
                            begin
                                q=0;
                                if (p<P)
                                    p=p+1;
                                    else
                                    begin
                                        p=0;
                                        if (m<M)
                                            m=m+1;
                                            else
                                                //terminate
                                    end
                            end
                        end                        
                    end
                end
            end
        end
    
        c=0, h=0, w=0, r=0, s=0, p=0, q=0,k=0;
        if(q<Q)
        begin
            out[k+:bit] <= temp_out[m][p][q];
            k=k+bit;
            q=q+1;

        else
            begin
                q=0;
                if (p<P)
                    p=p+1;
                else
                begin
                    p=0;
                    if (m<M)
                        m=m+1;
                    else
                    begin
                        //Terminate
                    end
                end
            end
        end
    end

endmodule


--------------------------------------------------------------------------------------

