`timescale 1ns / 1ps
module fpmul_32b(a_in, b_in, c_out );
parameter m = 8, n = 23;
input [m+n:0] a_in, b_in;
output [m+n:0] c_out;

wire sign, is_zero;
wire [m-1:0] exp, exp_c, exp_d;
wire [2*n+1:0] mant;
wire [2*n+1:0] mul;

assign sign = a_in[m+n] ^ b_in[m+n];
assign exp_c = a_in[m+n-1:n] + b_in[m+n-1:n] - {(m-1){1'b1}};
assign mul = {1'b1,a_in[n-1:0]} * {1'b1,b_in[n-1:0]};
assign is_zero = (a_in[m+n-1:0] == 'b0) || (b_in[m+n-1:0] == 'b0);

assign exp = exp_c + mul[2*n+1];
assign mant = mul>>(mul[2*n+1]);

assign c_out = is_zero ? 'b0 : {sign,exp,mant[2*n-1:n]};

endmodule