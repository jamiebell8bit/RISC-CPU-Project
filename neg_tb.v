`timescale 1ns/10ps

// TB Code
// Group: 22

module datapath_neg_tb;

    reg Clock;
    reg [3:0] Present_state;

    reg [15:0] Rin, Rout;

    reg PCin, PCout;
    reg IRin, IRout;
    reg MARin;
    reg MDRin, MDRout;
    reg HIin, HIout;
    reg LOin, LOout;
    reg Yin;
    reg Zin;
    reg Zhighout, Zlowout;

    reg IncPC;
    reg Read;
    reg [4:0] opcode;

    reg [31:0] Mdatain;

    // DUT
    datapath DUT (
        .Rin(Rin),
        .Rout(Rout),

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

        .IncPC(IncPC),
        .Read(Read),
        .opcode(opcode),

        .Clock(Clock),
        .Mdatain(Mdatain)
    );

    // States
    localparam Default    = 4'd0,
               Reg_load1a = 4'd1,
               Reg_load1b = 4'd2,
               T0         = 4'd3,
               T1         = 4'd4,
               T2         = 4'd5,
               T3         = 4'd6,
               T4         = 4'd7,
               T5         = 4'd8;

    always @(posedge Clock) begin
        case (Present_state)
            Default:    Present_state <= Reg_load1a;
            Reg_load1a: Present_state <= Reg_load1b;
            Reg_load1b: Present_state <= T0;
            T0:         Present_state <= T1;
            T1:         Present_state <= T2;
            T2:         Present_state <= T3;
            T3:         Present_state <= T4;
            T4:         Present_state <= T5;
            T5:         Present_state <= T0;
            default:    Present_state <= Default;
        endcase
    end

    always @(*) begin
        Rin = 16'h0000;  Rout = 16'h0000;

        PCin=0; PCout=0;
        IRin=0; IRout=0;
        MARin=0;
        MDRin=0; MDRout=0;
        HIin=0; HIout=0;
        LOin=0; LOout=0;
        Yin=0; Zin=0;
        Zhighout=0; Zlowout=0;

        IncPC=0;
        Read=0;
        opcode = 5'b00000;
        Mdatain = 32'h00000000;

        case (Present_state)
            Reg_load1a: begin
                Mdatain = 32'h0000000A;
                Read    = 1'b1;
                MDRin   = 1'b1;
            end
            Reg_load1b: begin
                MDRout  = 1'b1;
                Rin[7]  = 1'b1;
            end

            T0: begin
                PCout = 1'b1;
                MARin = 1'b1;
                IncPC = 1'b1;
                Zin   = 1'b1;
            end
            T1: begin
                Zlowout = 1'b1;
                PCin    = 1'b1;
                Read    = 1'b1;
                MDRin   = 1'b1;
                Mdatain = 32'h00000000;
            end
            T2: begin
                MDRout = 1'b1;
                IRin   = 1'b1;
            end

            T3: begin
                Rout[7] = 1'b1;
                Yin         = 1'b1;
            end

            T4: begin
                opcode = 5'b01110;
                Zin    = 1'b1;
            end

            T5: begin
                Zlowout = 1'b1;
                Rin[4] = 1'b1;
            end
        endcase
    end

    initial begin
        Clock = 1'b0;
        forever #10 Clock = ~Clock;
    end

    initial begin
        Present_state = Default;
    end

endmodule
