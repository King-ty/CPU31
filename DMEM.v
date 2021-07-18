`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/29 12:25:45
// Design Name: 
// Module Name: DMEM
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


module DMEM(
    input clk,	//时钟信号
    input CS,	//使能信号
    input DM_R,	//DMEM读取有效信号
    input DM_W,	//DMEM写入有效信号
    input [5:0] addr,		//DMDM数据地址
    input [31:0] data_in,	//输入数据
    output [31:0] data_out	//输出数据
    );

    reg [31:0] mem [63:0];

    always@(negedge clk)//posedge?
    begin
        if(DM_W && CS)
            mem[addr] <= data_in;
    end
    assign data_out = (CS && DM_R) ? mem[addr] : 32'bz;
endmodule
