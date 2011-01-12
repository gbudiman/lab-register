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
			for s in 1 to 31 loop
				reg(s) <= x"00000000";
			end loop;
    elsif (rising_edge(clk)) then
			-- Set register here
			CASE en IS
				WHEN x"00000002" => reg(1) <= WDAT;
				WHEN x"00000004" => reg(2) <= WDAT;
				WHEN x"00000008" => reg(3) <= WDAT;
				WHEN x"00000010" => reg(4) <= WDAT;
				WHEN x"00000020" => reg(5) <= WDAT;
				WHEN x"00000040" => reg(6) <= WDAT;
				WHEN x"00000080" => reg(7) <= WDAT;
				WHEN x"00000100" => reg(8) <= WDAT;
				WHEN x"00000200" => reg(9) <= WDAT;
				WHEN x"00000400" => reg(10) <= WDAT;
				WHEN x"00000800" => reg(11) <= WDAT;
				WHEN x"00001000" => reg(12) <= WDAT;
				WHEN x"00002000" => reg(13) <= WDAT;
				WHEN x"00004000" => reg(14) <= WDAT;
				WHEN x"00008000" => reg(15) <= WDAT;
				WHEN x"00010000" => reg(16) <= WDAT;
				WHEN x"00020000" => reg(17) <= WDAT;
				WHEN x"00040000" => reg(18) <= WDAT;
				WHEN x"00080000" => reg(19) <= WDAT;
				WHEN x"00100000" => reg(20) <= WDAT;
				WHEN x"00200000" => reg(21) <= WDAT;
				WHEN x"00400000" => reg(22) <= WDAT;
				WHEN x"00800000" => reg(23) <= WDAT;
				WHEN x"01000000" => reg(24) <= WDAT;
				WHEN x"02000000" => reg(25) <= WDAT;
				WHEN x"04000000" => reg(26) <= WDAT;
				WHEN x"08000000" => reg(27) <= WDAT;
				WHEN x"10000000" => reg(28) <= WDAT;
				WHEN x"20000000" => reg(29) <= WDAT;
				WHEN x"40000000" => reg(30) <= WDAT;
				WHEN x"80000000" => reg(31) <= WDAT;
				WHEN OTHERS => NULL;
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
							reg(1) when "00001",
							reg(2) when "00010",
							reg(3) when "00011",
							reg(4) when "00100",
							reg(5) when "00101",
							reg(6) when "00110",
							reg(7) when "00111",
							reg(8) when "01000",
							reg(9) when "01001",
							reg(10) when "01010",
							reg(11) when "01011",
							reg(12) when "01100",
							reg(13) when "01101",
							reg(14) when "01110",
							reg(15) when "01111",
							reg(16) when "10000",
							reg(17) when "10001",
							reg(18) when "10010",
							reg(19) when "10011",
							reg(20) when "10100",
							reg(21) when "10101",
							reg(22) when "10110",
							reg(23) when "10111",
							reg(24) when "11000",
							reg(25) when "11001",
							reg(26) when "11010",
							reg(27) when "11011",
							reg(28) when "11100",
							reg(29) when "11101",
							reg(30) when "11110",
							reg(31) when "11111",
							BAD1 when others;

	with rsel2 select
		rdat2 <=	x"00000000" when "00000",
							reg(1) when "00001",
							reg(2) when "00010",
							reg(3) when "00011",
							reg(4) when "00100",
							reg(5) when "00101",
							reg(6) when "00110",
							reg(7) when "00111",
							reg(8) when "01000",
							reg(9) when "01001",
							reg(10) when "01010",
							reg(11) when "01011",
							reg(12) when "01100",
							reg(13) when "01101",
							reg(14) when "01110",
							reg(15) when "01111",
							reg(16) when "10000",
							reg(17) when "10001",
							reg(18) when "10010",
							reg(19) when "10011",
							reg(20) when "10100",
							reg(21) when "10101",
							reg(22) when "10110",
							reg(23) when "10111",
							reg(24) when "11000",
							reg(25) when "11001",
							reg(26) when "11010",
							reg(27) when "11011",
							reg(28) when "11100",
							reg(29) when "11101",
							reg(30) when "11110",
							reg(31) when "11111",
							BAD1 when others;

end regfile_arch;
