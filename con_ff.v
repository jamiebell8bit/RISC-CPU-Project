// Con FF code
// Group: 22

module con_ff(
    input [31:0] Bus,
    input [31:0] IR,
    output reg CON_out
);

    wire [1:0] cond = IR[20:19];

    always @(*) begin
        case(cond)
            2'b00: CON_out = (Bus == 0);          // brzr
            2'b01: CON_out = (Bus != 0);          // brnz
            2'b10: CON_out = (Bus[31] == 0 && Bus != 0); // brpl
            2'b11: CON_out = (Bus[31] == 1);      // brmi
        endcase
    end

endmodule