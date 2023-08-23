`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/21/2023 12:09:38 PM
// Design Name: 
// Module Name: conv_flt
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


module conv_flt(
    input clock,
    input rst,
    input [31:0] a_in,
    output [31:0] result,
    output reg out_valid,
    output reg end_conv
    );
    parameter n=3, m=2;
    reg [31:0] k [m*m-1:0];
    reg [31:0] w [m*m-1:0];
    wire [31:0] u [m*m-1:0];
    wire [31:0] v [m*m-2:0];
    reg [31:0] p [(m-1)*n-1:0];
    reg [5:0] count, count1, count2, count3;
    reg [5:0] y;
    
    always@(posedge clock) begin 
    if(rst) count <= 'b0;
    else if(end_conv == 'b1) count <= 'b0;
    else count <= count + 1'b1;
    end
       
    always@(posedge clock)
    k[m*m-1] <= (count<m*m) ? a_in : k[m*m-1];
      
    genvar i;
    generate
    for(i=0;i<m*m-1;i=i+1)
    always@(posedge clock)
    k[m*m-1-i-1] <= (count<m*m) ? k[m*m-1-i] : k[m*m-1-i-1] ;
    endgenerate
    
    always@(posedge clock)
    w[m*m-1] <= a_in;
        
    genvar j,l;
    generate
    for(i=0;i<m-1;i=i+1) begin
    
    for(j=0;j<m-1;j=j+1)
    always@(posedge clock)
    w[m*m-1-i*m-j-1] <= w[m*m-1-i*m-j];
    
    always@(*)
    p[0+i*m] <= w[m*m-1-i*m];
    for(l=0;l<n-1;l=l+1)
    always@(posedge clock) begin 
    p[l+i*m+1] <= p[l+i*m];
    w[m*m-1-i*m-m] <= p[n-1];
    end
    end

    for(j=0;j<m-1;j=j+1)
    always@(posedge clock)
    w[m-1-j-1] <= w[m-1-j];    
    endgenerate
    //inputs at w and k
    
    //always@(w,k) begin
    //result = 'b0;
    fpmul_32b mul(w[m*m-1],k[m*m-1],u[m*m-1]);
    generate
    for(i=m*m-2;i>=0;i=i-1) begin //u[i] <= u[i+1] + w[i]*k[i];
    fpmul_32b mul(w[i],k[i],v[i]);
    fpaddsub_32b adsb(u[i+1], v[i], 'b0, u[i]);
    end
    endgenerate
    
    assign result = u[0];
    
    // logic to generate valids
    always@(posedge clock) begin
    if(rst) begin out_valid <= 'b0; end_conv <= 'b0; end
    else if(count < (m-1)*n + m - 'b1 + m*m );
    else if(count == (m-1)*n + m - 'b1 + m*m) begin
    out_valid <= 'b1; count1<='b1; count2<='b1; count3<='b1; end
    else if(end_conv == 'b1) begin out_valid <= 'b0; end_conv <= 'b0; end
    else if((count2 == n-m) && (count3 == n-m+'b1)) begin
    end_conv <= 'b1; count1<='b0; count2<='b0; count3<='b0; end
    else if(count2 == n-m+'b1) begin
    out_valid <= 'b0; count1<=count1+'b1; count2<='b0; end
    else if(count1%n == 'b0) begin
    out_valid <= 'b1; count1<=count1+'b1; count2<='b1; count3<=count3+'b1; end
    else begin count1<=count1+'b1; count2<=count2+'b1; end
    end
    
endmodule
