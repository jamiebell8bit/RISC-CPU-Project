// Bus Code
// Group: 22
// Phase 2 updated

module Bus (
    // Data sources onto the bus
    input [31:0] R0,  input [31:0] R1,  input [31:0] R2,  input [31:0] R3,
    input [31:0] R4,  input [31:0] R5,  input [31:0] R6,  input [31:0] R7,
    input [31:0] R8,  input [31:0] R9,  input [31:0] R10, input [31:0] R11,
    input [31:0] R12, input [31:0] R13, input [31:0] R14, input [31:0] R15,

    input [31:0] PC,
    input [31:0] IR,
    input [31:0] MDR,
    input [31:0] HI,
    input [31:0] LO,
    input [31:0] Zhigh,
    input [31:0] Zlow,
    input [31:0] InPortData,
    input [31:0] Csignextended,

    input R0out,  input R1out,  input R2out,  input R3out,
    input R4out,  input R5out,  input R6out,  input R7out,
    input R8out,  input R9out,  input R10out, input R11out,
    input R12out, input R13out, input R14out, input R15out,

    input PCout,
    input IRout,
    input MDRout,
    input HIout,
    input LOout,
    input Zhighout,
    input Zlowout,
    input InPortout,
    input Cout,

    // Bus output
    output reg [31:0] BusOut
);

    always @(*) begin
        // Default bus value when nothing is driving the bus
        BusOut = 32'b0;

        // Priority selection (assumes only one control is asserted)
        if (R0out)       BusOut = R0;
        else if (R1out)  BusOut = R1;
        else if (R2out)  BusOut = R2;
        else if (R3out)  BusOut = R3;
        else if (R4out)  BusOut = R4;
        else if (R5out)  BusOut = R5;
        else if (R6out)  BusOut = R6;
        else if (R7out)  BusOut = R7;
        else if (R8out)  BusOut = R8;
        else if (R9out)  BusOut = R9;
        else if (R10out) BusOut = R10;
        else if (R11out) BusOut = R11;
        else if (R12out) BusOut = R12;
        else if (R13out) BusOut = R13;
        else if (R14out) BusOut = R14;
        else if (R15out) BusOut = R15;

        else if (PCout)      BusOut = PC;
        else if (IRout)      BusOut = IR;
        else if (MDRout)     BusOut = MDR;
        else if (HIout)      BusOut = HI;
        else if (LOout)      BusOut = LO;
        else if (Zhighout)   BusOut = Zhigh;
        else if (Zlowout)    BusOut = Zlow;
        else if (InPortout)  BusOut = InPortData;
        else if (Cout)       BusOut = Csignextended;
    end

endmodule