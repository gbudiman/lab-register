-- $Id: $
-- File name:   tb_pcpack.vhd
-- Created:     1/21/2011
-- Author:      Gloria Budiman
-- Lab Section: Wednesday 7:30-10:20
-- Version:     1.0  Initial Test Bench

library ieee;
--library gold_lib;   --UNCOMMENT if you're using a GOLD model
use ieee.std_logic_1164.all;
--use gold_lib.all;   --UNCOMMENT if you're using a GOLD model

entity tb_pcpack is
  generic (Period : Time :=  50 ns);
end tb_pcpack;

architecture TEST of tb_pcpack is

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

  component pcpack
    PORT(
         ZERO : IN STD_LOGIC;
         BRANCH : IN STD_LOGIC;
         JUMP : IN STD_LOGIC;
         HALT : IN STD_LOGIC;
         CLK : IN STD_LOGIC;
         RESET : IN STD_LOGIC;
         SIGN_EXTENDED: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
         JUMP_ADDRESS: IN STD_LOGIC_VECTOR(25 DOWNTO 0);
         OUT_PC: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
  end component;

-- Insert signals Declarations here
  signal ZERO : STD_LOGIC;
  signal BRANCH : STD_LOGIC;
  signal JUMP : STD_LOGIC;
  signal HALT : STD_LOGIC;
  signal CLK : STD_LOGIC;
  signal RESET : STD_LOGIC;
  signal SIGN_EXTENDED: STD_LOGIC_VECTOR(31 DOWNTO 0);
  signal JUMP_ADDRESS: STD_LOGIC_VECTOR(25 DOWNTO 0);
  signal OUT_PC: STD_LOGIC_VECTOR(31 DOWNTO 0);

-- signal <name> : <type>;

begin
  DUT: pcpack port map(
                ZERO => ZERO,
                BRANCH => BRANCH,
                JUMP => JUMP,
                HALT => HALT,
                CLK => CLK,
                RESET => RESET,
                SIGN_EXTENDED => SIGN_EXTENDED,
                JUMP_ADDRESS => JUMP_ADDRESS,
                OUT_PC => OUT_PC
                );

--   GOLD: <GOLD_NAME> port map(<put mappings here>);
autoClock: process
  BEGIN
    clk <= '0';
    wait for period/2;
    clk <= '1';
    wait for period/2;
  END process autoClock;

process

  begin
    RESET <= '1';
    HALT <= '0';
    ZERO <= '0';
    BRANCH <= '0';
    JUMP <= '0';
    SIGN_EXTENDED <= x"00000000";
    JUMP_ADDRESS <= "00" & x"000000";
    wait for 5 ns;
    
    RESET <= '0';
    
    wait for 400 ns;
    report "Branch should not occur yet" severity note;
    BRANCH <= '1';
    wait for 100 ns;
    report "PC should 4-increment normally" severity note;
    ZERO <= '1';
    wait for 100 ns;
    report "PC should be decremented by 8" severity note;
    SIGN_EXTENDED <= x"FFFFFFFD";
    wait for 100 ns;
    report "Jump to x08" severity note;
    JUMP_ADDRESS <= "00" & x"000002";
    BRANCH <= '0';
    JUMP <= '1';
    wait for 50 ns;
    JUMP <= '0';
    report "Add normally again" severity note;
    wait for 100 ns;
    HALT <= '1';
    report "PC should halt" severity note;
    wait;
-- Insert TEST BENCH Code Here

    --ZERO <= 
    --BRANCH <= 
    --HALT <= 
    --CLK <= 
    --RESET <= 

  end process;
end TEST;