// IR code
// Group: 22

module IR(
    input clear, clock, IRin,
    input [31:0] BusMuxOut,
    output wire [31:0] IR
);

    reg [31:0] q;

    always @(posedge clock)
        begin
            if (clear) begin
                q <= 32'b0;
            end
            else if (IRin) begin
                q <= BusMuxOut;
            end
        end

    assign IR = q[31:0];

endmodule
