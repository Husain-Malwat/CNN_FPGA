`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.11.2022 17:29:08
// Design Name: 
// Module Name: conv
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


module conv(
    input clk_in,reset,
    input [7:0]data_in,
    output [7:0]data_out
    );  
    wire internal_clk;
    
    reg [3:0]state;
    reg [2:0]internalState;
    reg [7:0]P,Q,R,S,C,M,p,q,r,s,c,m;
    reg valid_in, valid_out;
    reg [1:0]large_state;
    reg [3:0]small_state;
    reg AA,BB,CC,DD;
    parameter CNN=8'b0;
    parameter maxpool=8'b0;
    parameter FCL=8'b0;

    reg [7:0]inp[0:14400-1];
    reg [7:0]weight[0:18432-1];
    integer counter=0;

    always @(posedge internal_clk, posedge reset)
    begin
        if(reset)
        begin
            p = 0;
            q = 0;
            r = 0;
            s = 0;
            c = 0;
            m = 0;
            valid_in = 0;
            valid_out = 0;
        end 
        else
        begin
            if(large_state==0 && valid_in==1)  // large state 0:data_in check, 1:conv, 2:maxpool, 3:FCL
            begin
                if(data_in==CNN) large_state=1;
                else if(data_in==maxpool) large_state=2;
                else if(data_in==FCL) large_state=3;
            end
            else if(large_state==1 && valid_in==1)
            begin
                case(small_state) // 0:fill paramters, 1:take input(img), 2:take weights,
                                  // 3:assign output to 0, 4:convolution calculation, 5:transmit output
                    0: // Fill the paramaeters P,Q,R,S,C,M 
                    begin 
                        case(counter)
                            0: begin P=data_in;counter=counter+1; end
                            1: begin Q=data_in;counter=counter+1; end
                            2: begin R=data_in;counter=counter+1; end
                            3: begin S=data_in;counter=counter+1; end
                            4: begin C=data_in;counter=counter+1; end
                            5: begin M=data_in;counter=counter+1; end
                            default: begin small_state=small_state+1;counter=0; end
                        endcase
                    end
                    1: // take input(img)
                    begin
                        if(counter<(P+R-1)*(Q+S-1)*C)
                        begin
                            if(c<C)
                                if(p<P+R-1)
                                    if(q<Q+S-1)
                                    begin
                                        inp[q + p*(Q+S-1) + c*(P+R-1)*(Q+S-1)] = data_in;
                                        counter=counter+1;
                                        q=q+1;
                                    end
                                    else
                                    begin
                                        q=0;
                                        p=p+1;
                                    end
                                else
                                begin
                                    p=0;
                                    c=c+1;
                                end
                            else
                            begin
                                c=0;
                                p=0;
                                q=0;
                            end
                        end
                        else
                        begin
                            counter=0;
                            small_state = small_state+1;
                        end
                    end
                    
                    2: // take weights
                    begin
                        if(counter<(R)*(S)*C)
                        begin
                            if(m<M)
                                if(c<C)
                                    if(r<R)
                                        if(s<S)
                                    begin
                                        weight[s+r*S+c*R*S+m*C*R*S] = data_in;
                                        counter=counter+1;
                                        s=s+1;
                                    end
                                    else
                                    begin
                                        s=0;
                                        r=r+1
                                    end
                                else
                                begin
                                    r=0;
                                    c=c+1;
                                end
                            else
                            begin
                                m=0;
                                c=0;
                                r=0;
                                s=0;
                            end
                        else
                        begin
                            counter=0;
                            small_state = small_state+1;
                        end
                        
                        end
                    end
                    3: //assign output to 0
                    begin
                        begin
                        if(counter<P*Q*C)
                        begin                            
                            if(c<C)
                                if(p<P)
                                    if(q<Q)
                                    begin
                                        out[counter] <= 0;
                                        counter=counter+1;
                                        q=q+1;
                                    end
                                    else
                                    begin
                                        s=0;
                                        r=r+1;
                                    end
                                else
                                begin
                                    r=0;
                                    c=c+1;
                                end
                            
                            else
                            begin
                                c=0;
                                r=0;
                                s=0;
                                m=0;
                            end
                        end
                        else
                        begin
                            counter=0;
                            small_state = small_state+1;
                        end
                        end
                    end
                    
                    4: // convolution calculation
                    begin
                        if(m<M)
                        begin
                            if(p<P)
                            begin
                                if(q<Q) 
                                    if(r<R) 
                                    begin
                                        if(s<S) 
                                        begin            
                                            out[q + p*Q + m*P*Q] = out[q + p*Q + m*P*Q] + inp[s + r*S + q*R*S + p*S*R*Q + m*P*Q*R*S]*weight[s + r*S + c*R*S];
                                            s=s+1;
                                            counter = counter + 1;
                                        end
                                        else 
                                        begin
                                            s=0;
                                            r=r+1;
                                        end
                                    end
                                    else 
                                    begin
                                        r=0;
                                        q=q+1;
                                    end
                                else 
                                begin
                                    q=0;
                                    p=p+1;
                                end
                            end
                        else 
                        begin
                            p=0;
                            m=m+1; 
                        end
                        end
                        else 
                        begin
                            m=0;
                            p=0;
                            q=0;
                            r=0;
                            s=0;
                        end   
                    end
                    5: // transmit output
                    begin
                        if(counter < P*Q*M)
                        begin
                            if(m<M)
                                if(p<P)
                                    if(q<Q)
                                    begin
                                        inp[q + p*(Q) + m*(P)*(Q)] = data_in;
                                        counter=counter+1;
                                        q=q+1;
                                    end
                                    else
                                    begin
                                        q=0;
                                        p=p+1;
                                    end
                                else
                                begin
                                    p=0;
                                    m=m+1;
                                end
                            else
                            begin
                                m=0;
                                p=0;
                                q=0;
                            end
                        end
                        else
                        begin
                            counter=0;
                            small_state = 0;
                        end
                    end
                endcase
            end  
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

            else if(large_state==2) //Maxpool
            begin   
                if(done_in)
                begin
                    case(small_state) // 0:fill paramters, 1:take input(img), 2:take weights,
                                      // 3:assign output to 0, 4:convolution calculation, 5:transmit output
                        0: // Fill the paramaeters P,Q,R,S,C,M 
                        begin 
                            case(counter)
                                0: begin P=data_in;counter=counter+1; end
                                1: begin Q=data_in;counter=counter+1; end
                                2: begin R=data_in;counter=counter+1; end
                                3: begin S=data_in;counter=counter+1; end
                                4: begin C=data_in;counter=counter+1; end
                                5: begin M=data_in;counter=counter+1; end

                                default: begin small_state=small_state+1;counter=0; end
                            endcase
                        end
                        1: // take input(img)
                        begin
                            if(counter<(P+R-1)*(Q+R-1)*C)
                            begin
                                if(c<C)
                                    if(p<P+R-1)
                                        if(q<Q+S-1)
                                        begin
                                            inp[q + p*(Q+S-1) + c*(P+R-1)*(Q+S-1)] = data_in;
                                            counter=counter+1;
                                            q=q+1;
                                        end
                                        else
                                        begin
                                            q=0;
                                            p=p+1;
                                        end
                                    else
                                    begin
                                        p=0;
                                        c=c+1;
                                    end
                                else
                                begin
                                    c=0;
                                    p=0;
                                    q=0;
                                end
                                end
                            else
                            begin
                                counter=0;
                                small_state = small_state+1;
                            end
                        end
                    2: // take weights
                    begin
                        if(counter<R*S*C*M)
                        begin
                            if(m<M)
                                if(c<C)
                                    if(r<R)
                                        if(s<S)
                                    begin
                                        weight[s+r*S+c*R*S+m*R*S*C] = data_in;
                                        counter=counter+1;
                                        s=s+1;
                                    end
                                    else
                                    begin
                                        s=0;
                                        r=r+1;
                                    end
                                else
                                begin
                                    r=0;
                                    c=c+1;
                                end
                              else
                              begin
                                  c=0;
                                  m=m+1;
                              end
                            else
                            begin
                                m=0;
                                c=0;
                                r=0;
                                s=0;
                            end
                            end
                        else
                        begin
                            counter=0;
                            small_state = small_state+1;
                        end
                        end
                    3: //assign output to 0
                    begin
                            if(counter<P*Q*M)
                            begin
                                if(m<M)
                                    if(p<P)
                                        if(q<Q)
                                        begin
                                            out[q + p*Q + m*P*Q] = 0;
                                            counter=counter+1;
                                            q=q+1;
                                        end
                                        else
                                        begin
                                            q=0;
                                            p=p+1;
                                        end
                                    else
                                    begin
                                        p=0;
                                        m=m+1;
                                    end
                                else
                                begin
                                    m=0;
                                    p=0;
                                    q=0;
                                end
                                end
                            else
                            begin
                                counter=0;
                                small_state = small_state+1;
                            end
                        end
                    4: // max pooling calculation
                   begin
                      if(m<m-1)
                        if(p< P-1)
                          if(q<Q-1)
                            begin
                                AA=inp[q];
                                BB=inp[q+1];
                                CC=inp[q+Q];
                                DD=inp[q+Q+1];

                            out[q + p*Q + m*P*Q] = (AA>=BB & AA>=CC & AA>=DD) ? AA : (BB>=AA & BB>=CC & BB>=DD) ? BB :(CC>=AA & CC>=BB & CC >= DD) ? CC : DD;
                            q = q+2;
                            end
                        else
                            begin
                            q=0;
                            p=p+2;
                            end
                        else
                          begin
                          p=0;
                          m=m+1;
                          end
                      else
                        begin
                        p=0;q=0;m=0;
                        end            
                    end

                    5: // transmit output
                    begin
                        if(counter<P*Q*M)
                        begin
                            if(m<M)
                                if(p<P)
                                    if(q<Q)
                                    begin
                                        data_out = out[q+p*Q+m*P*Q];
                                        counter=counter+1;
                                        q=q+1;
                                    end
                                    else
                                    begin
                                        q=0;
                                        p=p+1;
                                    end
                                else
                                begin
                                    p=0;
                                    m=m+1;
                                end
                            else
                            begin
                                m=0;
                                p=0;
                                q=0;
                            end
                            end
                        else
                        begin
                            counter=0;
                            small_state = 0;
                            valid_out = 1;
                        end
                    end
                endcase
            end        
            end

            else if(large_state==3) // dense or fully connected
            begin
                else if(large_state==3 && valid_in==1)
                begin
                if(done_in)
                begin
                    case(small_state) // 0:fill paramters, 1:take input(img), 2:take weights,
                                      // 3:assign output to 0, 4:convolution calculation, 5:transmit output
                        0: // Fill the paramaeters P,Q,R,S,C,M 
                        begin 
                            case(counter)
                                0: begin P=data_in;counter=counter+1; end
                                1: begin Q=data_in;counter=counter+1; end
                                2: begin R=data_in;counter=counter+1; end
                                3: begin S=data_in;counter=counter+1; end
                                4: begin C=data_in;counter=counter+1; end
                                5: begin M=data_in;counter=counter+1; end

                                default: begin small_state=small_state+1;counter=0; end
                            endcase
                        end
                        1: // take input(img)
                        begin
                            if(counter<(P+R-1)*(Q+R-1)*C)
                            begin
                                if(c<C)
                                    if(p<P+R-1)
                                        if(q<Q+S-1)
                                        begin
                                            inp[q + p*(Q+S-1) + c*(P+R-1)*(Q+S-1)] = data_in;
                                            counter=counter+1;
                                            q=q+1;
                                        end
                                        else
                                        begin
                                            q=0;
                                            p=p+1;
                                        end
                                    else
                                    begin
                                        p=0;
                                        c=c+1;
                                    end 
                                else
                                begin
                                    c=0;
                                    p=0;
                                    q=0;
                                end
                                end
                            else
                            begin
                                counter=0;
                                small_state = small_state+1;
                            end
                        end
                    2: // take weights
                    begin
                        if(counter<R*S*C*M)
                        begin
                            if(m<M)
                                if(c<C)
                                    if(r<R)
                                        if(s<S)
                                    begin
                                        weight[s+r*S+c*R*S+m*R*S*C] = data_in;
                                        counter=counter+1;
                                        s=s+1;
                                    end
                                    else
                                    begin
                                        s=0;
                                        r=r+1;
                                    end
                                else
                                begin
                                    r=0;
                                    c=c+1;
                                end
                              else
                              begin
                                  c=0;
                                  m=m+1;
                              end
                            else
                            begin
                                m=0;
                                c=0;
                                r=0;
                                s=0;
                            end
                            end
                        else
                        begin
                            counter=0;
                            small_state = small_state+1;
                        end
                        end
                    3: //assign output to 0
                    begin
                            if(counter<P*Q*M)
                            begin
                                if(m<M)
                                    if(p<P)
                                        if(q<Q)
                                        begin
                                            out[q + p*Q + m*P*Q] = 0;
                                            counter=counter+1;
                                            q=q+1;
                                        end
                                        else
                                        begin
                                            q=0;
                                            p=p+1;
                                        end
                                    else
                                    begin
                                        p=0;
                                        m=m+1;
                                    end
                                else
                                begin
                                    m=0;
                                    p=0;
                                    q=0;
                                end
                                end
                            else
                            begin
                                counter=0;
                                small_state = small_state+1;
                            end
                        end
                    4: // FCL calculation
                    begin
                    if(counter<P*Q*M)
                            begin
                                if(m<M)
                                    if(p<P)
                                        if(q<Q)
                                        begin
                                            out[q + p*Q + m*P*Q] = out[q + p*Q + m*P*Q] + input_array[q + p*(Q+S-1) + c*(P+R-1)*(Q+S-1)]*class_array[s+r*S+c*R*S];
                                            counter=counter+1;
                                            q=q+1;
                                        end
                                        else
                                        begin
                                            q=0;
                                            p=p+1;
                                        end
                                    else
                                    begin
                                        p=0;
                                        m=m+1;
                                    end
                                else
                                begin
                                    m=0;
                                    p=0;
                                    q=0;
                                end
                                end
                            else
                            begin
                                counter=0;
                                small_state = small_state+1;
                            end
                    end
                    5:// compare
                    begin
                    
                    end

                    6: // transmit output
                    begin
                        if(counter<P*Q*M)
                        begin
                            if(m<M)
                                if(p<P)
                                    if(q<Q)
                                    begin
                                        data_out = out[q+p*Q+m*P*Q];
                                        counter=counter+1;
                                        q=q+1;
                                    end
                                    else
                                    begin
                                        q=0;
                                        p=p+1;
                                    end
                                else
                                begin
                                    p=0;
                                    m=m+1;
                                end
                            else
                            begin
                                m=0;
                                p=0;
                                q=0;
                            end
                            end
                        else
                        begin
                            counter=0;
                            small_state = 0;
                            valid_out = 1;
                        end
                    end
                    endcase
                end
            end
        end
    end
    END
    
    
endmodule




