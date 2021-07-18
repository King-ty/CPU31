`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/29 22:52:50
// Design Name: 
// Module Name: CPU31_tb
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


module CPU31_tb;

integer file_output;
reg clk_in;
reg reset;
wire [31:0] inst;
wire [31:0] pc;

sccomp_dataflow uut(
    .clk_in(clk_in),
    .reset(reset),
    .inst(inst),
    .pc(pc)
    );

initial begin
	file_output <= $fopen("F:\\大学课程\\大二下\\计组\\实验\\31条\\测试\\myout.txt");
	// Initialize Inputs
	clk_in <= 0;
	reset <= 1;

	// // Wait 200 ns for global reset to finish
	#50;
	reset <= 0;
end
	
always begin
	#3;
	clk_in = ~clk_in;
	if(clk_in == 1'b1 && reset == 0) begin
		$fdisplay(file_output, "pc: %h", pc);
		$fdisplay(file_output, "instr: %h", inst);
		// $fdisplay(file_output, "shamt: %d", CPU31_tb.uut.sccpu._shamt);//
		// $fdisplay(file_output, "aluc: %d", CPU31_tb.uut.sccpu.ALUC);//
		// $fdisplay(file_output, "aluout: %h", CPU31_tb.uut.sccpu.ALU_OUT);//
		// $fdisplay(file_output, "Rd: %h", CPU31_tb.uut.sccpu.Rd);//
		// $fdisplay(file_output, "ADD: %d", CPU31_tb.uut.sccpu.ADD);//
		// $fdisplay(file_output, "ADDI: %d", CPU31_tb.uut.sccpu.ADDI);//
		$fdisplay(file_output, "regfile0: %h", CPU31_tb.uut.sccpu.cpu_ref.array_reg[0]);
		$fdisplay(file_output, "regfile1: %h", CPU31_tb.uut.sccpu.cpu_ref.array_reg[1]);
		$fdisplay(file_output, "regfile2: %h", CPU31_tb.uut.sccpu.cpu_ref.array_reg[2]);
		$fdisplay(file_output, "regfile3: %h", CPU31_tb.uut.sccpu.cpu_ref.array_reg[3]);
		$fdisplay(file_output, "regfile4: %h", CPU31_tb.uut.sccpu.cpu_ref.array_reg[4]);
		$fdisplay(file_output, "regfile5: %h", CPU31_tb.uut.sccpu.cpu_ref.array_reg[5]);
		$fdisplay(file_output, "regfile6: %h", CPU31_tb.uut.sccpu.cpu_ref.array_reg[6]);
		$fdisplay(file_output, "regfile7: %h", CPU31_tb.uut.sccpu.cpu_ref.array_reg[7]);
		$fdisplay(file_output, "regfile8: %h", CPU31_tb.uut.sccpu.cpu_ref.array_reg[8]);
		$fdisplay(file_output, "regfile9: %h", CPU31_tb.uut.sccpu.cpu_ref.array_reg[9]);
		$fdisplay(file_output, "regfile10: %h", CPU31_tb.uut.sccpu.cpu_ref.array_reg[10]);
		$fdisplay(file_output, "regfile11: %h", CPU31_tb.uut.sccpu.cpu_ref.array_reg[11]);
		$fdisplay(file_output, "regfile12: %h", CPU31_tb.uut.sccpu.cpu_ref.array_reg[12]);
		$fdisplay(file_output, "regfile13: %h", CPU31_tb.uut.sccpu.cpu_ref.array_reg[13]);
		$fdisplay(file_output, "regfile14: %h", CPU31_tb.uut.sccpu.cpu_ref.array_reg[14]);
		$fdisplay(file_output, "regfile15: %h", CPU31_tb.uut.sccpu.cpu_ref.array_reg[15]);
		$fdisplay(file_output, "regfile16: %h", CPU31_tb.uut.sccpu.cpu_ref.array_reg[16]);
		$fdisplay(file_output, "regfile17: %h", CPU31_tb.uut.sccpu.cpu_ref.array_reg[17]);
		$fdisplay(file_output, "regfile18: %h", CPU31_tb.uut.sccpu.cpu_ref.array_reg[18]);
		$fdisplay(file_output, "regfile19: %h", CPU31_tb.uut.sccpu.cpu_ref.array_reg[19]);
		$fdisplay(file_output, "regfile20: %h", CPU31_tb.uut.sccpu.cpu_ref.array_reg[20]);
		$fdisplay(file_output, "regfile21: %h", CPU31_tb.uut.sccpu.cpu_ref.array_reg[21]);
		$fdisplay(file_output, "regfile22: %h", CPU31_tb.uut.sccpu.cpu_ref.array_reg[22]);
		$fdisplay(file_output, "regfile23: %h", CPU31_tb.uut.sccpu.cpu_ref.array_reg[23]);
		$fdisplay(file_output, "regfile24: %h", CPU31_tb.uut.sccpu.cpu_ref.array_reg[24]);
		$fdisplay(file_output, "regfile25: %h", CPU31_tb.uut.sccpu.cpu_ref.array_reg[25]);
		$fdisplay(file_output, "regfile26: %h", CPU31_tb.uut.sccpu.cpu_ref.array_reg[26]);
		$fdisplay(file_output, "regfile27: %h", CPU31_tb.uut.sccpu.cpu_ref.array_reg[27]);
		$fdisplay(file_output, "regfile28: %h", CPU31_tb.uut.sccpu.cpu_ref.array_reg[28]);
		$fdisplay(file_output, "regfile29: %h", CPU31_tb.uut.sccpu.cpu_ref.array_reg[29]);
		$fdisplay(file_output, "regfile30: %h", CPU31_tb.uut.sccpu.cpu_ref.array_reg[30]);
		$fdisplay(file_output, "regfile31: %h", CPU31_tb.uut.sccpu.cpu_ref.array_reg[31]);
	end
end
endmodule
