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
  
  procedure myOp(
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
      IF intA + intB = CONV_INTEGER(toCheck) THEN
        report "Addition correct" severity note;
      ELSE
        report "Addition FAILED" severity error;
      END IF;
    ELSIF (op = 3) THEN
      IF intA - intB = CONV_INTEGER(toCheck) THEN
        report "Subtraction correct" severity note;
      ELSE
        report "Subtraction FAILED" severity note;
      END IF;
    END IF;
    wait for 2 ns;
  END myOp;
  
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
    OPCODE <= "010";
    --for i in 0 to 34 loop
      --myShift(x"A5A5A5A5", i, A, B);
    --end loop;
    myOp(90, 32, 3, OUTPUT, A, B, opcode);
    myOp(30, 1000, 3, OUTPUT, A, B, opcode);
    myOp(5000, 1, 3, OUTPUT, A, B, opcode);
    myOp(1532, 3516, 3, OUTPUT, A, B, opcode);
    myOp(2147483647, 1, 2, OUTPUT, A, B, opcode);
    myOp(2147483647, -2147483648, 3, OUTPUT, A, B, opcode);
    myOp(43613661, -1, 6, OUTPUT, A, B, opcode);
    myOp(4361, 0, 4, OUTPUT, A, B, opcode);
    myOp(724882, 0, 7, OUTPUT, A, B, opcode);
    --myOp(x"3DFBA9C0", x"FFFFFFFF", 6, OUTPUT, A, B, opcode);
    --myOp(x"9163BA31", x"00000000", 4, OUTPUT, A, B, opcode);
    --myOp(x"FFFFFFFF", x"00000000", 7, OUTPUT, A, B, opcode);
    wait;
-- Insert TEST BENCH Code Here

    --OPCODE <= 
    --A <= 
    --B <= 

  end process;
end TEST;