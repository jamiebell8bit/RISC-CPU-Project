// ALU code
// Group: 22

module alu (
    input  [31:0] A,
    input  [31:0] B,
    input  [4:0]  ALUop,
    output reg [63:0] Z
);

    
    // ADD / SUB 
    // MiniSRC opcodes ADD=00000, SUB=00001
   
    wire isSUB = (ALUop == 5'b00001);
    wire [31:0] addsub_S;
    wire addsub_Cout;

    adder32 U_ADD_SUB (
        .A(A),
        .B(B),
        .SUB(isSUB),
        .S(addsub_S),
        .Cout(addsub_Cout)
    );

    // NEG: Z = -A  using adder32)
    // MiniSRC opcode NEG=01110
    wire [31:0] neg_S;
    wire neg_Cout;

    adder32 U_NEG (
        .A(32'b0),
        .B(A),
        .SUB(1'b1),
        .S(neg_S),
        .Cout(neg_Cout)
    );

    
    // MUL / DIV modules
    
    wire [63:0] mul_Z;
    wire [63:0] div_Z;

    mul U_MUL (
        .A(A),
        .B(B),
        .P(mul_Z)
    );

    div U_DIV (
        .A(A),
        .B(B),
        .QR(div_Z)  
    );
 
    // Shifts / rotates
    
    wire [4:0] shamt = B[4:0];
    wire [31:0] rol  = (A << shamt) | (A >> (5'd32 - shamt));
    wire [31:0] ror  = (A >> shamt) | (A << (5'd32 - shamt));

   
    // ALU operation select (MiniSRC opcodes)
    //  add  00000
    //  sub  00001
    //  and  00010
    //  or   00011
    //  shr  00100
    //  shra 00101
    //  shl  00110
    //  ror  00111
    //  rol  01000
    //  div  01100 
    //  mul  01101  
    //  neg  01110
    //  not  01111
   
    always @(*) begin
        case (ALUop)
            5'b00000: Z = {32'b0, addsub_S};                // ADD
            5'b00001: Z = {32'b0, addsub_S};                // SUB
            5'b00010: Z = {32'b0, (A & B)};                 // AND
            5'b00011: Z = {32'b0, (A | B)};                 // OR

            5'b00100: Z = {32'b0, (A >> shamt)};            // SHR
            5'b00101: Z = {32'b0, ($signed(A) >>> shamt)};  // SHRA
            5'b00110: Z = {32'b0, (A << shamt)};            // SHL
            5'b00111: Z = {32'b0, ror};                     // ROR
            5'b01000: Z = {32'b0, rol};                     // ROL

            5'b01100: Z = div_Z;                            // DIV -> {rem, quo}
            5'b01101: Z = mul_Z;                            // MUL
            5'b01110: Z = {32'b0, neg_S};                   // NEG
            5'b01111: Z = {32'b0, (~A)};                    // NOT
            default:  Z = 64'b0;
        endcase
    end

endmodule