`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/18/2023 04:38:08 PM
// Design Name: 
// Module Name: tbconv_fix
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


module tbconv_fix(    );

reg clock, rst;
reg [31:0] a;
wire [31:0] result;
wire out_valid, end_conv;

always #50 clock = ~clock;

conv_fix DUT (clock, rst, a, result, out_valid, end_conv);

always@(negedge clock) a = a+6'b100000;

initial begin
clock = 0; rst = 1; #100 rst = 0; a = 6'b000000;
//#40 a = 6'b000000;
//repeat(15)
//#10 a = $random;
end
endmodule
