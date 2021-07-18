`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/29 12:25:58
// Design Name: 
// Module Name: IMEM
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


module IMEM(
    input [10:0] addr,	//指令地址
    output [31:0] instr	//指令数据
    );

    // reg [31:0] temp;//?

    dist_mem_gen_0 I_ROM (
        .a(addr),      // input wire [10 : 0] a
        .spo(instr)  // output wire [31 : 0] spo
    );
endmodule
