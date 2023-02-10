`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.11.2022 19:39:36
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


module conv(in, filter, out,reset,clk);
  parameter h=32;  //height of input
  parameter w=32;  //width of input
  parameter f=3;  //filter size
  input [7:0]in[0:h*w-1]; // array of size 32*32=1024 input
  input [7:0]filter[0:f*f-1]; // for array of size 3*3=9
  input clk;
  input reset;
  output reg [15:0]out[0:(h-f+1)*(w-f+1)-1]; // output array
  reg [7:0]temp_in[0:h-1][0:w-1]; // converting input into 2d array
  reg [7:0]temp_filter[0:f-1][0:f-1]; // converting filter into 2d array
  reg [15:0]temp_out[0:h-f][0:w-f];  // taking output as a 2d array
 
  integer i,j,k,l,m;
 
  always@(posedge clk,negedge reset)
  if(!reset)
  for(i=0; i<(h-f+1)*(w-f+1);i=i+1)
  out[i]=0;
  else

  begin
    k=0;
    for(i=0;i<h;i=i+1)
      for(j=0;j<w;j=j+1) 
      begin
        temp_in[i][j] = in[k]; // putting values in 2d array
        k=k+1;
      end
    k=0;
    for(i=0;i<f;i=i+1)
      for(j=0;j<f;j=j+1) 
      begin
        temp_filter[i][j] = filter[k]; // putting values in 2d array for filter
        k=k+1;
      end
   
    for(i=0;i<h-f+1;i=i+1)
      for(j=0;j<w-f+1;j=j+1) 
      begin
        temp_out[i][j] = 0;
        for(k=0;k<f;k=k+1)
          for(l=0;l<f;l=l+1) 
          begin
            temp_out[i][j] = temp_out[i][j] + temp_in[i+k][j+l]*temp_filter[k][l]; // multiplying elements of array
          end
      end
    k=0;
    for(i=0;i<h-f+1;i=i+1)
      for(j=0;j<w-f+1;j=j+1) 
      begin
        out[k] = temp_out[i][j];//converted into 1d array
        k=k+1;
      end
  end
endmodule
