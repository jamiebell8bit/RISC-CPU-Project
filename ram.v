// RAM code
// Group: 22

module RAM(
    input clock,
    input Read,
    input Write,
    input [8:0] Address,
    input [31:0] DataIn,
    output reg [31:0] DataOut,
    output [31:0] Mem89,
    output [31:0] MemA3
);

reg [31:0] mem [0:511];
integer i;

initial begin
    for (i = 0; i < 512; i = i + 1)
        mem[i] = 32'b0;

    mem[9'h089] = 32'h000000A7;
    mem[9'h0A3] = 32'h00000068;

    mem[9'h000] = 32'h8A800043;
    mem[9'h001] = 32'h8AA80006;
    mem[9'h002] = 32'h82000089;
    mem[9'h003] = 32'h8A200004;
    mem[9'h004] = 32'h8027FFF8;
    mem[9'h005] = 32'h89000004;
    mem[9'h006] = 32'h8A800087;
    mem[9'h007] = 32'hAA980003;
    mem[9'h008] = 32'h8AA80005;
    mem[9'h009] = 32'h80AFFFFD;
    mem[9'h00A] = 32'hD0000000;
    mem[9'h00B] = 32'hA8900002;
    mem[9'h00C] = 32'h89A80007;
    mem[9'h00D] = 32'h8B9FFFFC;
    mem[9'h00E] = 32'h03A90000;
    mem[9'h00F] = 32'h48880003;
    mem[9'h010] = 32'h70880000;
    mem[9'h011] = 32'h78880000;
    mem[9'h012] = 32'h5088000F;
    mem[9'h013] = 32'h3A010000;
    mem[9'h014] = 32'h58A00005;
    mem[9'h015] = 32'h2A090000;
    mem[9'h016] = 32'h22A90000;
    mem[9'h017] = 32'h928000A3;
    mem[9'h018] = 32'h42810000;
    mem[9'h019] = 32'h1B900000;
    mem[9'h01A] = 32'h12280000;
    mem[9'h01B] = 32'h93A00089;
    mem[9'h01C] = 32'h082B8000;
    mem[9'h01D] = 32'h32290000;
    mem[9'h01E] = 32'h8B800007;
    mem[9'h01F] = 32'h89800019;
    mem[9'h020] = 32'h69B80000;
    mem[9'h021] = 32'hC0800000;
    mem[9'h022] = 32'hCB000000;
    mem[9'h023] = 32'h61B80000;
    mem[9'h024] = 32'h8C380002;
    mem[9'h025] = 32'h8C9FFFFC;
    mem[9'h026] = 32'h8D300003;
    mem[9'h027] = 32'h8D880005;
    mem[9'h028] = 32'h9D000000;
    mem[9'h029] = 32'hD8000000;

    mem[9'h0B2] = 32'h07450000;
    mem[9'h0B3] = 32'h0ECD8000;
    mem[9'h0B4] = 32'h0F768000;
    mem[9'h0B5] = 32'hA6000000;
end

always @(posedge clock) begin
    if (Write)
        mem[Address] <= DataIn;
end

always @(*) begin
    if (Read)
        DataOut = mem[Address];
    else
        DataOut = 32'b0;
end

assign Mem89 = mem[9'h089];
assign MemA3 = mem[9'h0A3];

endmodule
