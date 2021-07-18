`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/28 21:33:11
// Design Name: 
// Module Name: sccomp_dataflow
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


module sccomp_dataflow(
    input clk_in,		//时钟
    input reset,		//置位信号
    output [31:0] inst,	//指令输出
    output [31:0] pc	//pc输出
    );

	parameter DM_START = 32'h1001_0000;
	parameter PC_START = 32'h0040_0000;

	wire DM_ena,DM_R,DM_W;
	wire [31:0] DM_rdata;
	wire [31:0] DM_wdata;
	wire [31:0] res;

    cpu sccpu(
        .clk(clk_in),
        .ena(1'b1),
		.rst(reset),
		.DM_ena(DM_ena),
		.DM_R(DM_R),
		.DM_W(DM_W),
		.IM_instr(inst),
		.DM_rdata(DM_rdata),
		.DM_wdata(DM_wdata),
		.PC_OUT(pc),
		.ALU_OUT(res)
    );

	wire [31:0] IM_addr = pc - PC_START;

	IMEM imem(
		.addr(IM_addr[12:2]),
		.instr(inst)
	);

	wire [5:0] DM_addr = (res - DM_START) / 4;//
	DMEM dmem(
		.clk(clk_in),
		.CS(DM_ena),
		.DM_R(DM_R),
		.DM_W(DM_W),
		.addr(DM_addr),
		.data_in(DM_wdata),
		.data_out(DM_rdata)
	);

endmodule
