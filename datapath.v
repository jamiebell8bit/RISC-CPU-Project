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
// - Gra, Grb, Grc suppoort
// - BAout and R0 revision 
// - CON FF
// - Revised R0

module datapath (
    // General register controls
    input  [15:0] Rin,
    input  [15:0] Rout,

    //// Added missing inputs
    input Gra, Grb, Grc,
    input BAout,
    input CONin,
    output reg CON,

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

    //// Select & Decode ////
	 wire [31:0] IR_q;
	 
    wire [3:0] Ra = IR_q[26:23];
    wire [3:0] Rb = IR_q[22:19];
    wire [3:0] Rc = IR_q[18:15];

    reg [3:0] Sel;

    always @(*) begin
        if (Gra) Sel = Ra;
        else if (Grb) Sel = Rb;
        else if (Grc) Sel = Rc;
        else Sel = 4'b0000;
    end

    reg [15:0] Rin_decoded, Rout_decoded;

  	always @(*) begin
		 Rin_decoded  = 16'b0;
		 Rout_decoded = 16'b0;

		 if (|Rin)
			  Rin_decoded[Sel] = 1'b1;

		 // BAout must also select the chosen Rb onto the bus
		 if ((|Rout) || BAout)
			  Rout_decoded[Sel] = 1'b1;
	end
    //// Registers ////

    register #(32,32,32'h0) R0  (clear_int, Clock, Rin_decoded[0],  BusMuxOut, R0_q);
    register #(32,32,32'h0) R1  (clear_int, Clock, Rin_decoded[1],  BusMuxOut, R1_q);
    register #(32,32,32'h0) R2  (clear_int, Clock, Rin_decoded[2],  BusMuxOut, R2_q);
    register #(32,32,32'h0) R3  (clear_int, Clock, Rin_decoded[3],  BusMuxOut, R3_q);
    register #(32,32,32'h0) R4  (clear_int, Clock, Rin_decoded[4],  BusMuxOut, R4_q);
    register #(32,32,32'h0) R5  (clear_int, Clock, Rin_decoded[5],  BusMuxOut, R5_q);
    register #(32,32,32'h0) R6  (clear_int, Clock, Rin_decoded[6],  BusMuxOut, R6_q);
    register #(32,32,32'h0) R7  (clear_int, Clock, Rin_decoded[7],  BusMuxOut, R7_q);
    register #(32,32,32'h0) R8  (clear_int, Clock, Rin_decoded[8],  BusMuxOut, R8_q);
    register #(32,32,32'h0) R9  (clear_int, Clock, Rin_decoded[9],  BusMuxOut, R9_q);
    register #(32,32,32'h0) R10 (clear_int, Clock, Rin_decoded[10], BusMuxOut, R10_q);
    register #(32,32,32'h0) R11 (clear_int, Clock, Rin_decoded[11], BusMuxOut, R11_q);
    register #(32,32,32'h0) R12 (clear_int, Clock, Rin_decoded[12], BusMuxOut, R12_q);
    register #(32,32,32'h0) R13 (clear_int, Clock, Rin_decoded[13], BusMuxOut, R13_q);
    register #(32,32,32'h0) R14 (clear_int, Clock, Rin_decoded[14], BusMuxOut, R14_q);
    register #(32,32,32'h0) R15 (clear_int, Clock, Rin_decoded[15], BusMuxOut, R15_q);

    //// R0 Revision (BAout) ////

    wire [31:0] R0_modified;
    assign R0_modified = (BAout && Rout_decoded[0]) ? 32'b0 : R0_q;

    //// Special Reg ////

    wire [31:0] MAR_q;
    wire [31:0] MDR_q;
    wire [31:0] HI_q, LO_q;
    wire [31:0] Y_q;
    wire [63:0] Z_q;
    wire [31:0] InPort_q;
	 wire [31:0] OutPort_q;

    //// PC as a normal register (loads via PCin) ////
    wire [31:0] PC_q;
    register #(32,32,32'h0) PC (clear_int, Clock, PCin, BusMuxOut, PC_q);

    IR  IR0  (clear_int, Clock, IRin,  BusMuxOut, IR_q);
    MAR MAR0 (clear_int, Clock, MARin, BusMuxOut, MAR_q);

    ////  Memory subsystem ////
    wire [31:0] RAM_q;
    RAM RAM0 (
        .clock(Clock),
        .Read(Read),
        .Write(Write),
        .Address(MAR_q[8:0]),
        .DataIn(MDR_q),
        .DataOut(RAM_q)
    );

    wire [31:0] MDR_mem_input;
    assign MDR_mem_input = (Mdatain != 32'b0) ? Mdatain : RAM_q;

    MDR MDR0 (clear_int, Clock, MDRin, Read, BusMuxOut, MDR_mem_input, MDR_q);

    register #(32,32,32'h0) HI (clear_int, Clock, HIin, BusMuxOut, HI_q);
    register #(32,32,32'h0) LO (clear_int, Clock, LOin, BusMuxOut, LO_q);
    register #(32,32,32'h0) Y  (clear_int, Clock, Yin,  BusMuxOut, Y_q);
	 
	 
	 
	     //// Input / Output Ports ////

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
        .OutPortData(OutPort_q)
    );
	
	
	
    //// Con FF ////

    wire [1:0] cond = IR_q[20:19];
    wire CON_next;

    assign CON_next =
        (cond == 2'b00) ? (BusMuxOut == 0) :
        (cond == 2'b01) ? (BusMuxOut != 0) :
        (cond == 2'b10) ? (~BusMuxOut[31] && BusMuxOut != 0) :
                          (BusMuxOut[31]);

    always @(posedge Clock) begin
        if (CONin)
            CON <= CON_next;
    end

    //// ALU + Z ////

    wire [63:0] ALU_Z;
    alu ALU0 (
        .A(Y_q),
        .B(BusMuxOut),
        .ALUop(opcode),
        .Z(ALU_Z)
    );

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

    wire [31:0] C_sign_extended;
    assign C_sign_extended = {{14{IR_q[18]}}, IR_q[17:0]};

   //// Bus ////
   
    Bus BUS0 (
        R0_modified, R1_q, R2_q, R3_q,
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

        Rout_decoded[0], Rout_decoded[1], Rout_decoded[2], Rout_decoded[3],
        Rout_decoded[4], Rout_decoded[5], Rout_decoded[6], Rout_decoded[7],
        Rout_decoded[8], Rout_decoded[9], Rout_decoded[10], Rout_decoded[11],
        Rout_decoded[12], Rout_decoded[13], Rout_decoded[14], Rout_decoded[15],

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
	 assign OutPortData = OutPort_q;

endmodule