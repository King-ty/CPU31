`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/16 19:05:11
// Design Name: 
// Module Name: alu
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


module alu(
    input [31:0] a,		//ALU输入a
    input [31:0] b,		//ALU输入b
    input [3:0] aluc,	//ALU控制信号
    output reg [31:0] r,//ALU运算结果
    output reg zero,	//zero标志位
    output reg carry,	//carry标志位
    output reg negative,//negative标志位
    output reg overflow	//overflow标志位
    );
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
    
    reg [32:0] temp;
    always@(*)
    begin
        casex(aluc)
            4'b0000:begin//ADDU
                r=a+b;
                zero= r==0 ? 1:0;
                temp={1'b0,a}+{1'b0,b};
                carry=temp[32];
                negative=r[31];
            end
            4'b0010:begin//ADD
                r=($signed(a))+($signed(b));//($signed(r))
                zero= r==0 ? 1:0;
                negative= ($signed(r))<0 ? 1:0;//
                if(a[31]==1&&b[31]==1&&r[31]==0)
                    overflow=1;
                else if(a[31]==0&&b[31]==0&&r[31]==1)
                    overflow=1;
                else 
                    overflow=0;
            end
            4'b0001:begin//SUBU
                r=a-b;
                zero= r==0 ? 1:0;
                carry= a<b ? 1:0;
                negative=r[31];
            end
            4'b0011:begin//SUB
                r=($signed(a))-($signed(b));
                zero= r==0 ? 1:0;
                negative= ($signed(r))<0 ? 1:0;
                if(a[31]==1&&b[31]==0&&r[31]==0)
                    overflow=1;
                else if(a[31]==0&&b[31]==1&&r[31]==1)
                    overflow=1;
                else
                    overflow=0;
            end
            4'b0100:begin//AND
                r=a&b;
                zero= r==0 ? 1:0;
                negative=r[31];
            end
            4'b0101:begin//OR
                r=a|b;
                zero= r==0 ? 1:0;
                negative=r[31];
            end
            4'b0110:begin//XOR
                r=a^b;
                zero= r==0 ? 1:0;
                negative=r[31];
            end
            4'b0111:begin//NOR
                r=~(a|b);
                zero= r==0 ? 1:0;
                negative=r[31];
            end
            4'b100x:begin
//                r={b[15:0],16'b0};
                r={b[15:0],16'b0};
                zero= r==0 ? 1:0;
                negative=r[31];
            end
            4'b1011:begin//SLT
                r=($signed(a))<($signed(b)) ? 1:0;
                zero= a==b ? 1:0;
                negative= r[0];//
            end
            4'b1010:begin//SLTU
                r=a<b ? 1:0;
                zero= a==b ? 1:0;
                carry= a<b ? 1:0;
                negative=r[31];
            end
            4'b1100:begin//SRA
                r=($signed(b))>>>a;
                zero= r==0 ? 1:0;
                temp=($signed({b,1'b0}))>>>a;
                carry=temp[0];
                negative=r[31];
            end
            4'b111x:begin//SLL
                r=b<<a;
                zero= r==0 ? 1:0;
                temp={1'b0,b}<<a;
                carry=temp[32];
                negative=r[31];
            end
            4'b1101:begin//SRL
                r=b>>a;
                zero= r==0 ? 1:0;
                temp={b,1'b0}>>a;
                carry=temp[0];
                negative=r[31];
            end
            default;
        endcase
    end
endmodule
