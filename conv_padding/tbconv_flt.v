`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/21/2023 03:49:27 PM
// Design Name: 
// Module Name: tbconv_flt
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


module tbconv_flt(

    );

    reg clock, rst;
    reg [31:0] a;
    wire [31:0] result;
    wire out_valid, end_conv;
    
    always #50 clock = ~clock;
    
    conv_flt DUT (clock, rst, a, result, out_valid, end_conv);
    
    //always@(posedge clock) a = a+6'b100000;
    
    initial begin
    clock = 1; rst = 1; #100 rst = 0; 
    a = 32'b0_01111111_00000000000000000000000;
    #100 a = 32'b0_10000000_00000000000000000000000;
    #100 a = 32'b0_10000000_10000000000000000000000;
    #100 a = 32'b0_10000001_00000000000000000000000;
    #100 a = 32'b0_10000001_01000000000000000000000;
    #100 a = 32'b0_10000001_10000000000000000000000;
    #100 a = 32'b0_10000001_11000000000000000000000;
    #100 a = 32'b0_10000010_00000000000000000000000;
    #100 a = 32'b0_10000010_00100000000000000000000;
    #100 a = 32'b0_10000010_01000000000000000000000;
    #100 a = 32'b0_10000010_01100000000000000000000;
    #100 a = 32'b0_10000010_10000000000000000000000;
    #100 a = 32'b0_10000010_10100000000000000000000;
    #100 a = 32'b0_10000010_11000000000000000000000;
    //repeat(15)
    //#10 a = $random;
    end
endmodule
