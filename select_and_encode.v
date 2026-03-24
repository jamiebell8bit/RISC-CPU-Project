// select_encode code
// Group: 22

module select_encode(
    input [31:0] IR,
    input Gra, Grb, Grc,
    input Rin, Rout,
    output reg [15:0] Rin_out,
    output reg [15:0] Rout_out
);

    wire [3:0] Ra = IR[26:23];
    wire [3:0] Rb = IR[22:19];
    wire [3:0] Rc = IR[18:15];

    reg [3:0] Sel;

    always @(*) begin
        if (Gra) Sel = Ra;
        else if (Grb) Sel = Rb;
        else if (Grc) Sel = Rc;
        else Sel = 4'b0000;
    end

    always @(*) begin
        Rin_out = 16'b0;
        Rout_out = 16'b0;

        if (Rin)
            Rin_out[Sel] = 1'b1;

        if (Rout)
            Rout_out[Sel] = 1'b1;
    end

endmodule