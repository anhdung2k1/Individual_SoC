module Memory
#(
	 parameter DATA_WIDTH = 32,
	 parameter ADDRESS_WIDTH = 4
) (
	 input iClk,
	 input iReset_n,
	 input iChipSelect_n,
	 input iRead_n,
	 input iWrite_n,
	 input [ADDRESS_WIDTH - 1 : 0] iAddress,
	 input [DATA_WIDTH - 1 : 0] iData,
	 output [DATA_WIDTH - 1 : 0] oData
);
	 reg [DATA_WIDTH - 1 : 0] mem [2**ADDRESS_WIDTH - 1 : 0];
	 reg [ADDRESS_WIDTH - 1 : 0] address_reg;

always@(posedge iClk)
	begin
		if (~iChipSelect_n & ~iWrite_n)
			begin
				mem[iAddress] <= iData;
			end
		if(~iChipSelect_n & ~iRead_n)
			begin
				address_reg <= iAddress;
			end
		end
		assign oData = mem[address_reg];
endmodule
