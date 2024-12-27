
module system (
	clk_clk,
	hexdecoder_0_conduit_end_export,
	hexdecoder_1_conduit_end_export,
	hexdecoder_2_conduit_end_export,
	hexdecoder_3_conduit_end_export,
	reset_reset_n,
	switches_0_conduit_end_export);	

	input		clk_clk;
	output	[31:0]	hexdecoder_0_conduit_end_export;
	output	[31:0]	hexdecoder_1_conduit_end_export;
	output	[31:0]	hexdecoder_2_conduit_end_export;
	output	[31:0]	hexdecoder_3_conduit_end_export;
	input		reset_reset_n;
	inout	[31:0]	switches_0_conduit_end_export;
endmodule
