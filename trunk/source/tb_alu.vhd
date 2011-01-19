-- $Id: $
-- File name:   tb_alu.vhd
-- Created:     1/12/2011
-- Author:      Gloria Budiman
-- Lab Section: Wednesday 7:30-10:20
-- Version:     1.0  Initial Test Bench

library ieee;
--library gold_lib;   --UNCOMMENT if you're using a GOLD model
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;
--use gold_lib.all;   --UNCOMMENT if you're using a GOLD model

entity tb_alu is
end tb_alu;

architecture TEST of tb_alu is

  function INT_TO_STD_LOGIC( X: INTEGER; NumBits: INTEGER )
     return STD_LOGIC_VECTOR is
    variable RES : STD_LOGIC_VECTOR(NumBits-1 downto 0);
    variable tmp : INTEGER;
  begin
    tmp := X;
    for i in 0 to NumBits-1 loop
      if (tmp mod 2)=1 then
        res(i) := '1';
      else
        res(i) := '0';
      end if;
      tmp := tmp/2;
    end loop;
    return res;
  end;

  component alu
    PORT(
         OPCODE : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
         A : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
         B : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
         OUTPUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
         NEGATIVE : OUT STD_LOGIC;
         OVERFLOW : OUT STD_LOGIC;
         ZERO : OUT STD_LOGIC
    );
  end component;

-- Insert signals Declarations here
  signal OPCODE : STD_LOGIC_VECTOR(2 DOWNTO 0);
  signal A : STD_LOGIC_VECTOR(31 DOWNTO 0);
  signal B : STD_LOGIC_VECTOR(31 DOWNTO 0);
  signal OUTPUT : STD_LOGIC_VECTOR(31 DOWNTO 0);
  signal NEGATIVE : STD_LOGIC;
  signal OVERFLOW : STD_LOGIC;
  signal ZERO : STD_LOGIC;

-- signal <name> : <type>;
  
  procedure myHex(
    constant intA, intB: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		constant op: IN INTEGER;
    SIGNAL toCheck: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL aA, aB: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL opcode: OUT STD_LOGIC_VECTOR(2 DOWNTO 0)) IS
  BEGIN
    opcode <= CONV_STD_LOGIC_VECTOR(op, 3);
    aA <= intA;
    aB <= intB;
    wait for 8 ns;
    IF (op = 2) THEN
      IF intA + intB = toCheck THEN
        report "Addition correct" severity note;
      ELSE
        report "Addition FAILED" severity error;
      END IF;
    ELSIF (op = 3) THEN
      IF intA - intB = toCheck THEN
        report "Subtraction correct" severity note;
      ELSE
        report "Subtraction FAILED" severity note;
      END IF;
    ELSIF (op = 4) THEN
			IF (intA AND intB) = toCheck THEN
				report "AND op correct" severity note;
			ELSE
				report "AND op FAILED" severity note;
			END IF;
    ELSIF (op = 5) THEN
			IF NOT(intA OR intB) = toCheck THEN
				report "NOR op correct" severity note;
			ELSE
				report "NOR op FAILED" severity note;
			END IF;
    ELSIF (op = 6) THEN
			IF (intA OR intB) = toCheck THEN
				report "OR op correct" severity note;
			ELSE
				report "OR op FAILED" severity note;
			END IF;
    ELSIF (op = 7) THEN
			IF (intA XOR intB) = toCheck THEN
				report "XOR op correct" severity note;
			ELSE
				report "XOR op FAILED" severity note;
			END IF;
    END IF;
    wait for 2 ns;
  END myHex;
  
  procedure myInt(
    constant intA, intB, op: IN integer;
    SIGNAL toCheck: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL aA, aB: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL opcode: OUT STD_LOGIC_VECTOR(2 DOWNTO 0)) IS
  BEGIN
    opcode <= CONV_STD_LOGIC_VECTOR(op, 3);
    aA <= CONV_STD_LOGIC_VECTOR(intA, 32);
    aB <= CONV_STD_LOGIC_VECTOR(intB, 32);
    wait for 8 ns;
    IF (op = 2) THEN
      IF CONV_STD_LOGIC_VECTOR(intA + intB, 32) = toCheck THEN
        report "Addition correct" severity note;
      ELSE
        report "Addition FAILED" severity error;
      END IF;
    ELSIF (op = 3) THEN
      IF CONV_STD_LOGIC_VECTOR(intA - intB, 32) = toCheck THEN
        report "Subtraction correct" severity note;
      ELSE
        report "Subtraction FAILED" severity note;
      END IF;
    ELSIF (op = 4) THEN
			IF (CONV_STD_LOGIC_VECTOR(intA, 32) AND CONV_STD_LOGIC_VECTOR(intB, 32)) = toCheck THEN
				report "AND op correct" severity note;
			ELSE
				report "AND op FAILED" severity note;
			END IF;
    ELSIF (op = 5) THEN
			IF (NOT CONV_STD_LOGIC_VECTOR(intA, 32) OR CONV_STD_LOGIC_VECTOR(intB, 32)) = toCheck THEN
				report "NOR op correct" severity note;
			ELSE
				report "NOR op FAILED" severity note;
			END IF;
    ELSIF (op = 6) THEN
			IF (CONV_STD_LOGIC_VECTOR(intA, 32) OR CONV_STD_LOGIC_VECTOR(intB, 32)) = toCheck THEN
				report "OR op correct" severity note;
			ELSE
				report "OR op FAILED" severity note;
			END IF;
    ELSIF (op = 7) THEN
			IF (CONV_STD_LOGIC_VECTOR(intA, 32) XOR CONV_STD_LOGIC_VECTOR(intB, 32)) = toCheck THEN
				report "XOR op correct" severity note;
			ELSE
				report "XOR op FAILED" severity note;
			END IF;
    END IF;
    wait for 2 ns;
  END myInt;

begin
  DUT: alu port map(
                OPCODE => OPCODE,
                A => A,
                B => B,
                OUTPUT => OUTPUT,
                NEGATIVE => NEGATIVE,
                OVERFLOW => OVERFLOW,
                ZERO => ZERO
                );

--   GOLD: <GOLD_NAME> port map(<put mappings here>);

process

  begin
		-- CHECK SLL
		myHex(x"0000000A", x"00000001", 0, OUTPUT, A, B, OPCODE);
		myHex(x"0000000A", x"00000004", 0, OUTPUT, A, B, OPCODE);
		myHex(x"0000000A", x"00000008", 0, OUTPUT, A, B, OPCODE);
		myHex(x"0000000A", x"00000010", 0, OUTPUT, A, B, OPCODE);
		myHex(x"0000000A", x"0000001F", 0, OUTPUT, A, B, OPCODE);
		myHex(x"0000000A", x"00000007", 0, OUTPUT, A, B, OPCODE);
		myHex(x"0000000A", x"0000001A", 0, OUTPUT, A, B, OPCODE);
		-- CHECK SRL
		myHex(x"A000000A", x"00000001", 1, OUTPUT, A, B, OPCODE);
		myHex(x"A000000A", x"00000004", 1, OUTPUT, A, B, OPCODE);
		myHex(x"A000000A", x"00000008", 1, OUTPUT, A, B, OPCODE);
		myHex(x"A000000A", x"00000010", 1, OUTPUT, A, B, OPCODE);
		myHex(x"A000000A", x"0000001F", 1, OUTPUT, A, B, OPCODE);
		myHex(x"A000000A", x"0000000D", 1, OUTPUT, A, B, OPCODE);
		myHex(x"A000000A", x"00000014", 1, OUTPUT, A, B, OPCODE);
		-- CHECK ADD
		-- CHECK SUB
			-- both small number
			myInt(12, 73, 2, OUTPUT, A, B, OPCODE);
			myInt(59, 191, 3, OUTPUT, A, B, OPCODE);
			-- both large number
			myInt(1052919919, 135973430, 2, OUTPUT, A, B, OPCODE);
			myInt(-561939513, 196039627, 3, OUTPUT, A, B, OPCODE);
			-- both large number, causes overflow
			myInt(2000000000, 1879530234, 2, OUTPUT, A, B, OPCODE);
			myInt(-2130613412, 1999648513, 3, OUTPUT, A, B, OPCODE);
			-- large, small number
			myInt(2000000102, 613, 2, OUTPUT, A, B, OPCODE);
			myInt(999125961, -10326, 3, OUTPUT, A, B, OPCODE);
			-- large, small number, causes overflow
			myInt(-2147483648, -1, 2, OUTPUT, A, B, OPCODE);
			myInt(2147483647, -1, 3, OUTPUT, A, B, OPCODE);
			-- small, large number
			myInt(-132, 2000132631, 2, OUTPUT, A, B, OPCODE);
			myInt(115, -1367423070, 3, OUTPUT, A, B, OPCODE);
			-- small, large number, causes overflow
			myInt(900, 2147483640, 2, OUTPUT, A, B, OPCODE);
			myInt(-1714, 2147483610, 3, OUTPUT, A, B, OPCODE);
			-- positive, negative, results positive
			myInt(136136, -3513, 2, OUTPUT, A, B, OPCODE);
			myInt(31613, -136167, 3, OUTPUT, A, B, OPCODE);
			-- negative, positive, results negative
			myInt(-500, 13, 2, OUTPUT, A, B, OPCODE);
			myInt(-1316136, -753782, 3, OUTPUT, A, B, OPCODE);
			-- negative, negative
			myInt(-715, -12461417, 2, OUTPUT, A, B, OPCODE);
			myInt(-17241246, -46, 3, OUTPUT, A, B, OPCODE);
			-- negative, negative, causes overflow
			myInt(-1999999999, -436136171, 2, OUTPUT, A, B, OPCODE);
			myInt(-2147123016, 461431361, 3, OUTPUT, A, B, OPCODE);
			-- any results in zero
			myInt(1471, -1471, 2, OUTPUT, A, B, OPCODE);
			myInt(-3516, -3516, 3, OUTPUT, A, B, OPCODE);
			-- any results in negative
			myInt(719043, -13246147, 2, OUTPUT, A, B, OPCODE);
			myInt(-13516, 123, 3, OUTPUT, A, B, OPCODE);
			-- additional test vectors
			myHex(x"00000001", x"7FFDFFFF", 2, OUTPUT, A, B, OPCODE);
		-- CHECK AND
		myHex(x"A5A5A5A5", x"00000000", 4, OUTPUT, A, B, OPCODE);
		-- CHECK NOR
		myHex(x"A5A5A5A5", x"00000000", 5, OUTPUT, A, B, OPCODE);
		-- CHECK OR
		myHex(x"00000000", x"FFFFFFFF", 6, OUTPUT, A, B, OPCODE);
		-- CHECK XOR
		myHex(x"A5A5A5A5", x"FFFFFFFF", 7, OUTPUT, A, B, OPCODE);
    wait;
-- Insert TEST BENCH Code Here

    --OPCODE <= 
    --A <= 
    --B <= 

  end process;
end TEST;
