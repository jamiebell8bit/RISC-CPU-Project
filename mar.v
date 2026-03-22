// MAR code
// Group: 22
//
// Phase 2 version:
// MAR stores the full 32-bit value from the bus.
// The RAM only uses MAR[8:0] as its address input.

module MAR(
    input clear, clock, MARin,
    input [31:0] BusMuxOut,
    output wire [31:0] MAR
);

reg [31:0] q;

always @(posedge clock)
    begin
        if (clear) begin
            q <= 32'b0;
        end
        else if (MARin) begin
            q <= BusMuxOut;
        end
    end

assign MAR = q;

endmodule
