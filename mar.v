// MAR code
// Group: 22

module MAR(
    input clear, clock, MARin,
    input [31:0] BusMuxOut,
    output wire [8:0] Address
);

reg [8:0] q;

always @(posedge clock)
    begin
        if (clear) begin
            q <= 9'b0;
        end
        else if (MARin) begin
            q <= BusMuxOut[8:0];
        end
    end

assign Address = q;

endmodule
