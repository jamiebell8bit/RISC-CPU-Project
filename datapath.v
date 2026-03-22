`timescale 1ns/10ps

// Datapath code
// Group: 22
//
// Phase 2 plumbing version.
// Adds:
// - RAM memory block
// - full MAR / MDR memory path
// - In.Port and Out.Port
// - bus support for InPortout and Cout
//
// Note:
// Gra/Grb/Grc, BAout, CON FF, revised R0, and other Phase 2 control logic
// are not done yet

module datapath (
    // General register controls
    input  [15:0] Rin,
    input  [15:0] Rout,

    // Bus / special register controls
    input PCout,
    input PCin,
    input IRin,
    input IRout,
    input MARin,
    input MDRin,
    input MDRout,
    input HIin,
    input HIout,
    input LOin,
    input LOout,
    input Yin,
    input Zin,
    input Zhighout,
    input Zlowout,

    // Phase 2 I/O controls
    input InPortout,
    input OutPortin,
    input Cout,

    // Other controls
    input IncPC,
    input Read,
    input Write,
    input [4:0] opcode,

    // Clock + external input
    input Clock,
    input [31:0] Mdatain,
    input [31:0] InPortData,

    // Helpful observable outputs for debugging / demo
    output [31:0] OutPortData,
    output [31:0] MARData,
    output [31:0] RAMDataOut
);

    // Internal reset (simulation convenience)
    reg clear_int;
    initial begin
        clear_int = 1'b1;
        #5 clear_int = 1'b0;
    end

    // Shared bus
    wire [31:0] BusMuxOut;

    // Registers R0..R15
    wire [31:0] R0_q,  R1_q,  R2_q,  R3_q;
    wire [31:0] R4_q,  R5_q,  R6_q,  R7_q;
    wire [31:0] R8_q,  R9_q,  R10_q, R11_q;
    wire [31:0] R12_q, R13_q, R14_q, R15_q;

    register #(32,32,32'h0) R0  (clear_int, Clock, Rin[0],  BusMuxOut, R0_q);
    register #(32,32,32'h0) R1  (clear_int, Clock, Rin[1],  BusMuxOut, R1_q);
    register #(32,32,32'h0) R2  (clear_int, Clock, Rin[2],  BusMuxOut, R2_q);
    register #(32,32,32'h0) R3  (clear_int, Clock, Rin[3],  BusMuxOut, R3_q);
    register #(32,32,32'h0) R4  (clear_int, Clock, Rin[4],  BusMuxOut, R4_q);
    register #(32,32,32'h0) R5  (clear_int, Clock, Rin[5],  BusMuxOut, R5_q);
    register #(32,32,32'h0) R6  (clear_int, Clock, Rin[6],  BusMuxOut, R6_q);
    register #(32,32,32'h0) R7  (clear_int, Clock, Rin[7],  BusMuxOut, R7_q);
    register #(32,32,32'h0) R8  (clear_int, Clock, Rin[8],  BusMuxOut, R8_q);
    register #(32,32,32'h0) R9  (clear_int, Clock, Rin[9],  BusMuxOut, R9_q);
    register #(32,32,32'h0) R10 (clear_int, Clock, Rin[10], BusMuxOut, R10_q);
    register #(32,32,32'h0) R11 (clear_int, Clock, Rin[11], BusMuxOut, R11_q);
    register #(32,32,32'h0) R12 (clear_int, Clock, Rin[12], BusMuxOut, R12_q);
    register #(32,32,32'h0) R13 (clear_int, Clock, Rin[13], BusMuxOut, R13_q);
    register #(32,32,32'h0) R14 (clear_int, Clock, Rin[14], BusMuxOut, R14_q);
    register #(32,32,32'h0) R15 (clear_int, Clock, Rin[15], BusMuxOut, R15_q);

    // Special regs
    wire [31:0] IR_q;
    wire [31:0] MAR_q;
    wire [31:0] MDR_q;
    wire [31:0] HI_q, LO_q;
    wire [31:0] Y_q;
    wire [63:0] Z_q;
    wire [31:0] InPort_q;

    // PC as a normal register (loads via PCin)
    wire [31:0] PC_q;
    register #(32,32,32'h0) PC (clear_int, Clock, PCin, BusMuxOut, PC_q);

    IR  IR0  (clear_int, Clock, IRin,  BusMuxOut, IR_q);
    MAR MAR0 (clear_int, Clock, MARin, BusMuxOut, MAR_q);

    // Memory subsystem
    wire [31:0] RAM_q;
    RAM RAM0 (
        .clock(Clock),
        .Read(Read),
        .Write(Write),
        .Address(MAR_q[8:0]),
        .DataIn(MDR_q),
        .DataOut(RAM_q)
    );

    // For Phase 2, memory data should come from RAM.
    // Mdatain is kept here for convenience / transition from Phase 1.
    // If Mdatain is non-zero during a read cycle, it overrides RAM_q.
    wire [31:0] MDR_mem_input;
    assign MDR_mem_input = (Mdatain != 32'b0) ? Mdatain : RAM_q;

    MDR MDR0 (clear_int, Clock, MDRin, Read, BusMuxOut, MDR_mem_input, MDR_q);

    register #(32,32,32'h0) HI (clear_int, Clock, HIin, BusMuxOut, HI_q);
    register #(32,32,32'h0) LO (clear_int, Clock, LOin, BusMuxOut, LO_q);
    register #(32,32,32'h0) Y  (clear_int, Clock, Yin,  BusMuxOut, Y_q);

    // Phase 2 I/O ports
    InPort INPORT0 (
        .clear(clear_int),
        .clock(Clock),
        .ExternalInput(InPortData),
        .BusMuxIn_InPort(InPort_q)
    );

    OutPort OUTPORT0 (
        .clear(clear_int),
        .clock(Clock),
        .OutPortin(OutPortin),
        .BusMuxOut(BusMuxOut),
        .OutPortData(OutPortData)
    );

    // ALU output
    wire [63:0] ALU_Z;
    alu ALU0 (
        .A(Y_q),
        .B(BusMuxOut),
        .ALUop(opcode),
        .Z(ALU_Z)
    );

    // PC+1 for fetch staging into Z
    wire [31:0] pc_plus_one;
    wire pc_cout;
    adder32 PCINC (
        .A(PC_q),
        .B(32'h00000001),
        .SUB(1'b0),
        .S(pc_plus_one),
        .Cout(pc_cout)
    );

    wire [63:0] Z_in = IncPC ? {32'b0, pc_plus_one} : ALU_Z;

    register64 #(64,64,64'h0) Z (
        .clear(clear_int),
        .clock(Clock),
        .enable(Zin),
        .BusMuxOut(Z_in),
        .BusMuxIn(Z_q)
    );

    wire [31:0] Zhigh = Z_q[63:32];
    wire [31:0] Zlow  = Z_q[31:0];

    // Sign-extended constant C from IR[17:0]
    wire [31:0] C_sign_extended;
    assign C_sign_extended = {{14{IR_q[18]}}, IR_q[17:0]};

    // Bus
    Bus BUS0 (
        R0_q, R1_q, R2_q, R3_q,
        R4_q, R5_q, R6_q, R7_q,
        R8_q, R9_q, R10_q, R11_q,
        R12_q, R13_q, R14_q, R15_q,

        PC_q,
        IR_q,
        MDR_q,
        HI_q,
        LO_q,
        Zhigh,
        Zlow,
        InPort_q,
        C_sign_extended,

        Rout[0], Rout[1], Rout[2], Rout[3],
        Rout[4], Rout[5], Rout[6], Rout[7],
        Rout[8], Rout[9], Rout[10], Rout[11],
        Rout[12], Rout[13], Rout[14], Rout[15],

        PCout,
        IRout,
        MDRout,
        HIout,
        LOout,
        Zhighout,
        Zlowout,
        InPortout,
        Cout,

        BusMuxOut
    );

    assign MARData   = MAR_q;
    assign RAMDataOut = RAM_q;

endmodule
