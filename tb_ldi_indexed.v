`timescale 1ns/10ps

module tb_ldi_indexed;
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
        .PCout(PCout), .PCin(PCin), .IRin(IRin), .IRout(IRout),
        .MARin(MARin), .MDRin(MDRin), .MDRout(MDRout),
        .HIin(HIin), .HIout(HIout), .LOin(LOin), .LOout(LOout),
        .Yin(Yin), .Zin(Zin), .Zhighout(Zhighout), .Zlowout(Zlowout),
        .InPortout(InPortout), .OutPortin(OutPortin), .Cout(Cout),
        .IncPC(IncPC), .Read(Read), .Write(Write), .opcode(opcode),
        .Clock(Clock), .Mdatain(Mdatain), .InPortData(InPortData),
        .OutPortData(OutPortData), .MARData(MARData), .RAMDataOut(RAMDataOut)
    );

    initial begin
        Clock = 1'b0;
        forever #10 Clock = ~Clock;
    end

    task clear_controls;
    begin
        Rin = 16'h0000; Rout = 16'h0000;
        Gra = 1'b0; Grb = 1'b0; Grc = 1'b0;
        BAout = 1'b0; CONin = 1'b0;
        PCout = 1'b0; PCin = 1'b0; IRin = 1'b0; IRout = 1'b0;
        MARin = 1'b0; MDRin = 1'b0; MDRout = 1'b0;
        HIin = 1'b0; HIout = 1'b0; LOin = 1'b0; LOout = 1'b0;
        Yin = 1'b0; Zin = 1'b0; Zhighout = 1'b0; Zlowout = 1'b0;
        InPortout = 1'b0; OutPortin = 1'b0; Cout = 1'b0;
        IncPC = 1'b0; Read = 1'b0; Write = 1'b0;
        opcode = 5'b00000;
        Mdatain = 32'h00000000;
        InPortData = 32'h00000000;
    end
    endtask

    task tick;
    begin
        @(posedge Clock);
        #1;
        clear_controls();
    end
    endtask

    task zero_state;
        integer i;
    begin
        DUT.PC.q  = 32'h00000000;
        DUT.IR0.q = 32'h00000000;
        DUT.MAR0.q = 32'h00000000;
        DUT.MDR0.q = 32'h00000000;
        DUT.HI.q = 32'h00000000;
        DUT.LO.q = 32'h00000000;
        DUT.Y.q = 32'h00000000;
        DUT.Z.q = 64'h0000000000000000;
        DUT.CON = 1'b0;
        DUT.R0.q = 32'h00000000; DUT.R1.q = 32'h00000000; DUT.R2.q = 32'h00000000; DUT.R3.q = 32'h00000000;
        DUT.R4.q = 32'h00000000; DUT.R5.q = 32'h00000000; DUT.R6.q = 32'h00000000; DUT.R7.q = 32'h00000000;
        DUT.R8.q = 32'h00000000; DUT.R9.q = 32'h00000000; DUT.R10.q = 32'h00000000; DUT.R11.q = 32'h00000000;
        DUT.R12.q = 32'h00000000; DUT.R13.q = 32'h00000000; DUT.R14.q = 32'h00000000; DUT.R15.q = 32'h00000000;
        for (i = 0; i < 512; i = i + 1) DUT.RAM0.mem[i] = 32'h00000000;
    end
    endtask

    task fetch_instr;
        input [31:0] instr;
    begin
        DUT.RAM0.mem[DUT.PC.q[8:0]] = instr;

        // T0
        PCout = 1'b1; MARin = 1'b1; IncPC = 1'b1; Zin = 1'b1;
        tick();

        // T1
        Zlowout = 1'b1; PCin = 1'b1; Read = 1'b1; MDRin = 1'b1;
        tick();

        // T2
        MDRout = 1'b1; IRin = 1'b1;
        tick();
    end
    endtask

    initial begin
        clear_controls();
        #25;
        zero_state();

        // Case: ldi R0, 0x72(R2) with R2=0x57 -> 0xC9
        DUT.R2.q = 32'h00000057;
        DUT.PC.q = 32'h00000000;
        fetch_instr({5'b10001, 4'd0, 4'd2, 19'h00072});

        // T3
        Grb = 1'b1; BAout = 1'b1; Yin = 1'b1;
        tick();

        // T4
        Cout = 1'b1; opcode = 5'b00000; Zin = 1'b1;
        tick();

        // T5
        Gra = 1'b1; Zlowout = 1'b1; Rin = 16'h0001;
        tick();

        $display("ldi_indexed: R0=%h expected 000000C9", DUT.R0.q);
        if (DUT.R0.q !== 32'h000000C9) $display("FAIL: ldi indexed");
        else $display("PASS: ldi indexed");
        #20; $stop;
    end
endmodule
