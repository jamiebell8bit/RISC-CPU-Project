// "Phase 2 Plumbing" TB Code
// Group: 22

`timescale 1ns/10ps
module phase2_plumbing_tb;

    // Register control vectors
    reg [15:0] Rin, Rout;

    // Bus / special register controls
    reg PCout, PCin, IRin, IRout, MARin, MDRin, MDRout;
    reg HIin, HIout, LOin, LOout, Yin, Zin, Zhighout, Zlowout;

    // Phase 2 I/O controls
    reg InPortout, OutPortin, Cout;

    // Other controls
    reg IncPC, Read, Write;
    reg [4:0] opcode;

    reg Clock;
    reg [31:0] Mdatain;
    reg [31:0] InPortData;

    // Helpful observable outputs from datapath
    wire [31:0] OutPortData;
    wire [31:0] MARData;
    wire [31:0] RAMDataOut;

    parameter  Default      = 5'd0,
               LoadR1a      = 5'd1,
               LoadR1b      = 5'd2,
               MoveR1ToOut  = 5'd3,
               LoadAddrA    = 5'd4,
               LoadAddrB    = 5'd5,
               MARload      = 5'd6,
               LoadDataA    = 5'd7,
               LoadDataB    = 5'd8,
               MDRload      = 5'd9,
               RAMwrite     = 5'd10,
               RAMread      = 5'd11,
               MDRcapture   = 5'd12,
               MoveToR4     = 5'd13,
               Done         = 5'd14;

    reg [4:0] Present_state = Default;

    // ------------------------------------------------------------
    // DUT
    // ------------------------------------------------------------
    datapath DUT(
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

        .InPortout(InPortout),
        .OutPortin(OutPortin),
        .Cout(Cout),

        .IncPC(IncPC),
        .Read(Read),
        .Write(Write),
        .opcode(opcode),

        .Clock(Clock),
        .Mdatain(Mdatain),
        .InPortData(InPortData),

        .OutPortData(OutPortData),
        .MARData(MARData),
        .RAMDataOut(RAMDataOut)
    );

    // ------------------------------------------------------------
    // clock
    // ------------------------------------------------------------
    initial begin
        Clock = 0;
        forever #10 Clock = ~Clock;
    end

    // ------------------------------------------------------------
    // FSM progression
    // ------------------------------------------------------------
    always @(posedge Clock) begin
        case (Present_state)
            Default     : Present_state <= LoadR1a;
            LoadR1a     : Present_state <= LoadR1b;
            LoadR1b     : Present_state <= MoveR1ToOut;
            MoveR1ToOut : Present_state <= LoadAddrA;
            LoadAddrA   : Present_state <= LoadAddrB;
            LoadAddrB   : Present_state <= MARload;
            MARload     : Present_state <= LoadDataA;
            LoadDataA   : Present_state <= LoadDataB;
            LoadDataB   : Present_state <= MDRload;
            MDRload     : Present_state <= RAMwrite;
            RAMwrite    : Present_state <= RAMread;
            RAMread     : Present_state <= MDRcapture;
            MDRcapture  : Present_state <= MoveToR4;
            MoveToR4    : Present_state <= Done;
            Done        : Present_state <= Done;
            default     : Present_state <= Done;
        endcase
    end

    // ------------------------------------------------------------
    // stimulus
    // ------------------------------------------------------------
    always @(*) begin
        // defaults
        Rin       = 16'h0000;
        Rout      = 16'h0000;

        PCout     = 0; PCin      = 0; IRin      = 0; IRout     = 0;
        MARin     = 0; MDRin     = 0; MDRout    = 0;
        HIin      = 0; HIout     = 0; LOin      = 0; LOout     = 0;
        Yin       = 0; Zin       = 0; Zhighout  = 0; Zlowout   = 0;

        InPortout = 0; OutPortin = 0; Cout      = 0;

        IncPC     = 0; Read      = 0; Write     = 0;
        opcode    = 5'b00000;

        Mdatain   = 32'h00000000;
        InPortData = 32'h00000000;

        case (Present_state)

            // let datapath internal clear_int do its reset
            Default: begin
            end

            // ------------------------------------------------------
            // Test 1: In.Port -> R1
            // ------------------------------------------------------
            LoadR1a: begin
                InPortData = 32'hA5A5F00D;
            end

            LoadR1b: begin
                InPortData = 32'hA5A5F00D;
                InPortout  = 1'b1;
                Rin        = 16'h0002;   // R1in
            end

            // ------------------------------------------------------
            // Test 2: R1 -> Out.Port
            // ------------------------------------------------------
            MoveR1ToOut: begin
                Rout      = 16'h0002;    // R1out
                OutPortin = 1'b1;
            end

            // ------------------------------------------------------
            // Test 3: load address 0x1F into R2 using MDR path
            // ------------------------------------------------------
            LoadAddrA: begin
                Mdatain = 32'h0000001F;
                Read    = 1'b1;
                MDRin   = 1'b1;
            end

            LoadAddrB: begin
                MDRout  = 1'b1;
                Rin     = 16'h0004;      // R2in
            end

            MARload: begin
                Rout    = 16'h0004;      // R2out
                MARin   = 1'b1;
            end

            // ------------------------------------------------------
            // Test 4: load write-data 0x12345678 into R3
            // ------------------------------------------------------
            LoadDataA: begin
                Mdatain = 32'h12345678;
                Read    = 1'b1;
                MDRin   = 1'b1;
            end

            LoadDataB: begin
                MDRout  = 1'b1;
                Rin     = 16'h0008;      // R3in
            end

            // R3 -> MDR for memory write path
            MDRload: begin
                Rout    = 16'h0008;      // R3out
                MDRin   = 1'b1;
                Read    = 1'b0;
            end

            // write MDR contents into RAM at MAR address
            RAMwrite: begin
                Write   = 1'b1;
            end

            // read RAM at same address
            RAMread: begin
                Read    = 1'b1;
            end

            // capture RAM output into MDR
            MDRcapture: begin
                Read    = 1'b1;
                MDRin   = 1'b1;
            end

            // MDR -> R4
            MoveToR4: begin
                MDRout  = 1'b1;
                Rin     = 16'h0010;      // R4in
            end

            Done: begin
            end
        endcase
    end

    // ------------------------------------------------------------
    // simple textual checks
    // ------------------------------------------------------------
    always @(posedge Clock) begin
        if (Present_state == MoveR1ToOut) begin
            $display("Time %0t : OutPortData = %h", $time, OutPortData);
        end

        if (Present_state == RAMwrite) begin
            $display("Time %0t : Writing RAM[%h] <= 12345678", $time, MARData[8:0]);
        end

        if (Present_state == MDRcapture) begin
            $display("Time %0t : RAMDataOut = %h", $time, RAMDataOut);
        end
    end

    initial begin
        #400;
        $stop;
    end

endmodule