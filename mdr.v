//MDR code
//Group: 22

module MDR(
	input clear, clock, MDRin, read,
	input [31:0] BusMuxOut,
	input [31:0] Mdatain, 
	output wire [31:0] MDR
); 
	
reg [31:0]q;
always @ (posedge clock)
		begin 
			if (clear) begin
				q <= 32'b0;
			end
			else if (MDRin) begin
				q <= read ? Mdatain : BusMuxOut;
			end
		end
	assign MDR = q[31:0];
endmodule
