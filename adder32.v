// 32-bit Adder/Subtractor (NO + / -)
// Group: 22

module adder32 (
    input  [31:0] A,
    input  [31:0] B,
    input         SUB,        // 0 = ADD, 1 = SUB  (A + B or A - B)
    output [31:0] S,
    output        Cout
);

wire [31:0] Bx;
wire [32:0] C;

assign Bx   = B ^ {32{SUB}};   // if SUB=1 -> invert B
assign C[0] = SUB;             // carry-in = 1 for subtraction (two's complement)

genvar i;
generate
    for (i = 0; i < 32; i = i + 1) begin : FA
        assign S[i]   = A[i] ^ Bx[i] ^ C[i];
        assign C[i+1] = (A[i] & Bx[i]) | (A[i] & C[i]) | (Bx[i] & C[i]);
    end
endgenerate

assign Cout = C[32];

endmodule