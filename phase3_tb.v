`timescale 1ns/10ps
module phase3_tb;

reg Clock;
reg Reset;
reg Stop;
reg [31:0] InPortData;

wire Run;

wire [7:0] state_dbg;
wire [31:0] IR_dbg, PC_dbg, MDR_dbg, MAR_dbg, HI_dbg, LO_dbg;
wire [31:0] R0_dbg, R1_dbg, R2_dbg, R3_dbg, R4_dbg, R5_dbg, R6_dbg, R7_dbg;
wire [31:0] R8_dbg, R9_dbg, R10_dbg, R11_dbg, R12_dbg, R13_dbg, R14_dbg, R15_dbg;
wire [31:0] OutPortData, RAMDataOut, Mem89_dbg, MemA3_dbg;
wire CON_dbg;
wire [15:0] Rin_dbg, Rout_dbg;
wire Gra_dbg, Grb_dbg, Grc_dbg, BAout_dbg, CONin_dbg;
wire PCout_dbg, PCin_dbg, IRin_dbg, IRout_dbg, MARin_dbg, MDRin_dbg, MDRout_dbg;
wire HIin_dbg, HIout_dbg, LOin_dbg, LOout_dbg, Yin_dbg, Zin_dbg, Zhighout_dbg, Zlowout_dbg;
wire InPortout_dbg, OutPortin_dbg, Cout_dbg, IncPC_dbg, Read_dbg, Write_dbg;
wire [4:0] ALUop_dbg;

CPU uut (
    .Clock(Clock),
    .Reset(Reset),
    .Stop(Stop),
    .InPortData(InPortData),
    .Run(Run),

    .state_dbg(state_dbg),
    .IR_dbg(IR_dbg),
    .PC_dbg(PC_dbg),
    .MDR_dbg(MDR_dbg),
    .MAR_dbg(MAR_dbg),
    .HI_dbg(HI_dbg),
    .LO_dbg(LO_dbg),

    .R0_dbg(R0_dbg),
    .R1_dbg(R1_dbg),
    .R2_dbg(R2_dbg),
    .R3_dbg(R3_dbg),
    .R4_dbg(R4_dbg),
    .R5_dbg(R5_dbg),
    .R6_dbg(R6_dbg),
    .R7_dbg(R7_dbg),
    .R8_dbg(R8_dbg),
    .R9_dbg(R9_dbg),
    .R10_dbg(R10_dbg),
    .R11_dbg(R11_dbg),
    .R12_dbg(R12_dbg),
    .R13_dbg(R13_dbg),
    .R14_dbg(R14_dbg),
    .R15_dbg(R15_dbg),

    .OutPortData(OutPortData),
    .RAMDataOut(RAMDataOut),
    .Mem89_dbg(Mem89_dbg),
    .MemA3_dbg(MemA3_dbg),

    .CON_dbg(CON_dbg),
    .Rin_dbg(Rin_dbg),
    .Rout_dbg(Rout_dbg),
    .Gra_dbg(Gra_dbg),
    .Grb_dbg(Grb_dbg),
    .Grc_dbg(Grc_dbg),
    .BAout_dbg(BAout_dbg),
    .CONin_dbg(CONin_dbg),

    .PCout_dbg(PCout_dbg),
    .PCin_dbg(PCin_dbg),
    .IRin_dbg(IRin_dbg),
    .IRout_dbg(IRout_dbg),
    .MARin_dbg(MARin_dbg),
    .MDRin_dbg(MDRin_dbg),
    .MDRout_dbg(MDRout_dbg),
    .HIin_dbg(HIin_dbg),
    .HIout_dbg(HIout_dbg),
    .LOin_dbg(LOin_dbg),
    .LOout_dbg(LOout_dbg),
    .Yin_dbg(Yin_dbg),
    .Zin_dbg(Zin_dbg),
    .Zhighout_dbg(Zhighout_dbg),
    .Zlowout_dbg(Zlowout_dbg),
    .InPortout_dbg(InPortout_dbg),
    .OutPortin_dbg(OutPortin_dbg),
    .Cout_dbg(Cout_dbg),
    .IncPC_dbg(IncPC_dbg),
    .Read_dbg(Read_dbg),
    .Write_dbg(Write_dbg),
    .ALUop_dbg(ALUop_dbg)
);

initial begin
    Clock = 1'b0;
    forever #10 Clock = ~Clock;
end

initial begin
    Reset = 1'b1;
    Stop = 1'b0;
    InPortData = 32'b0;
    #30 Reset = 1'b0;
    #5000;
end

endmodule