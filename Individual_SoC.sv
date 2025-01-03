module Individual_SoC(
	input CLOCK_50,
	input [0:0] KEY,
	input [15:0] SW,
	output [6:0] HEX0,
	output [6:0] HEX1,
	output [6:0] HEX2,
	output [6:0] HEX3
);
system Nios_system(
	.clk_clk				(CLOCK_50),
	.reset_reset_n		(KEY[0]),
	.hexdecoder_0_conduit_end_export		({25'd0, HEX0}),
	.hexdecoder_1_conduit_end_export		({25'd0, HEX1}),
	.hexdecoder_2_conduit_end_export		({25'd0, HEX2}),
	.hexdecoder_3_conduit_end_export		({25'd0, HEX3}),
	.switches_0_conduit_end_export		(SW)
);
endmodule