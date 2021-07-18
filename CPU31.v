`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/28 21:38:21
// Design Name: 
// Module Name: cpu
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


module cpu(
	input clk,		//时钟信号
	input ena,		//使能信号
	input rst,		//置位信号
	output DM_ena,	//输出DMEM使能信号
	output DM_R,	//输出DMEM read信号
	output DM_W,	//输出DMEM write信号
	input [31:0] IM_instr,	//输入IMEM指令
	input [31:0] DM_rdata,	//输入DMEM读取的数据
	output [31:0] DM_wdata,	//输出要写入DMEM的数据
	output [31:0] PC_OUT,	//输出PC寄存器
	output [31:0] ALU_OUT	//输出ALU运算结果
	);

	parameter PC_START = 32'h0040_0000;

	/*
		parameter ALU_ADD	= 4'b0010;
		parameter ALU_ADDU	= 4'b0000;
		parameter ALU_SUB	= 4'b0011;
		parameter ALU_SUBU	= 4'b0001;
		parameter ALU_AND	= 4'b0100;
		parameter ALU_OR	= 4'b0101;
		parameter ALU_XOR	= 4'b0110;
		parameter ALU_NOR	= 4'b0111;
		parameter ALU_LUI	= 4'b1000;//4'b100x
		parameter ALU_SLT	= 4'b1011;
		parameter ALU_SLTU	= 4'b1010;
		parameter ALU_SRA	= 4'b1100;
		parameter ALU_SLL	= 4'b1110;//4'b111x
		parameter ALU_SRL	= 4'b1101;
	*/

	// 拆分指令
	wire [5:0] _op		= IM_instr[31:26];
	wire [4:0] _rs		= IM_instr[25:21];
	wire [4:0] _rt		= IM_instr[20:16];
	wire [4:0] _rd		= IM_instr[15:11];
	wire [4:0] _shamt	= IM_instr[10:6];
	wire [5:0] _func	= IM_instr[5:0];
	wire [15:0] _immediate	= IM_instr[15:0];
	wire [25:0] _address	= IM_instr[25:0];

	// R-type
	wire ADD	= _op == 6'b0 && _func == 6'b100000;
	wire ADDU   = _op == 6'b0 && _func == 6'b100001;
	wire SUB	= _op == 6'b0 && _func == 6'b100010;
	wire SUBU   = _op == 6'b0 && _func == 6'b100011;
	wire AND	= _op == 6'b0 && _func == 6'b100100;
	wire OR		= _op == 6'b0 && _func == 6'b100101;
	wire XOR	= _op == 6'b0 && _func == 6'b100110;
	wire NOR	= _op == 6'b0 && _func == 6'b100111;
	wire SLT	= _op == 6'b0 && _func == 6'b101010;
	wire SLTU	= _op == 6'b0 && _func == 6'b101011;
	wire SLL	= _op == 6'b0 && _func == 6'b000000;
	wire SRL	= _op == 6'b0 && _func == 6'b000010;
	wire SRA	= _op == 6'b0 && _func == 6'b000011;
	wire SLLV	= _op == 6'b0 && _func == 6'b000100;
	wire SRLV	= _op == 6'b0 && _func == 6'b000110;
	wire SRAV	= _op == 6'b0 && _func == 6'b000111;
	wire JR		= _op == 6'b0 && _func == 6'b001000;

	// I-type
	wire ADDI	= _op == 6'b001000;
	wire ADDIU	= _op == 6'b001001;
	wire ANDI	= _op == 6'b001100;
	wire ORI	= _op == 6'b001101;
	wire XORI	= _op == 6'b001110;
	wire LUI	= _op == 6'b001111;
	wire LW		= _op == 6'b100011;
	wire SW		= _op == 6'b101011;
	wire BEQ	= _op == 6'b000100;
	wire BNE	= _op == 6'b000101;
	wire SLTI	= _op == 6'b001010;
	wire SLTIU	= _op == 6'b001011;

	// J-type
	wire J		= _op == 6'b000010;
	wire JAL	= _op == 6'b000011;

	// ALU标志位
	wire _zero, _carry, _negative, _overflow;

	// 数据选择器信号
	wire M1		= (BEQ && _zero) || (BNE && !_zero);
	wire M2		= J || JAL;
	wire M3		= JR;
	wire M4		= JAL;//
	wire M5		= LW;
	wire M6		= SLL || SRL || SRA || SLLV || SRLV || SRAV;
	wire M7		= ADDI || ADDIU || ANDI || ORI || XORI || LW || SW || SLTI || SLTIU || LUI;
	wire M8		= ADDI || ADDIU || LW || SW || SLTI || SLTIU;//sign ext
	wire M9		= ADDI || ADDIU || ANDI || ORI || XORI || LUI || LW || SLTI || SLTIU;
	wire M10	= SLL || SRL || SRA;

	wire [3:0] ALUC;
	assign ALUC[3] = SLT || SLTI || SLTU || SLTIU || SLL || SLLV || SRL || SRLV || SRA || SRAV || LUI;
	assign ALUC[2] = AND || ANDI || OR || ORI || XOR || XORI || NOR || SLL || SLLV || SRL || SRLV || SRA || SRAV;
	assign ALUC[1] = ADD || ADDI || SUB || BEQ || BNE || XOR || XORI || NOR || SLT || SLTI || SLTU || SLTIU || SLL || SLLV;// || LW || SW
	assign ALUC[0] = SUB || BEQ || BNE || SUBU || OR || ORI || NOR || SLT || SLTI || SRL || SRLV;

	// PC
	reg [31:0] PC;
	wire [31:0] NPC	= PC + 4;
	assign PC_OUT = PC;

	wire [4:0] RsC = _rs;
	wire [4:0] RtC = _rt;
	wire [4:0] RdC = JAL ? 5'd31 : (M9 ? _rt : _rd);
	wire [31:0] Rd = M4 ? PC + 4 : (M5 ? DM_rdata : ALU_OUT);
	wire [31:0] Rs;
	wire [31:0] Rt;
	wire RF_W = !(JR || SW || BEQ || BNE || J);//因为基本上都需要往RF中写东西，故采用取反的方式简化代码
	regfile cpu_ref(
		.RF_ena(ena),
		.RF_rst(rst),
		.RF_clk(clk),
		.RF_W(RF_W),
		.RdC(RdC),
		.RsC(RsC),
		.RtC(RtC),
		.Rd(Rd),
		.Rs(Rs),
		.Rt(Rt)
	);

	wire [31:0] ALU_A = M6 ? {27'b0,(M10 ? _shamt : Rs[4:0])} : Rs;
	wire [31:0] ALU_B = M7 ? (M8 ? {{16{_immediate[15]}},_immediate} : {16'b0,_immediate}) : Rt;
	alu _alu(
		.a(ALU_A),
		.b(ALU_B),
		.aluc(ALUC),
		.r(ALU_OUT),
		.zero(_zero),
		.carry(_carry),
		.negative(_negative),
		.overflow(_overflow)
	);

	always@(negedge clk or posedge rst)
	begin
		if(ena && rst)
			PC <= PC_START;
		else if(ena)
		begin
			PC <= M3 ? Rs : (M2 ? {PC[31:28],_address,2'b0} : (M1 ? NPC + {{14{_immediate[15]}},_immediate,2'b00} : NPC));
		end
	end

	assign DM_ena	= LW || SW;
	assign DM_R		= LW;
	assign DM_W		= SW;
	assign DM_wdata	= Rt;

endmodule
