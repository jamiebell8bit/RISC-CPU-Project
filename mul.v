// 32x32 -> 64 Multiplier (Radix-4 Booth)
// Group: 22

`timescale 1ns/10ps
module mul(A, B, P);

    input  [31:0] A;
    input  [31:0] B;
    output [63:0] P;

    reg [65:0] a_ext;
    reg [34:0] b_ext;

    reg [65:0] acc;
    reg [65:0] term;
    reg [65:0] a2;
    reg [65:0] neg_a;
    reg [65:0] neg_a2;

    reg [2:0]  code;
    integer i;

    always @(*) begin
        // sign-extend A to 66 bits
        a_ext  = {{34{A[31]}}, A};

        // radix-4 Booth extension for B
        b_ext  = {B[31], B[31], B, 1'b0};

        acc    = 66'd0;

        // twos complement
        a2     = (a_ext << 1);
        neg_a  = (~a_ext) + 66'd1;
        neg_a2 = (~a2)    + 66'd1;

        for (i = 0; i < 16; i = i + 1) begin
            code = { b_ext[2*i+2], b_ext[2*i+1], b_ext[2*i] };

            case (code)
                3'b000,
                3'b111: term = 66'd0;       
                3'b001,
                3'b010: term = a_ext;       
                3'b011: term = a2;          
                3'b100: term = neg_a2;      
                3'b101,
                3'b110: term = neg_a;       
                default: term = 66'd0;
            endcase

            // shift by 2*i (radix-4)
            acc = acc + (term << (2*i));
        end
    end

    assign P = acc[63:0];

endmodule