`include "fetch.v"
`include "decode.v"
`include "execute.v"
`include "memory.v"
`include "PC_Update.v"

module Datapath_Unit(
    input clk,
    output AOK_stat, HLT_stat, ADR_stat, INS_stat
);

    reg [63:0] pc_current;
    wire [3:0] icode, ifun;
    wire [3:0] rA, rB;
    wire [63:0] valC;
    wire [63:0] valP;
    wire cnd;
    wire instr_valid;
    wire imem_error;
    wire [63:0] valE, valM;
    wire [63:0] valA, valB;
    wire [63:0] pc_next;

    initial begin
        pc_current <= 0;
    end

    always @(posedge clk) begin
        pc_current <= pc_next;
    end

    fetch f(
        .pc_current(pc_current), 
        .icode(icode), .ifun(ifun), 
        .rA(rA), .rB(rB), 
        .valC(valC), 
        .valP(valP),
        .instr_valid(instr_valid),
        .imem_error(imem_error)
    );
    
    decode d(
        .clk(clk),
        .cnd(cnd),
        .icode(icode),
        .rA(rA), .rB(rB),
        .valE(valE), .valM(valM),
        .valA(valA), .valB(valB)
    );

    execute e(
        .clk(clk),
        .icode(icode), .ifun(ifun),
        .valA(valA), .valB(valB),
        .valC(valC),
        .cnd(cnd),
        .valE(valE)
    );

    memory m(
        .clk(clk),
        .icode(icode),
        .valE(valE), .valA(valA), .valP(valP),
        .imem_error(imem_error), .instr_valid(instr_valid),
        .valM(valM),
        .AOK_stat(AOK_stat),
        .HLT_stat(HLT_stat),
        .ADR_stat(ADR_stat),
        .INS_stat(INS_stat)
    );

    PC_Update P(
        .icode(icode),
        .cnd(cnd),
        .valC(valC), .valM(valM), .valP(valP),
        .pc_next(pc_next)
    );
endmodule

module tb();

    reg clk;
    wire AOK_stat, HLT_stat, ADR_stat, INS_stat;

    Datapath_Unit dut(.clk(clk), .AOK_stat(AOK_stat), .HLT_stat(HLT_stat), .ADR_stat(ADR_stat), .INS_stat(INS_stat));

    initial begin
        clk <= 0;
            forever #5 clk <= ~clk; 
    end

    initial begin

        $dumpvars(0, tb);

        $monitor("clk = %b, AOK = %b, HLT = %b, ADR = %b, INS = %b", clk, AOK_stat, HLT_stat, ADR_stat, INS_stat);
        #800;
        $finish;
    end
endmodule
