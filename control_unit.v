`timescale 1ns/10ps

module control_unit(
    input Clock,
    input Reset,
    input Stop,
    input CON_FF,
    input [31:0] IR,

    output reg [15:0] Rin,
    output reg [15:0] Rout,
    output reg Gra,
    output reg Grb,
    output reg Grc,
    output reg BAout,
    output reg CONin,

    output reg PCout,
    output reg PCin,
    output reg IRin,
    output reg IRout,
    output reg MARin,
    output reg MDRin,
    output reg MDRout,
    output reg HIin,
    output reg HIout,
    output reg LOin,
    output reg LOout,
    output reg Yin,
    output reg Zin,
    output reg Zhighout,
    output reg Zlowout,
    output reg InPortout,
    output reg OutPortin,
    output reg Cout,
    output reg IncPC,
    output reg Read,
    output reg Write,
    output reg [4:0] ALUop,
    output reg Run,
    output reg [7:0] state_dbg
);

localparam S_RESET      = 8'd0;
localparam S_FETCH0     = 8'd1;
localparam S_FETCH1     = 8'd2;
localparam S_FETCH2     = 8'd3;

localparam S_LDI3       = 8'd10;
localparam S_LDI4       = 8'd11;
localparam S_LDI5       = 8'd12;

localparam S_LD3        = 8'd20;
localparam S_LD4        = 8'd21;
localparam S_LD5        = 8'd22;
localparam S_LD6        = 8'd23;
localparam S_LD7        = 8'd24;

localparam S_ST3        = 8'd30;
localparam S_ST4        = 8'd31;
localparam S_ST5        = 8'd32;
localparam S_ST6        = 8'd33;
localparam S_ST7        = 8'd34;

localparam S_R3         = 8'd40;
localparam S_R4         = 8'd41;
localparam S_R5         = 8'd42;

localparam S_I3         = 8'd50;
localparam S_I4         = 8'd51;
localparam S_I5         = 8'd52;

localparam S_U3         = 8'd60;
localparam S_U4         = 8'd61;
localparam S_U5         = 8'd62;

localparam S_MULDIV3    = 8'd70;
localparam S_MULDIV4    = 8'd71;
localparam S_MULDIV5    = 8'd72;
localparam S_MULDIV6    = 8'd73;

localparam S_MFHI3      = 8'd80;
localparam S_MFFLO3     = 8'd81;

localparam S_BRANCH3    = 8'd90;
localparam S_BRANCH4    = 8'd91;
localparam S_BRANCH5    = 8'd92;
localparam S_BRANCH6    = 8'd93;

localparam S_JR3        = 8'd100;
localparam S_JAL3       = 8'd101;
localparam S_JAL4       = 8'd102;

localparam S_HALT       = 8'd110;

reg [7:0] present_state, next_state;

wire [4:0] opcode = IR[31:27];

always @(posedge Clock or posedge Reset) begin
    if (Reset)
        present_state <= S_RESET;
    else
        present_state <= next_state;
end

always @(*) begin
    next_state = present_state;

    case (present_state)
        S_RESET:  next_state = S_FETCH0;
        S_FETCH0: next_state = S_FETCH1;
        S_FETCH1: next_state = S_FETCH2;

        S_FETCH2: begin
            case (opcode)
                5'b10001: next_state = S_LDI3;
                5'b10000: next_state = S_LD3;
                5'b10010: next_state = S_ST3;

                5'b00000,
                5'b00001,
                5'b00010,
                5'b00011,
                5'b00100,
                5'b00101,
                5'b00110,
                5'b00111,
                5'b01000: next_state = S_R3;

                5'b01001,
                5'b01010,
                5'b01011: next_state = S_I3;

                5'b01110,
                5'b01111: next_state = S_U3;

                5'b01100,
                5'b01101: next_state = S_MULDIV3;

                5'b11000: next_state = S_MFHI3;
                5'b11001: next_state = S_MFFLO3;
                5'b10101: next_state = S_BRANCH3;
                5'b10100: next_state = S_JR3;
                5'b10011: next_state = S_JAL3;
                5'b11010: next_state = S_FETCH0;
                5'b11011: next_state = S_HALT;
                default:  next_state = S_FETCH0;
            endcase
        end

        S_LDI3: next_state = S_LDI4;
        S_LDI4: next_state = S_LDI5;
        S_LDI5: next_state = S_FETCH0;

        S_LD3: next_state = S_LD4;
        S_LD4: next_state = S_LD5;
        S_LD5: next_state = S_LD6;
        S_LD6: next_state = S_LD7;
        S_LD7: next_state = S_FETCH0;

        S_ST3: next_state = S_ST4;
        S_ST4: next_state = S_ST5;
        S_ST5: next_state = S_ST6;
        S_ST6: next_state = S_ST7;
        S_ST7: next_state = S_FETCH0;

        S_R3: next_state = S_R4;
        S_R4: next_state = S_R5;
        S_R5: next_state = S_FETCH0;

        S_I3: next_state = S_I4;
        S_I4: next_state = S_I5;
        S_I5: next_state = S_FETCH0;

        S_U3: next_state = S_U4;
        S_U4: next_state = S_U5;
        S_U5: next_state = S_FETCH0;

        S_MULDIV3: next_state = S_MULDIV4;
        S_MULDIV4: next_state = S_MULDIV5;
        S_MULDIV5: next_state = S_MULDIV6;
        S_MULDIV6: next_state = S_FETCH0;

        S_MFHI3: next_state = S_FETCH0;
        S_MFFLO3: next_state = S_FETCH0;

        S_BRANCH3: next_state = S_BRANCH4;
        S_BRANCH4: next_state = S_BRANCH5;
        S_BRANCH5: next_state = S_BRANCH6;
        S_BRANCH6: next_state = S_FETCH0;

        S_JR3: next_state = S_FETCH0;
        S_JAL3: next_state = S_JAL4;
        S_JAL4: next_state = S_FETCH0;

        S_HALT: next_state = S_HALT;
        default: next_state = S_FETCH0;
    endcase

    if (Stop)
        next_state = S_HALT;
end

always @(*) begin
    Rin       = 16'b0;
    Rout      = 16'b0;
    Gra       = 1'b0;
    Grb       = 1'b0;
    Grc       = 1'b0;
    BAout     = 1'b0;
    CONin     = 1'b0;
    PCout     = 1'b0;
    PCin      = 1'b0;
    IRin      = 1'b0;
    IRout     = 1'b0;
    MARin     = 1'b0;
    MDRin     = 1'b0;
    MDRout    = 1'b0;
    HIin      = 1'b0;
    HIout     = 1'b0;
    LOin      = 1'b0;
    LOout     = 1'b0;
    Yin       = 1'b0;
    Zin       = 1'b0;
    Zhighout  = 1'b0;
    Zlowout   = 1'b0;
    InPortout = 1'b0;
    OutPortin = 1'b0;
    Cout      = 1'b0;
    IncPC     = 1'b0;
    Read      = 1'b0;
    Write     = 1'b0;
    ALUop     = 5'b00000;
    Run       = (present_state != S_HALT);
    state_dbg = present_state;

    case (present_state)
        S_FETCH0: begin
            PCout = 1'b1;
            MARin = 1'b1;
            IncPC = 1'b1;
            Zin   = 1'b1;
        end

        S_FETCH1: begin
            Zlowout = 1'b1;
            PCin    = 1'b1;
            Read    = 1'b1;
            MDRin   = 1'b1;
        end

        S_FETCH2: begin
            MDRout = 1'b1;
            IRin   = 1'b1;
        end

        S_LDI3: begin
            Grb   = 1'b1;
            BAout = 1'b1;
            Yin   = 1'b1;
        end
        S_LDI4: begin
            Cout  = 1'b1;
            ALUop = 5'b00000;
            Zin   = 1'b1;
        end
        S_LDI5: begin
            Zlowout = 1'b1;
            Gra     = 1'b1;
            Rin     = 16'hFFFF;
        end

        S_LD3: begin
            Grb   = 1'b1;
            BAout = 1'b1;
            Yin   = 1'b1;
        end
        S_LD4: begin
            Cout  = 1'b1;
            ALUop = 5'b00000;
            Zin   = 1'b1;
        end
        S_LD5: begin
            Zlowout = 1'b1;
            MARin   = 1'b1;
        end
        S_LD6: begin
            Read  = 1'b1;
            MDRin = 1'b1;
        end
        S_LD7: begin
            MDRout = 1'b1;
            Gra    = 1'b1;
            Rin    = 16'hFFFF;
        end

        S_ST3: begin
            Grb   = 1'b1;
            BAout = 1'b1;
            Yin   = 1'b1;
        end
        S_ST4: begin
            Cout  = 1'b1;
            ALUop = 5'b00000;
            Zin   = 1'b1;
        end
        S_ST5: begin
            Zlowout = 1'b1;
            MARin   = 1'b1;
        end
        S_ST6: begin
            Gra    = 1'b1;
            Rout   = 16'hFFFF;
            MDRin  = 1'b1;
        end
        S_ST7: begin
            Write = 1'b1;
        end

        S_R3: begin
            Grb  = 1'b1;
            Rout = 16'hFFFF;
            Yin  = 1'b1;
        end
        S_R4: begin
            Grc   = 1'b1;
            Rout  = 16'hFFFF;
            ALUop = opcode;
            Zin   = 1'b1;
        end
        S_R5: begin
            Zlowout = 1'b1;
            Gra     = 1'b1;
            Rin     = 16'hFFFF;
        end

        S_I3: begin
            Grb  = 1'b1;
            Rout = 16'hFFFF;
            Yin  = 1'b1;
        end
        S_I4: begin
            Cout = 1'b1;
            Zin  = 1'b1;
            case (opcode)
                5'b01001: ALUop = 5'b00000;
                5'b01010: ALUop = 5'b00010;
                5'b01011: ALUop = 5'b00011;
                default:  ALUop = 5'b00000;
            endcase
        end
        S_I5: begin
            Zlowout = 1'b1;
            Gra     = 1'b1;
            Rin     = 16'hFFFF;
        end

        S_U3: begin
            Grb  = 1'b1;
            Rout = 16'hFFFF;
            Yin  = 1'b1;
        end
        S_U4: begin
            ALUop = opcode;
            Zin   = 1'b1;
        end
        S_U5: begin
            Zlowout = 1'b1;
            Gra     = 1'b1;
            Rin     = 16'hFFFF;
        end

        S_MULDIV3: begin
            Gra  = 1'b1;
            Rout = 16'hFFFF;
            Yin  = 1'b1;
        end
        S_MULDIV4: begin
            Grb   = 1'b1;
            Rout  = 16'hFFFF;
            ALUop = opcode;
            Zin   = 1'b1;
        end
        S_MULDIV5: begin
            Zlowout = 1'b1;
            LOin    = 1'b1;
        end
        S_MULDIV6: begin
            Zhighout = 1'b1;
            HIin     = 1'b1;
        end

        S_MFHI3: begin
            HIout = 1'b1;
            Gra   = 1'b1;
            Rin   = 16'hFFFF;
        end
        S_MFFLO3: begin
            LOout = 1'b1;
            Gra   = 1'b1;
            Rin   = 16'hFFFF;
        end

        S_BRANCH3: begin
            Gra   = 1'b1;
            Rout  = 16'hFFFF;
            CONin = 1'b1;
        end
        S_BRANCH4: begin
            PCout = 1'b1;
            Yin   = 1'b1;
        end
        S_BRANCH5: begin
            Cout  = 1'b1;
            ALUop = 5'b00000;
            Zin   = 1'b1;
        end
        S_BRANCH6: begin
            if (CON_FF) begin
                Zlowout = 1'b1;
                PCin    = 1'b1;
            end
        end

        S_JR3: begin
            Gra  = 1'b1;
            Rout = 16'hFFFF;
            PCin = 1'b1;
        end

        S_JAL3: begin
            PCout = 1'b1;
            Rin   = 16'h1000;
        end
        S_JAL4: begin
            Gra  = 1'b1;
            Rout = 16'hFFFF;
            PCin = 1'b1;
        end

        S_HALT: begin
            Run = 1'b0;
        end
    endcase

    if (Stop)
        Run = 1'b0;
end

endmodule
