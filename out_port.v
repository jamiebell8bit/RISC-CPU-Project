// Out.Port code
// Group: 22
//
// Output port register for Phase 2.
// When OutPortin is asserted, the value on the bus is stored.

module OutPort(
    input clear, clock, OutPortin,
    input [31:0] BusMuxOut,
    output wire [31:0] OutPortData
);

reg [31:0] q;

always @(posedge clock)
    begin
        if (clear) begin
            q <= 32'b0;
        end
        else if (OutPortin) begin
            q <= BusMuxOut;
        end
    end

assign OutPortData = q;

endmodule
