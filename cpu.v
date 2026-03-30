`timescale 1ns/10ps

module CPU(
    input Clock,
    input Reset,
    input Stop,
    input [31:0] InPortData,

    output Run,
    output [7:0] state_dbg,
    output [31:0] IR_dbg,
    output [31:0] PC_dbg,
    output [31:0] MDR_dbg,
    output [31:0] MAR_dbg,
    output [31:0] HI_dbg,
    output [31:0] LO_dbg,
    output [31:0] R0_dbg,
    output [31:0] R1_dbg,
    output [31:0] R2_dbg,
    output [31:0] R3_dbg,
    output [31:0] R4_dbg,
    output [31:0] R5_dbg,
    output [31:0] R6_dbg,
    output [31:0] R7_dbg,
    output [31:0] R8_dbg,
    output [31:0] R9_dbg,
    output [31:0] R10_dbg,
    output [31:0] R11_dbg,
    output [31:0] R12_dbg,
    output [31:0] R13_dbg,
    output [31:0] R14_dbg,
    output [31:0] R15_dbg,
    output [31:0] OutPortData,
    output [31:0] RAMDataOut,
    output [31:0] Mem89_dbg,
    output [31:0] MemA3_dbg,
    output CON_dbg,

    output [15:0] Rin_dbg,
    output [15:0] Rout_dbg,
    output Gra_dbg,
    output Grb_dbg,
    output Grc_dbg,
    output BAout_dbg,
    output CONin_dbg,
    output PCout_dbg,
    output PCin_dbg,
    output IRin_dbg,
    output IRout_dbg,
    output MARin_dbg,
    output MDRin_dbg,
    output MDRout_dbg,
    output HIin_dbg,
    output HIout_dbg,
    output LOin_dbg,
    output LOout_dbg,
    output Yin_dbg,
    output Zin_dbg,
    output Zhighout_dbg,
    output Zlowout_dbg,
    output InPortout_dbg,
    output OutPortin_dbg,
    output Cout_dbg,
    output IncPC_dbg,
    output Read_dbg,
    output Write_dbg,
    output [4:0] ALUop_dbg
);

wire [15:0] Rin;
wire [15:0] Rout;
wire Gra, Grb, Grc, BAout, CONin;
wire PCout, PCin, IRin, IRout, MARin, MDRin, MDRout;
wire HIin, HIout, LOin, LOout, Yin, Zin, Zhighout, Zlowout;
wire InPortout, OutPortin, Cout, IncPC, Read, Write;
wire [4:0] ALUop;
wire CON;

control_unit CU0(
    .Clock(Clock),
    .Reset(Reset),
    .Stop(Stop),
    .CON_FF(CON),
    .IR(IR_dbg),
    .Rin(Rin),
    .Rout(Rout),
    .Gra(Gra),
    .Grb(Grb),
    .Grc(Grc),
    .BAout(BAout),
    .CONin(CONin),
    .PCout(PCout),
    .PCin(PCin),
    .IRin(IRin),
    .IRout(IRout),
    .MARin(MARin),
    .MDRin(MDRin),
    .MDRout(MDRout),
    .HIin(HIin),
    .HIout(HIout),
    .LOin(LOin),
    .LOout(LOout),
    .Yin(Yin),
    .Zin(Zin),
    .Zhighout(Zhighout),
    .Zlowout(Zlowout),
    .InPortout(InPortout),
    .OutPortin(OutPortin),
    .Cout(Cout),
    .IncPC(IncPC),
    .Read(Read),
    .Write(Write),
    .ALUop(ALUop),
    .Run(Run),
    .state_dbg(state_dbg)
);

assign Rin_dbg = Rin;
assign Rout_dbg = Rout;
assign Gra_dbg = Gra;
assign Grb_dbg = Grb;
assign Grc_dbg = Grc;
assign BAout_dbg = BAout;
assign CONin_dbg = CONin;
assign PCout_dbg = PCout;
assign PCin_dbg = PCin;
assign IRin_dbg = IRin;
assign IRout_dbg = IRout;
assign MARin_dbg = MARin;
assign MDRin_dbg = MDRin;
assign MDRout_dbg = MDRout;
assign HIin_dbg = HIin;
assign HIout_dbg = HIout;
assign LOin_dbg = LOin;
assign LOout_dbg = LOout;
assign Yin_dbg = Yin;
assign Zin_dbg = Zin;
assign Zhighout_dbg = Zhighout;
assign Zlowout_dbg = Zlowout;
assign InPortout_dbg = InPortout;
assign OutPortin_dbg = OutPortin;
assign Cout_dbg = Cout;
assign IncPC_dbg = IncPC;
assign Read_dbg = Read;
assign Write_dbg = Write;
assign ALUop_dbg = ALUop;
assign CON_dbg = CON;

datapath DP0(
    .Reset(Reset),
    .Rin(Rin),
    .Rout(Rout),
    .Gra(Gra),
    .Grb(Grb),
    .Grc(Grc),
    .BAout(BAout),
    .CONin(CONin),
    .CON(CON),
    .PCout(PCout),
    .PCin(PCin),
    .IRin(IRin),
    .IRout(IRout),
    .MARin(MARin),
    .MDRin(MDRin),
    .MDRout(MDRout),
    .HIin(HIin),
    .HIout(HIout),
    .LOin(LOin),
    .LOout(LOout),
    .Yin(Yin),
    .Zin(Zin),
    .Zhighout(Zhighout),
    .Zlowout(Zlowout),
    .InPortout(InPortout),
    .OutPortin(OutPortin),
    .Cout(Cout),
    .IncPC(IncPC),
    .Read(Read),
    .Write(Write),
    .opcode(ALUop),
    .Clock(Clock),
    .Mdatain(32'b0),
    .InPortData(InPortData),
    .OutPortData(OutPortData),
    .MARData(MAR_dbg),
    .RAMDataOut(RAMDataOut),
    .IRData(IR_dbg),
    .PCData(PC_dbg),
    .MDRData(MDR_dbg),
    .HIData(HI_dbg),
    .LOData(LO_dbg),
    .R0Data(R0_dbg),
    .R1Data(R1_dbg),
    .R2Data(R2_dbg),
    .R3Data(R3_dbg),
    .R4Data(R4_dbg),
    .R5Data(R5_dbg),
    .R6Data(R6_dbg),
    .R7Data(R7_dbg),
    .R8Data(R8_dbg),
    .R9Data(R9_dbg),
    .R10Data(R10_dbg),
    .R11Data(R11_dbg),
    .R12Data(R12_dbg),
    .R13Data(R13_dbg),
    .R14Data(R14_dbg),
    .R15Data(R15_dbg),
    .Mem89Data(Mem89_dbg),
    .MemA3Data(MemA3_dbg)
);

endmodule
