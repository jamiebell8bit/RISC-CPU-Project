`timescale 1ns/10ps

module datapath_shr_tb;

    // Clock + state
    reg Clock;
    reg [3:0] Present_state;

    // Datapath controls 
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

    // State encoding
    localparam Default    = 4'd0,
               LoadR0a    = 4'd1,
               LoadR0b    = 4'd2,
               LoadR4a    = 4'd3,
               LoadR4b    = 4'd4,
               T0         = 4'd5,
               T1         = 4'd6,
               T2         = 4'd7,
               T3         = 4'd8,
               T4         = 4'd9,
               T5         = 4'd10;

    // Clock generator
    initial begin
        Clock = 1'b0;
        forever #10 Clock = ~Clock;
    end

    // State progression
    always @(posedge Clock) begin
        case (Present_state)
            Default: Present_state <= LoadR0a;
            LoadR0a: Present_state <= LoadR0b;
            LoadR0b: Present_state <= LoadR4a;
            LoadR4a: Present_state <= LoadR4b;
            LoadR4b: Present_state <= T0;
            T0:      Present_state <= T1;
            T1:      Present_state <= T2;
            T2:      Present_state <= T3;
            T3:      Present_state <= T4;
            T4:      Present_state <= T5;
            T5:      Present_state <= T0;   // loop
            default: Present_state <= Default;
        endcase
    end

    // Control logic
    always @(*) begin
        // Defaults
        Rin = 16'h0000;
        Rout = 16'h0000;

        PCin=0; PCout=0;
        IRin=0; IRout=0;
        MARin=0;
        MDRin=0; MDRout=0;
        HIin=0; HIout=0;
        LOin=0; LOout=0;
        Yin=0;
        Zin=0;
        Zhighout=0; Zlowout=0;

        IncPC=0;
        Read=0;

        // SHR opcode
        opcode = 5'd4;

        Mdatain = 32'h00000000;

        case (Present_state)

            
            // Load R0 = 0x000000F0
           
            LoadR0a: begin
                Mdatain = 32'h000000F0;
                Read    = 1'b1;
                MDRin   = 1'b1;      // MDR <- Mdatain
            end
            LoadR0b: begin
                MDRout = 1'b1;       // Bus <- MDR
                Rin[0] = 1'b1;       // R0 <- Bus
            end

            
            // Load R4 = 0x00000004 using MDR
            
            LoadR4a: begin
                Mdatain = 32'h00000004;
                Read    = 1'b1;
                MDRin   = 1'b1;      // MDR <- Mdatain
            end
            LoadR4b: begin
                MDRout = 1'b1;       // Bus <- MDR
                Rin[4] = 1'b1;       // R4 <- Bus
            end

           
            T0: begin
                PCout = 1'b1;
                MARin = 1'b1;
                IncPC = 1'b1;
                Zin   = 1'b1;        // Z <- PC+1 
            end

            T1: begin
                Zlowout = 1'b1;
                PCin    = 1'b1;      // PC <- Zlow

                Read    = 1'b1;
                MDRin   = 1'b1;
                Mdatain = 32'h00000000;
            end

            T2: begin
                MDRout = 1'b1;
                IRin   = 1'b1;       // IR <- MDR
            end

           
            T3: begin
                Rout[0] = 1'b1;      // Bus <- R0
                Yin     = 1'b1;      // Y <- Bus
            end

            T4: begin
                Rout[4] = 1'b1;      // Bus <- R4 (shift count)
                opcode  = 5'd4;      // SHR
                Zin     = 1'b1;      // Z <- SHR(Y, Bus[4:0])
            end

            T5: begin
                Zlowout = 1'b1;      // Bus <- Zlow
                Rin[7]  = 1'b1;      // R7 <- Bus
            end

        endcase
    end

    // Init
    initial begin
        Present_state = Default;
    end

endmodule