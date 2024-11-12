// ucsbece154a_datapath.v
// All Rights Reserved
// Copyright (c) 2023 UCSB ECE
// Distribution Prohibited


module ucsbece154a_datapath (
    input               clk, reset,
    input               RegWrite_i,
    input         [2:0] ImmSrc_i,
    input               ALUSrc_i,
    input               PCSrc_i,
    input         [1:0] ResultSrc_i,
    input         [2:0] ALUControl_i,
    output              zero_o,
    output reg   [31:0] pc_o,
    input        [31:0] instr_i,
    output wire  [31:0] aluresult_o, writedata_o,
    input        [31:0] readdata_i
);

`include "ucsbece154a_defines.vh"



/// Your code here

// Use name "rf" for a register file module so testbench file work properly (or modify testbench file) 

wire [31:0] RD1; //Same as SrcA
wire [31:0] RD2;
reg [31:0] SrcB;
reg [31:0] ImmExt;
reg [31:0] result;
reg [31:0] PCNext; 
reg [31:0] PCPlus4; 
reg [31:0] PCTarget;
reg [31:0] PC; 




ucsbece154a_alu alu (
    .a_i(RD1), .b_i(SrcB),
    .alucontrol_i(ALUControl_i),
    .result_o(aluresult_o),
    .zero_o(zero_o)
);

ucsbece154a_rf rf(
    .clk(clk),
    .a1_i(instr_i[19:15]), .a2_i(instr_i[24:20]), .a3_i(instr_i[11:7]),
    .rd1_o(RD1), .rd2_o(RD2),
    .we3_i(RegWrite_i),
    .wd3_i(result)
);

assign writedata_o = RD2; 
assign pc_o = PC; 

initial begin
	PC = 'h0000; 
end

always @ * begin
	//ImmExt
	if(ImmSrc_i == 000)begin
    	ImmExt[31:12] = instr_i[31];
    	ImmExt[11:0] = instr_i[31:20]; //Check this in testing to make sure extension is being done properly
	end 
	else if(ImmSrc_i == 001) begin
    	ImmExt[31:12] = instr_i[31]; 
    	ImmExt[11:5] = instr_i[31:25];
    	ImmExt[4:0] = instr_i[11:7];
	end 
	else if(ImmSrc_i == 010) begin
    	ImmExt[31:12] = instr_i[31]; 
    	ImmExt[11] = instr_i[7];
    	ImmExt[10:5] = instr_i[30:25];
    	ImmExt[4:1] = instr_i[11:8];
    	ImmExt[0] = 0; 
	end

	//SrcB Mux
    	SrcB = RD2;
    	if (ALUSrc_i) begin
        	SrcB = ImmExt;
	end

	//Result Mux
    	result = aluresult_o;
    	if (ResultSrc_i == 01) begin
		result = readdata_i; 
    	end
end

always @ clk begin
	PCPlus4 = PC + 4; 
	PCTarget = PC + ImmExt; 
	PCNext = PCPlus4; 
	if (PCSrc_i) begin
		PCNext = PCTarget; 
    	end
	PC = PCNext; 
end
endmodule
