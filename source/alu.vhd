-- ALU Unit
-- Gloria Budiman

library ieee;
use ieee.std_logic_1164.all;

ENTITY alu IS
  PORT(opcode: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    A, B: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    OUTPUT: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    NEGATIVE, OVERFLOW, ZERO: OUT STD_LOGIC)
END alu;