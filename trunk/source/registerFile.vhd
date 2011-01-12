-- 32 bit version register file
-- evillase

library ieee;
use ieee.std_logic_1164.all;

entity registerFile is
	port
	(
		-- Write data input port
		wdat		:	in	std_logic_vector (31 downto 0);
		-- Select which register to write
		wsel		:	in	std_logic_vector (4 downto 0);
		-- Write Enable for entire register file
		wen			:	in	std_logic;
		-- clock, positive edge triggered
		clk			:	in	std_logic;
		-- REMEMBER: nReset-> '0' = RESET, '1' = RUN
		nReset	:	in	std_logic;
		-- Select which register to read on rdat1 
		rsel1		:	in	std_logic_vector (4 downto 0);
		-- Select which register to read on rdat2
		rsel2		:	in	std_logic_vector (4 downto 0);
		-- read port 1
		rdat1		:	out	std_logic_vector (31 downto 0);
		-- read port 2
		rdat2		:	out	std_logic_vector (31 downto 0)
		);
end registerFile;

architecture regfile_arch of registerFile is

	constant BAD1	:	std_logic_vector		:= x"BAD1BAD1";

	type REGISTER32 is array (1 to 31) of std_logic_vector(31 downto 0);
	signal reg	:	REGISTER32;				-- registers as an array

  -- enable lines... use en(x) to select
  -- individual lines for each register
	signal en		:	std_logic_vector(31 downto 0);

begin

	-- registers process
	registers : process (clk, nReset, en)
  begin
    -- one register if statement
		if (nReset = '0') then
			-- Reset here
			for s in 0 to 31 loop
				REGISTER32[s] = x"00000000";
			end loop;
    elsif (rising_edge(clk)) then
			-- Set register here
			CASE en IS
				WHEN x"00000002" THEN REGISTER32[1] = WDAT;
				WHEN x"00000004" THEN REGISTER32[2] = WDAT;
				WHEN x"00000008" THEN REGISTER32[3] = WDAT;
				WHEN x"00000010" THEN REGISTER32[4] = WDAT;
				WHEN x"00000020" THEN REGISTER32[5] = WDAT;
				WHEN x"00000040" THEN REGISTER32[6] = WDAT;
				WHEN x"00000080" THEN REGISTER32[7] = WDAT;
				WHEN x"00000100" THEN REGISTER32[8] = WDAT;
				WHEN x"00000200" THEN REGISTER32[9] = WDAT;
				WHEN x"00000400" THEN REGISTER32[10] = WDAT;
				WHEN x"00000800" THEN REGISTER32[11] = WDAT;
				WHEN x"00001000" THEN REGISTER32[12] = WDAT;
				WHEN x"00002000" THEN REGISTER32[13] = WDAT;
				WHEN x"00004000" THEN REGISTER32[14] = WDAT;
				WHEN x"00008000" THEN REGISTER32[15] = WDAT;
				WHEN x"00010000" THEN REGISTER32[16] = WDAT;
				WHEN x"00020000" THEN REGISTER32[17] = WDAT;
				WHEN x"00040000" THEN REGISTER32[18] = WDAT;
				WHEN x"00080000" THEN REGISTER32[19] = WDAT;
				WHEN x"00100000" THEN REGISTER32[20] = WDAT;
				WHEN x"00200000" THEN REGISTER32[21] = WDAT;
				WHEN x"00400000" THEN REGISTER32[22] = WDAT;
				WHEN x"00800000" THEN REGISTER32[23] = WDAT;
				WHEN x"01000000" THEN REGISTER32[24] = WDAT;
				WHEN x"02000000" THEN REGISTER32[25] = WDAT;
				WHEN x"04000000" THEN REGISTER32[26] = WDAT;
				WHEN x"08000000" THEN REGISTER32[27] = WDAT;
				WHEN x"10000000" THEN REGISTER32[28] = WDAT;
				WHEN x"20000000" THEN REGISTER32[29] = WDAT;
				WHEN x"40000000" THEN REGISTER32[30] = WDAT;
				WHEN x"80000000" THEN REGISTER32[31] = WDAT;
				WHEN OTHERS;
			END CASE;
    end if;
  end process;

  --decoder for assigning en:
	en <= x"00000000" WHEN WEN = '0' ELSE
				x"00000000" WHEN WSEL = "00000" ELSE
				x"00000002" WHEN WSEL = "00001" ELSE
				x"00000004" WHEN WSEL = "00010" ELSE
				x"00000008" WHEN WSEL = "00011" ELSE
				x"00000010" WHEN WSEL = "00100" ELSE
				x"00000020" WHEN WSEL = "00101" ELSE
				x"00000040" WHEN WSEL = "00110" ELSE
				x"00000080" WHEN WSEL = "00111" ELSE
				x"00000100" WHEN WSEL = "01000" ELSE
				x"00000200" WHEN WSEL = "01001" ELSE
				x"00000400" WHEN WSEL = "01010" ELSE
				x"00000800" WHEN WSEL = "01011" ELSE
				x"00001000" WHEN WSEL = "01100" ELSE
				x"00002000" WHEN WSEL = "01101" ELSE
				x"00004000" WHEN WSEL = "01110" ELSE
				x"00008000" WHEN WSEL = "01111" ELSE
				x"00010000" WHEN WSEL = "10000" ELSE
				x"00020000" WHEN WSEL = "10001" ELSE
				x"00040000" WHEN WSEL = "10010" ELSE
				x"00080000" WHEN WSEL = "10011" ELSE
				x"00100000" WHEN WSEL = "10100" ELSE
				x"00200000" WHEN WSEL = "10101" ELSE
				x"00400000" WHEN WSEL = "10110" ELSE
				x"00800000" WHEN WSEL = "10111" ELSE
				x"01000000" WHEN WSEL = "11000" ELSE
				x"02000000" WHEN WSEL = "11001" ELSE
				x"04000000" WHEN WSEL = "11010" ELSE
				x"08000000" WHEN WSEL = "11011" ELSE
				x"10000000" WHEN WSEL = "11100" ELSE
				x"20000000" WHEN WSEL = "11101" ELSE
				x"40000000" WHEN WSEL = "11110" ELSE
				x"80000000" WHEN WSEL = "11111" ELSE
				x"FFFFFFFF";

	--rsel muxes:
	with rsel1 select
		rdat1 <=	x"00000000" when "00000",
							REGISTER32[1] when "00001";
							REGISTER32[2] when "00010";
							REGISTER32[3] when "00011";
							REGISTER32[4] when "00100";
							REGISTER32[5] when "00101";
							REGISTER32[6] when "00110";
							REGISTER32[7] when "00111";
							REGISTER32[8] when "01000";
							REGISTER32[9] when "01001";
							REGISTER32[10] when "01010";
							REGISTER32[11] when "01011";
							REGISTER32[12] when "01100";
							REGISTER32[13] when "01101";
							REGISTER32[14] when "01110";
							REGISTER32[15] when "01111";
							REGISTER32[16] when "10000";
							REGISTER32[17] when "10001";
							REGISTER32[18] when "10010";
							REGISTER32[19] when "10011";
							REGISTER32[20] when "10100";
							REGISTER32[21] when "10101";
							REGISTER32[22] when "10110";
							REGISTER32[23] when "10111";
							REGISTER32[24] when "11000";
							REGISTER32[25] when "11001";
							REGISTER32[26] when "11010";
							REGISTER32[27] when "11011";
							REGISTER32[28] when "11100";
							REGISTER32[29] when "11101";
							REGISTER32[30] when "11110";
							REGISTER32[31] when "11111";
							BAD1 when others;

	with rsel2 select
		rdat2 <=	x"00000000" when "00000",
							REGISTER32[1] when "00001";
							REGISTER32[2] when "00010";
							REGISTER32[3] when "00011";
							REGISTER32[4] when "00100";
							REGISTER32[5] when "00101";
							REGISTER32[6] when "00110";
							REGISTER32[7] when "00111";
							REGISTER32[8] when "01000";
							REGISTER32[9] when "01001";
							REGISTER32[10] when "01010";
							REGISTER32[11] when "01011";
							REGISTER32[12] when "01100";
							REGISTER32[13] when "01101";
							REGISTER32[14] when "01110";
							REGISTER32[15] when "01111";
							REGISTER32[16] when "10000";
							REGISTER32[17] when "10001";
							REGISTER32[18] when "10010";
							REGISTER32[19] when "10011";
							REGISTER32[20] when "10100";
							REGISTER32[21] when "10101";
							REGISTER32[22] when "10110";
							REGISTER32[23] when "10111";
							REGISTER32[24] when "11000";
							REGISTER32[25] when "11001";
							REGISTER32[26] when "11010";
							REGISTER32[27] when "11011";
							REGISTER32[28] when "11100";
							REGISTER32[29] when "11101";
							REGISTER32[30] when "11110";
							REGISTER32[31] when "11111";
							BAD1 when others;

end regfile_arch;
