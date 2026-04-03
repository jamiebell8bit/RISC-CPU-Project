`timescale 1ns/10ps

module datapath (
    input Reset,
    input  [15:0] Rin,
    input  [15:0] Rout,
    input Gra, Grb, Grc,
    input BAout,
    input CONin,
    output reg CON,
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
    input InPortout,
    input OutPortin,
    input Cout,
    input IncPC,
    input Read,
    input Write,
    input [4:0] opcode,
    input Clock,
    input [31:0] Mdatain,
    input [31:0] InPortData,
    output [31:0] OutPortData,
    output [31:0] MARData,
    output [31:0] RAMDataOut,
    output [31:0] IRData,
    output [31:0] PCData,
    output [31:0] MDRData,
    output [31:0] HIData,
    output [31:0] LOData,
    output [31:0] R0Data,
    output [31:0] R1Data,
    output [31:0] R2Data,
    output [31:0] R3Data,
    output [31:0] R4Data,
    output [31:0] R5Data,
    output [31:0] R6Data,
    output [31:0] R7Data,
    output [31:0] R8Data,
    output [31:0] R9Data,
    output [31:0] R10Data,
    output [31:0] R11Data,
    output [31:0] R12Data,
    output [31:0] R13Data,
    output [31:0] R14Data,
    output [31:0] R15Data,
    output [31:0] Mem89Data,
    output [31:0] MemA3Data
);

    reg clear_int;
    initial begin
        clear_int = 1'b1;
        #5 clear_int = 1'b0;
    end

    wire clear_all = clear_int | Reset;
    wire [31:0] BusMuxOut;

    wire [31:0] R0_q,  R1_q,  R2_q,  R3_q;
    wire [31:0] R4_q,  R5_q,  R6_q,  R7_q;
    wire [31:0] R8_q,  R9_q,  R10_q, R11_q;
    wire [31:0] R12_q, R13_q, R14_q, R15_q;

    wire [31:0] IR_q;
    wire [3:0] Ra = IR_q[26:23];
    wire [3:0] Rb = IR_q[22:19];
    wire [3:0] Rc = IR_q[18:15];

    wire [15:0] Rin_sel;
    wire [15:0] Rout_sel;
    reg [15:0] Rin_decoded;
    reg [15:0] Rout_decoded;

    select_encode SE0(
        .IR(IR_q),
        .Gra(Gra),
        .Grb(Grb),
        .Grc(Grc),
        .Rin(|Rin),
        .Rout((|Rout) || BAout),
        .Rin_out(Rin_sel),
        .Rout_out(Rout_sel)
    );

    always @(*) begin
        if (Gra || Grb || Grc) begin
            Rin_decoded = Rin_sel;
            Rout_decoded = Rout_sel;
        end
        else begin
            Rin_decoded = Rin;
            Rout_decoded = Rout;
        end
    end

    register #(32,32,32'h0) R0  (clear_all, Clock, Rin_decoded[0],  BusMuxOut, R0_q);
    register #(32,32,32'h0) R1  (clear_all, Clock, Rin_decoded[1],  BusMuxOut, R1_q);
    register #(32,32,32'h0) R2  (clear_all, Clock, Rin_decoded[2],  BusMuxOut, R2_q);
    register #(32,32,32'h0) R3  (clear_all, Clock, Rin_decoded[3],  BusMuxOut, R3_q);
    register #(32,32,32'h0) R4  (clear_all, Clock, Rin_decoded[4],  BusMuxOut, R4_q);
    register #(32,32,32'h0) R5  (clear_all, Clock, Rin_decoded[5],  BusMuxOut, R5_q);
    register #(32,32,32'h0) R6  (clear_all, Clock, Rin_decoded[6],  BusMuxOut, R6_q);
    register #(32,32,32'h0) R7  (clear_all, Clock, Rin_decoded[7],  BusMuxOut, R7_q);
    register #(32,32,32'h0) R8  (clear_all, Clock, Rin_decoded[8],  BusMuxOut, R8_q);
    register #(32,32,32'h0) R9  (clear_all, Clock, Rin_decoded[9],  BusMuxOut, R9_q);
    register #(32,32,32'h0) R10 (clear_all, Clock, Rin_decoded[10], BusMuxOut, R10_q);
    register #(32,32,32'h0) R11 (clear_all, Clock, Rin_decoded[11], BusMuxOut, R11_q);
    register #(32,32,32'h0) R12 (clear_all, Clock, Rin_decoded[12], BusMuxOut, R12_q);
    register #(32,32,32'h0) R13 (clear_all, Clock, Rin_decoded[13], BusMuxOut, R13_q);
    register #(32,32,32'h0) R14 (clear_all, Clock, Rin_decoded[14], BusMuxOut, R14_q);
    register #(32,32,32'h0) R15 (clear_all, Clock, Rin_decoded[15], BusMuxOut, R15_q);

    wire [31:0] R0_modified = (BAout && Rout_decoded[0]) ? 32'b0 : R0_q;

    wire [31:0] MAR_q;
    wire [31:0] MDR_q;
    wire [31:0] HI_q, LO_q;
    wire [31:0] Y_q;
    wire [63:0] Z_q;
    wire [31:0] InPort_q;
    wire [31:0] OutPort_q;
    wire [31:0] PC_q;

    register #(32,32,32'h0) PC (clear_all, Clock, PCin, BusMuxOut, PC_q);
    IR  IR0  (clear_all, Clock, IRin,  BusMuxOut, IR_q);
    MAR MAR0 (clear_all, Clock, MARin, BusMuxOut, MAR_q);

    wire [31:0] RAM_q;
    wire [31:0] Mem89_q;
    wire [31:0] MemA3_q;
    RAM RAM0 (
        .clock(Clock),
        .Read(Read),
        .Write(Write),
        .Address(MAR_q[8:0]),
        .DataIn(MDR_q),
        .DataOut(RAM_q),
        .Mem89(Mem89_q),
        .MemA3(MemA3_q)
    );

    wire [31:0] MDR_mem_input = (Mdatain != 32'b0) ? Mdatain : RAM_q;

    MDR MDR0 (clear_all, Clock, MDRin, Read, BusMuxOut, MDR_mem_input, MDR_q);
    register #(32,32,32'h0) HI (clear_all, Clock, HIin, BusMuxOut, HI_q);
    register #(32,32,32'h0) LO (clear_all, Clock, LOin, BusMuxOut, LO_q);
    register #(32,32,32'h0) Y  (clear_all, Clock, Yin,  BusMuxOut, Y_q);

    InPort INPORT0 (
        .clear(clear_all),
        .clock(Clock),
        .ExternalInput(InPortData),
        .BusMuxIn_InPort(InPort_q)
    );

    OutPort OUTPORT0 (
        .clear(clear_all),
        .clock(Clock),
        .OutPortin(OutPortin),
        .BusMuxOut(BusMuxOut),
        .OutPortData(OutPort_q)
    );

    wire CON_next;

    con_ff CONFF0(
        .Bus(BusMuxOut),
        .IR(IR_q),
        .CON_out(CON_next)
    );

    always @(posedge Clock or posedge clear_all) begin
        if (clear_all)
            CON <= 1'b0;
        else if (CONin)
            CON <= CON_next;
    end

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
        .clear(clear_all),
        .clock(Clock),
        .enable(Zin),
        .BusMuxOut(Z_in),
        .BusMuxIn(Z_q)
    );

    wire [31:0] Zhigh = Z_q[63:32];
    wire [31:0] Zlow  = Z_q[31:0];
    wire [31:0] C_sign_extended = {{13{IR_q[18]}}, IR_q[18:0]};

    Bus BUS0 (
        R0_modified, R1_q, R2_q, R3_q,
        R4_q, R5_q, R6_q, R7_q,
        R8_q, R9_q, R10_q, R11_q,
        R12_q, R13_q, R14_q, R15_q,
        PC_q, IR_q, MDR_q, HI_q, LO_q, Zhigh, Zlow, InPort_q, C_sign_extended,
        Rout_decoded[0], Rout_decoded[1], Rout_decoded[2], Rout_decoded[3],
        Rout_decoded[4], Rout_decoded[5], Rout_decoded[6], Rout_decoded[7],
        Rout_decoded[8], Rout_decoded[9], Rout_decoded[10], Rout_decoded[11],
        Rout_decoded[12], Rout_decoded[13], Rout_decoded[14], Rout_decoded[15],
        PCout, IRout, MDRout, HIout, LOout, Zhighout, Zlowout, InPortout, Cout,
        BusMuxOut
    );

    assign OutPortData = OutPort_q;
    assign MARData = MAR_q;
    assign RAMDataOut = RAM_q;
    assign IRData = IR_q;
    assign PCData = PC_q;
    assign MDRData = MDR_q;
    assign HIData = HI_q;
    assign LOData = LO_q;
    assign R0Data = R0_q;
    assign R1Data = R1_q;
    assign R2Data = R2_q;
    assign R3Data = R3_q;
    assign R4Data = R4_q;
    assign R5Data = R5_q;
    assign R6Data = R6_q;
    assign R7Data = R7_q;
    assign R8Data = R8_q;
    assign R9Data = R9_q;
    assign R10Data = R10_q;
    assign R11Data = R11_q;
    assign R12Data = R12_q;
    assign R13Data = R13_q;
    assign R14Data = R14_q;
    assign R15Data = R15_q;
    assign Mem89Data = Mem89_q;
    assign MemA3Data = MemA3_q;

endmodule
