// DIV code (restoring division), returns {remainder, quotient}
// Group: 22

module div(
    input  [31:0] A,
    input  [31:0] B,
    output [63:0] QR
);

    // divide-by-zero protection
    wire div0 = (B == 32'b0);

    wire signA = A[31];
    wire signB = B[31];

    // absolute values (two's complement) - allowed inside DIV algorithm module
    wire [31:0] Au = signA ? (~A + 32'd1) : A;
    wire [31:0] Bu = signB ? (~B + 32'd1) : B;

    reg [31:0] quotient;
    reg [31:0] remainder;
    reg [32:0] rem_ext;   // extra bit to shift cleanly
    integer i;

    always @(*) begin
        quotient  = 32'b0;
        remainder = 32'b0;
        rem_ext   = 33'b0;

        if (div0) begin
            quotient  = 32'b0;
            remainder = 32'b0;
        end
        else begin
            // restoring division
            for (i = 31; i >= 0; i = i - 1) begin
                rem_ext = {rem_ext[31:0], Au[i]};  // shift left and bring down next bit

                if (rem_ext[31:0] >= Bu) begin
                    rem_ext[31:0] = rem_ext[31:0] - Bu;
                    quotient[i] = 1'b1;
                end
            end
            remainder = rem_ext[31:0];
        end
    end

    // sign fix:
    // quotient sign = A ^ B
    // remainder sign follows A
    wire [31:0] quotient_signed  = (signA ^ signB) ? (~quotient + 32'd1) : quotient;
    wire [31:0] remainder_signed = (signA) ? (~remainder + 32'd1) : remainder;

    //  Euclidean remainder fix
    //  If remainder is negative:
   
    wire rem_neg = ($signed(remainder_signed) < 0);

    wire [31:0] remainder_euclid =
        rem_neg ? (remainder_signed + Bu) : remainder_signed;

    wire [31:0] quotient_euclid  =
        rem_neg
            ? (signB ? (quotient_signed + 32'd1)   // subtract(-1)
                     : (quotient_signed - 32'd1))  // subtract(+1)
            : quotient_signed;

    assign QR = div0 ? 64'b0 : {remainder_euclid, quotient_euclid};

endmodule