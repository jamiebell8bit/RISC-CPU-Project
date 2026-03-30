`timescale 1ns/10ps

module tb_in_out;

    reg [15:0] Rin, Rout;
    reg Gra, Grb, Grc;
    reg BAout, CONin;
    wire CON;

    reg PCout, PCin, IRin, IRout, MARin, MDRin, MDRout;
    reg HIin, HIout, LOin, LOout, Yin, Zin, Zhighout, Zlowout;
    reg InPortout, OutPortin, Cout;
    reg IncPC, Read, Write;
    reg [4:0] opcode;
    reg Clock;

    reg [31:0] Mdatain;
    reg [31:0] InPortData;

    wire [31:0] OutPortData;
    wire [31:0] MARData;
    wire [31:0] RAMDataOut;

    datapath DUT (
        .Rin(Rin), .Rout(Rout),
        .Gra(Gra), .Grb(Grb), .Grc(Grc),
        .BAout(BAout), .CONin(CONin), .CON(CON),

        .PCout(PCout), .PCin(PCin),
        .IRin(IRin), .IRout(IRout),
        .MARin(MARin),
        .MDRin(MDRin), .MDRout(MDRout),

        .HIin(HIin), .HIout(HIout),
        .LOin(LOin), .LOout(LOout),
        .Yin(Yin), .Zin(Zin),
        .Zhighout(Zhighout), .Zlowout(Zlowout),

        .InPortout(InPortout), .OutPortin(OutPortin),
        .Cout(Cout),
        .IncPC(IncPC), .Read(Read), .Write(Write),
        .opcode(opcode), .Clock(Clock),

        .Mdatain(Mdatain),
        .InPortData(InPortData),

        .OutPortData(OutPortData),
        .MARData(MARData),
        .RAMDataOut(RAMDataOut)
    );

    // Clock
    initial begin
        Clock = 0;
        forever #10 Clock = ~Clock;
    end

    // Only clear control signals here
    task clear_controls;
    begin
        Rin = 16'h0000; Rout = 16'h0000;
        Gra = 0; Grb = 0; Grc = 0;
        BAout = 0; CONin = 0;

        PCout = 0; PCin = 0; IRin = 0; IRout = 0;
        MARin = 0; MDRin = 0; MDRout = 0;
        HIin = 0; HIout = 0; LOin = 0; LOout = 0;
        Yin = 0; Zin = 0; Zhighout = 0; Zlowout = 0;

        InPortout = 0; OutPortin = 0; Cout = 0;
        IncPC = 0; Read = 0; Write = 0;
        opcode = 5'b00000;

        Mdatain = 32'h00000000;
        // DO NOT clear InPortData here
    end
    endtask

    task zero_state;
    begin
        clear_controls();
    end
    endtask

    task tick;
    begin
        #20;
        clear_controls();
    end
    endtask

    task fetch_instr;
        input [31:0] instr;
    begin
        // T0
        PCout = 1'b1;
        MARin = 1'b1;
        IncPC = 1'b1;
        Zin = 1'b1;
        tick();

        // T1
        Zlowout = 1'b1;
        PCin = 1'b1;
        Read = 1'b1;
        MDRin = 1'b1;
        Mdatain = instr;
        tick();

        // T2
        MDRout = 1'b1;
        IRin = 1'b1;
        tick();
    end
    endtask

    initial begin
        clear_controls();
        #25;
        zero_state();

        // -------------------------
        // out R7
        // -------------------------
        DUT.R7.q = 32'hCAFEBABE;
        DUT.PC.q = 32'h00000000;

        // opcode 10111 = out, Ra = 7
        fetch_instr({5'b10111, 4'd7, 23'd0});

        // T3: Gra, Rout, OutPortin
        Gra = 1'b1;
        Rout = 16'h0001;
        OutPortin = 1'b1;
        tick();

        $display("out: OutPortData=%h", OutPortData);

        // -------------------------
        // in R5
        // -------------------------
        zero_state();
        DUT.PC.q = 32'h00000000;

        // opcode 10110 = in, Ra = 5
        fetch_instr({5'b10110, 4'd5, 23'd0});

        // Give the clocked InPort one cycle to latch the external input
        InPortData = 32'h0BADF00D;
        tick();

        // Keep input stable while gating InPort onto bus and loading R5
        InPortData = 32'h0BADF00D;
        InPortout = 1'b1;
        Gra = 1'b1;
        Rin = 16'h0001;
        tick();

        $display("in: R5=%h", DUT.R5.q);

        #20;
        $stop;
    end

endmodule