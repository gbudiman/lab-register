LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY setterMux IS
  PORT(SETU: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    A, B: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    VAL: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONTROL: OUT STD_LOGIC);
END setterMux;

ARCHITECTURE pcsm OF setterMux IS
  SIGNAL s_SUB: STD_LOGIC_VECTOR(32 DOWNTO 0);
  SIGNAL carry_minus: STD_LOGIC_VECTOR(32 DOWNTO 0);
BEGIN
  carry_minus(0) <= '1';
  ripple_sub: for s in 0 to 31 generate
    s_SUB(s) <= A(s) XOR (NOT B(s)) XOR carry_minus(s);
    carry_minus(s + 1) <= (A(s) AND NOT B(s)) OR (NOT B(s) AND carry_minus(s)) OR (carry_minus(s) AND A(s));
  end generate ripple_sub;
  
  s_SUB(32) <= '0' XOR '1' XOR carry_minus(32);
  
  CONTROL <= SETU(0);
  
  VAL <= x"00000001" 
    WHEN (SETU = "01" AND s_SUB(31) = '1' AND ((carry_minus(32) XOR carry_minus(31)) = '0') )
      OR (SETU = "11" AND s_SUB(32) = '1')
    ELSE x"00000000";
END pcsm;