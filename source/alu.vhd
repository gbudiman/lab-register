-- ALU Unit
-- Gloria Budiman

library ieee;
use ieee.std_logic_1164.all;

ENTITY alu IS
  PORT(OPCODE: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    A, B: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    OUTPUT: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    NEGATIVE, OVERFLOW, ZERO: OUT STD_LOGIC);
END alu;

ARCHITECTURE df_alu OF alu IS
  SIGNAL s_SLL_0, s_SLL_1, s_SLL_2, s_SLL_3, s_SLL: STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL s_SRL_0, s_SRL_1, s_SRL_2, s_SRL_3, s_SRL: STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL s_ADD, s_SUB, s_AND, s_NOR, s_OR, s_XOR: STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL carry: STD_LOGIC_VECTOR(32 DOWNTO 0);
BEGIN
  ZERO <= '1' WHEN s_SLL = x"00000000"
                OR s_SRL = x"00000000"
                OR s_ADD = x"00000000"
                OR s_SUB = x"00000000"
                OR s_AND = x"00000000"
                OR s_NOR = x"00000000"
                OR s_OR = x"00000000"
                OR s_XOR = x"00000000" ELSE '0';
  NEGATIVE <= '1' WHEN s_SLL(31) = '1'
                OR s_SRL(31) = '1'
                OR s_ADD(31) = '1'
                OR s_SUB(31) = '1'
                OR s_AND(31) = '1'
                OR s_NOR(31) = '1'
                OR s_OR(31) = '1'
                OR s_XOR(31) = '1' ELSE '0';
  OUTPUT <= s_SLL WHEN OPCODE = "000" ELSE
            s_SRL WHEN OPCODE = "001" ELSE
            s_ADD WHEN OPCODE = "010" ELSE
            s_SUB WHEN OPCODE = "011" ELSE
            s_AND WHEN OPCODE = "100" ELSE
            s_NOR WHEN OPCODE = "101" ELSE
            s_OR WHEN OPCODE = "110" ELSE
            s_XOR;
  
  s_SLL_0 <= A(30 DOWNTO 0) & '0' WHEN B(0) = '1' ELSE A;
  s_SLL_1 <= s_SLL_0(29 DOWNTO 0) & "00" WHEN B(1) = '1' ELSE s_SLL_0;
  s_SLL_2 <= s_SLL_1(27 DOWNTO 0) & "0000" WHEN B(2) = '1' ELSE s_SLL_1;
  s_SLL_3 <= s_SLL_2(23 DOWNTO 0) & "00000000" WHEN B(3) = '1' ELSE s_SLL_2;
  s_SLL <= s_SLL_3(15 DOWNTO 0) & "0000000000000000" WHEN B(4) = '1' ELSE s_SLL_3;
  
  S_SRL_0 <= '0' & A(31 DOWNTO 1) WHEN B(0) = '1' ELSE A;
  S_SRL_1 <= "00" & S_SRL_0(31 DOWNTO 2) WHEN B(1) = '1' ELSE S_SRL_0;
  S_SRL_2 <= "0000" & S_SRL_1(31 DOWNTO 4) WHEN B(2) = '1' ELSE S_SRL_1;
  S_SRL_3 <= "00000000" & S_SRL_2(31 DOWNTO 8) WHEN B(3) = '1' ELSE S_SRL_2;
  S_SRL <= "0000000000000000" &S_SRL_3(31 DOWNTO 16) WHEN B(4) = '1' ELSE S_SRL_3;
  
  ripple_adder: for s in 0 to 31 generate
    s_ADD(s) <= A(s) XOR b(s) XOR carry(s);
    carry(s + 1) <= carry(s) AND (A(s) AND b(s));
  end generate ripple_adder;
END df_alu;