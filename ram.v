// RAM (512 x 32) code
// Group: 22
//
// Phase 2 memory block for the Mini SRC
// Address comes from MAR[8:0]
// Write happens on the rising edge of the clock
// Read is combinational for easier functional simulation (ram updates when address changes)

module RAM(
    input clock,
    input Read,
    input Write,
    input [8:0] Address,
    input [31:0] DataIn,
    output reg [31:0] DataOut
);

reg [31:0] mem [0:511];
integer i;

initial begin
    for (i = 0; i < 512; i = i + 1) begin
        mem[i] = 32'b0;
    end

    // Example preload values from the Phase 2 handout.
    // These can be replaced later with a memory init file.
    mem[9'h065] = 32'h00000084;
    mem[9'h0C9] = 32'h0000002B;
    mem[9'h01F] = 32'h000000D4;
    mem[9'h082] = 32'h000000A7;

    // Optional alternative:
    // $readmemh("memory_init.hex", mem);
end

always @(posedge clock) begin
    if (Write) begin
        mem[Address] <= DataIn;
    end
end

always @(*) begin
    if (Read) begin
        DataOut = mem[Address];
    end
    else begin
        DataOut = 32'b0;
    end
end

endmodule
