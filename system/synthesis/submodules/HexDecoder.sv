module HexDecoder(
    input iClk,
    input iReset_n,
    input iChip_select_n,
    input iWrite_n,
    input [31:0] iData,
    output reg [31:0] HEX
);

always @(posedge iClk or negedge iReset_n)
begin
    if (~iReset_n) 
	 begin
		  HEX <= 32'd0;
	 end 
    else 
	 begin
		if (~iChip_select_n & ~iWrite_n) 
			begin
			  // HEX0: hiển thị giá trị từ 0 đến 9
			  case (iData[3:0])
					4'h0: HEX <= {25'd0,7'b1000000}; // 0 
					4'h1: HEX <= {25'd0,7'b1111001}; // 1
					4'h2: HEX <= {25'd0,7'b0100100}; // 2
					4'h3: HEX <= {25'd0,7'b0110000}; // 3
					4'h4: HEX <= {25'd0,7'b0011001}; // 4
					4'h5: HEX <= {25'd0,7'b0010010}; // 5
					4'h6: HEX <= {25'd0,7'b0000010}; // 6
					4'h7: HEX <= {25'd0,7'b0111000}; // 7
					4'h8: HEX <= {25'd0,7'b0000000}; // 8
					4'h9: HEX <= {25'd0,7'b0010000}; // 9
					4'hA: HEX <= {25'd0,7'b0001000}; // A
					4'hB: HEX <= {25'd0,7'b0000011}; // B
					4'hC: HEX <= {25'd0,7'b1000110}; // C
					4'hD: HEX <= {25'd0,7'b0100001}; // D
					4'hE: HEX <= {25'd0,7'b0000110}; // E
					4'hF: HEX <= {25'd0,7'b0001110}; // F
					default: HEX <={25'd0,7'b0000000}; // Giá trị mặc định
			  endcase
		 end
	end
end
endmodule