// In.Port code
// Group: 22
//
// Input port register for Phase 2.
// The external input is sampled on the rising edge of the clock.
// The stored value can then be placed on the bus using InPortout.

module InPort(
    input clear, clock,
    input [31:0] ExternalInput,
    output wire [31:0] BusMuxIn_InPort
);

reg [31:0] q;

always @(posedge clock)
    begin
        if (clear) begin
            q <= 32'b0;
        end
        else begin
            q <= ExternalInput;
        end
    end

assign BusMuxIn_InPort = q;

endmodule
