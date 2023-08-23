`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/17/2023 09:36:25 AM
// Design Name: 
// Module Name: 32bfpmul
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


module fpaddsub_32b(a_in, b_in, sub, c_out );
parameter m = 8, n = 23;
input [m+n:0] a_in, b_in;
input sub;
output [m+n:0] c_out;

wire sign, sub_b, a_is_big, b_is_big, both_equal, mant_abig;
wire [m-1:0] exp, exp_c, exp_d, shift_index;
wire [n+1:0] mant, mant_d, a_shifted, b_shifted, shifted;

assign a_is_big = a_in[m+n-1:n] > b_in[m+n-1:n];
assign b_is_big = a_in[m+n-1:n] < b_in[m+n-1:n];
assign both_equal = a_in[m+n-1:n] == b_in[m+n-1:n];
assign mant_abig = both_equal ? 
                a_in[n-1:0] > b_in[n-1:0] : 'b0;

assign exp_c = a_is_big ? a_in[m+n-1:n] - b_in[m+n-1:n] : 
                b_is_big ? b_in[m+n-1:n] - a_in[m+n-1:n] : 'b0;

assign a_shifted = b_is_big ? {1'b1,a_in[n-1:0]}>>(exp_c) :
                     {1'b1,a_in[n-1:0]};
assign b_shifted = a_is_big ? {1'b1,b_in[n-1:0]}>>(exp_c) :
                     {1'b1,b_in[n-1:0]};

assign sub_b = a_in[m+n] ^ (b_in[m+n] ^ sub);
assign mant_d = sub_b ? (a_is_big || mant_abig) ?
                a_shifted - b_shifted :
                b_shifted - a_shifted :
                a_shifted + b_shifted;
//assign mant_e = mant_abig ? {1'b1,a_in[n-1:0]} - {1'b1,b_in[n-1:0]} :
//                                {1'b1,b_in[n-1:0]} - {1'b1,a_in[n-1:0]} ;
                
assign sign = (a_is_big || mant_abig) ? a_in[m+n] : (b_in[m+n] ^ sub);
assign exp_d = a_is_big ? a_in[m+n-1:n] : b_in[m+n-1:n];

//corner case logic- not needed for normal operation
//mantshift mant_shifter(a_in[m+n-1:n], mant_e, shifted, shift_index );
mantshift mant_shifter(exp_d, mant_d, shifted, shift_index );
//--------------------------------------------------

assign mant = /*both_equal&&*/sub_b ? shifted : mant_d>>mant_d[n+1];
assign exp = /*both_equal&&*/sub_b ? exp_d - shift_index : exp_d + mant_d[n+1];

assign c_out = {sign,exp,mant[n-1:0]};

endmodule
