`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/24/2023 02:21:39 PM
// Design Name: 
// Module Name: mantshift
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


module mantshift(exp, mant, shifted, shift_index );
parameter m = 8, n = 23;
    input [m-1:0] exp;
    input [n+1:0] mant;
    output reg [m-1:0] shift_index;
    output reg [n+1:0] shifted;
    reg [n+1:0] target;
    reg [$clog2(n)-1:0] cnt;
    always@(mant, exp) begin target = mant;
    shift_index = exp;
    for(cnt = 0; cnt < n+1; cnt = cnt + 1)begin
        if (target[cnt]) shift_index = n - cnt;
    end
    shifted = mant << shift_index;
    end
endmodule