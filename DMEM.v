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
    input clk,	//ʱ���ź�
    input CS,	//ʹ���ź�
    input DM_R,	//DMEM��ȡ��Ч�ź�
    input DM_W,	//DMEMд����Ч�ź�
    input [5:0] addr,		//DMDM���ݵ�ַ
    input [31:0] data_in,	//��������
    output [31:0] data_out	//�������
    );

    reg [31:0] mem [63:0];

    always@(negedge clk)//posedge?
    begin
        if(DM_W && CS)
            mem[addr] <= data_in;
    end
    assign data_out = (CS && DM_R) ? mem[addr] : 32'bz;
endmodule
