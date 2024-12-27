	component system is
		port (
			clk_clk                         : in    std_logic                     := 'X';             -- clk
			hexdecoder_0_conduit_end_export : out   std_logic_vector(31 downto 0);                    -- export
			hexdecoder_1_conduit_end_export : out   std_logic_vector(31 downto 0);                    -- export
			hexdecoder_2_conduit_end_export : out   std_logic_vector(31 downto 0);                    -- export
			hexdecoder_3_conduit_end_export : out   std_logic_vector(31 downto 0);                    -- export
			reset_reset_n                   : in    std_logic                     := 'X';             -- reset_n
			switches_0_conduit_end_export   : inout std_logic_vector(31 downto 0) := (others => 'X')  -- export
		);
	end component system;

	u0 : component system
		port map (
			clk_clk                         => CONNECTED_TO_clk_clk,                         --                      clk.clk
			hexdecoder_0_conduit_end_export => CONNECTED_TO_hexdecoder_0_conduit_end_export, -- hexdecoder_0_conduit_end.export
			hexdecoder_1_conduit_end_export => CONNECTED_TO_hexdecoder_1_conduit_end_export, -- hexdecoder_1_conduit_end.export
			hexdecoder_2_conduit_end_export => CONNECTED_TO_hexdecoder_2_conduit_end_export, -- hexdecoder_2_conduit_end.export
			hexdecoder_3_conduit_end_export => CONNECTED_TO_hexdecoder_3_conduit_end_export, -- hexdecoder_3_conduit_end.export
			reset_reset_n                   => CONNECTED_TO_reset_reset_n,                   --                    reset.reset_n
			switches_0_conduit_end_export   => CONNECTED_TO_switches_0_conduit_end_export    --   switches_0_conduit_end.export
		);

