-- $Id: $
-- File name:   tb_signExtend.vhd
-- Created:     1/21/2011
-- Author:      Gloria Budiman
-- Lab Section: Wednesday 7:30-10:20
-- Version:     1.0  Initial Test Bench

library ieee;
--library gold_lib;   --UNCOMMENT if you're using a GOLD model
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;
--use gold_lib.all;   --UNCOMMENT if you're using a GOLD model

entity tb_signExtend is
end tb_signExtend;

architecture TEST of tb_signExtend is

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

  component signExtend
    PORT(
         PIN : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
         POUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
  end component;

-- Insert signals Declarations here
  signal PIN : STD_LOGIC_VECTOR(15 DOWNTO 0);
  signal POUT : STD_LOGIC_VECTOR(31 DOWNTO 0);

-- signal <name> : <type>;

begin
  DUT: signExtend port map(
                PIN => PIN,
                POUT => POUT
                );

--   GOLD: <GOLD_NAME> port map(<put mappings here>);

process

  begin

-- Insert TEST BENCH Code Here

    PIN <= STD_LOGIC_VECTOR(TO_SIGNED(-50, 16));
    wait for 5 ns;
    PIN <= STD_LOGIC_VECTOR(TO_SIGNED(32, 16));
    wait for 5 ns;
    wait;
    
  end process;
end TEST;