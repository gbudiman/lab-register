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

  procedure myShift(
    constant data: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    constant by: IN integer;
    SIGNAL sA, sB: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)) IS
  BEGIN
    sA <= data;
    sB <= CONV_STD_LOGIC_VECTOR(by, 32);
    wait for 1 us;
  END myShift;
  
  procedure myAdd(
    constant intA, intB: IN integer;
    SIGNAL aA, aB: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)) IS
  BEGIN
    aA <= CONV_STD_LOGIC_VECTOR(intA, 32);
    aB <= CONV_STD_LOGIC_VECTOR(intB, 32);
    wait for 1 us;
  END myAdd;
  
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
    myAdd(90, 32, A, B);
    myAdd(1532, 3516, A, B);
    wait;
-- Insert TEST BENCH Code Here

    --OPCODE <= 
    --A <= 
    --B <= 

  end process;
end TEST;