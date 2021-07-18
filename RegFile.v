`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/29 12:26:54
// Design Name: 
// Module Name: regfile
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


module regfile(
    input RF_ena,	//使能信号
    input RF_rst,	//置位信号，高电平有效
    input RF_clk,	//时钟信号
    input RF_W,		//写有效信号
    input [4:0] RdC,	//Rd的地址
    input [4:0] RsC,	//Rs的地址
    input [4:0] RtC,	//Rt的地址
    input [31:0] Rd,	//Rd数据
    output [31:0] Rs,	//Rs数据
    output [31:0] Rt	//Rt数据
    );

    reg [31:0] array_reg[31:0];

    always@(negedge RF_clk or posedge RF_rst)
    begin
        if(RF_rst&&RF_ena)
        begin
            array_reg[0] <= 32'b0;
            array_reg[1] <= 32'b0;
            array_reg[2] <= 32'b0;
            array_reg[3] <= 32'b0;
            array_reg[4] <= 32'b0;
            array_reg[5] <= 32'b0;
            array_reg[6] <= 32'b0;
            array_reg[7] <= 32'b0;
            array_reg[8] <= 32'b0;
            array_reg[9] <= 32'b0;
            array_reg[10] <= 32'b0;
            array_reg[11] <= 32'b0;
            array_reg[12] <= 32'b0;
            array_reg[13] <= 32'b0;
            array_reg[14] <= 32'b0;
            array_reg[15] <= 32'b0;
            array_reg[16] <= 32'b0;
            array_reg[17] <= 32'b0;
            array_reg[18] <= 32'b0;
            array_reg[19] <= 32'b0;
            array_reg[20] <= 32'b0;
            array_reg[21] <= 32'b0;
            array_reg[22] <= 32'b0;
            array_reg[23] <= 32'b0;
            array_reg[24] <= 32'b0;
            array_reg[25] <= 32'b0;
            array_reg[26] <= 32'b0;
            array_reg[27] <= 32'b0;
            array_reg[28] <= 32'b0;
            array_reg[29] <= 32'b0;
            array_reg[30] <= 32'b0;
            array_reg[31] <= 32'b0;
        end
        else if(RF_W && RF_ena && RdC != 5'b0)
            array_reg[RdC] <= Rd;
    end

    assign Rs = RF_ena ? array_reg[RsC] : 32'bz;
    assign Rt = RF_ena ? array_reg[RtC] : 32'bz;

endmodule
