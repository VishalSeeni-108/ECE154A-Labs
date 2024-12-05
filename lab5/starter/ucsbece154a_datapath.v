// ucsbece154a_datapath.v
// All Rights Reserved
// Copyright (c) 2023 UCSB ECE
// Distribution Prohibited

// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// TO DO: Add mising code below  
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

module ucsbece154a_datapath (
    input               clk, reset,
    input               PCEn_i,
    input         [1:0] ALUSrcA_i,
    input         [1:0] ALUSrcB_i,
    input               RegWrite_i,
    input               AdrSrc_i,
    input               IRWrite_i,
    input         [1:0] ResultSrc_i,
    input         [2:0] ALUControl_i,
    input         [2:0] ImmSrc_i,
    output  wire        zero_o,
    output  wire [31:0] Adr_o,                       
    output  wire [31:0] WriteData_o,                    
    input        [31:0] ReadData_i,
    output  wire [6:0]  op_o,
    output  wire [2:0]  funct3_o,
    output  wire        funct7_o
);

`include "ucsbece154a_defines.vh"

// Internal registers

reg [31:0] PC, OldPC, Instr, Data, A, B, ALUout;

// Buses connected to internal registers
reg [31:0] Result;
wire [4:0] a1 = Instr[19:15];
wire [4:0] a2 = Instr[24:20];
wire [4:0] a3 = Instr[11:7];
wire [31:0] rd1, rd2;
wire [31:0] ALUResult;



// Update for all internal registers

always @(posedge clk) begin
    if (reset) begin
        PC <= pc_start;
        OldPC <= {32{1'bx}};
        Instr <= {32{1'bx}};
        Data <= {32{1'bx}};
        A <= {32{1'bx}};
        B <= {32{1'bx}};
        ALUout <= {32{1'bx}};
    end else begin
        if (PCEn_i) PC <= Result;
        if (IRWrite_i) OldPC <= PC;
        if (IRWrite_i) Instr <= ReadData_i;
        Data <= ReadData_i;
        A <= rd1;
        B <= rd2;
        ALUout <= ALUResult;
    end
end

// **PUT THE REST OF YOUR CODE HERE**
reg [31:0] SrcA; 
reg [31:0] SrcB;
reg [31:0] ImmExt; 

//Additional outputs
assign WriteData_o = B; 
assign op_o = Instr[6:0];
assign funct3_o = Instr[14:12];
assign funct7_o = Instr[30]; 

ucsbece154a_rf rf (
    .clk(clk),
    .a1_i(a1), .a2_i(a2), .a3_i(a3),
    .rd1_o(rd1), .rd2_o(rd2),
    .we3_i(RegWrite_i),
    .wd3_i(Result)
);

ucsbece154a_alu alu (
    .a_i(SrcA), .b_i(SrcB),
    .alucontrol_i(ALUControl_i),
    .result_o(ALUResult),
    .zero_o(zero_o)
);

// Extend unit block


always @ * begin
	if(ImmSrc_i == 3'b000)begin
    	ImmExt[31:12] = {20{Instr[31]}};
    	ImmExt[11:0] = Instr[31:20]; //Check this in testing to make sure extension is being done properly
	end 
	else if(ImmSrc_i == 3'b001) begin
    	ImmExt[31:12] = {20{Instr[31]}}; 
    	ImmExt[11:5] = Instr[31:25];
    	ImmExt[4:0] = Instr[11:7];
	end 
	else if(ImmSrc_i == 3'b010) begin
    	ImmExt[31:12] = {20{Instr[31]}}; 
    	ImmExt[11] = Instr[7];
    	ImmExt[10:5] = Instr[30:25];
    	ImmExt[4:1] = Instr[11:8];
    	ImmExt[0] = 0; 
	end
	else if(ImmSrc_i == 3'b011) begin
	ImmExt[31:20] = {12{Instr[31]}}; 
	ImmExt[19:12] = Instr[19:12]; 
	ImmExt[11] = Instr[20];
	ImmExt[10:1] = Instr[30:21];
	ImmExt[0] = 0; 
	end 
	else if(ImmSrc_i == 3'b100) begin
	ImmExt[31:12] = Instr[31:12];
	ImmExt[11:0] = 0; 
	end
	else begin
	ImmExt[31:0] = {32{1'bx}};
	end
end


// Muxes

//Adr Mux
assign Adr_o = AdrSrc_i ? Result : PC; 

always @ * begin
	//SrcA Mux
	SrcA = PC; 
	if(ALUSrcA_i[0]) begin
		SrcA = OldPC; 
	end else if(ALUSrcA_i[1]) begin
		SrcA = A;
	end

	//SrcB Mux
	SrcB = B; 
	if(ALUSrcB_i[0]) begin
		SrcB = ImmExt; 
	end else if(ALUSrcB_i[1]) begin
		SrcB = 4;
	end

	//Result Mux
	if(ResultSrc_i == 2'b00) begin
		Result = ALUout;
	end else if(ResultSrc_i == 2'b01) begin
		Result = Data; 
	end else if(ResultSrc_i == 2'b10) begin
		Result = ALUResult; 
	end else if(ResultSrc_i == 2'b11) begin
		Result = ImmExt; 
	end else begin
		Result = {32{1'bx}};
	end

end
 


endmodule
