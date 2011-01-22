LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY pcpack IS
  PORT(ZERO: IN STD_LOGIC;
    BRANCH, JUMP: IN STD_LOGIC;
    HALT, CLK, RESET: IN STD_LOGIC;
    JUMP_ADDRESS: IN STD_LOGIC_VECTOR(25 DOWNTO 0);
    SIGN_EXTENDED: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    OUT_PC: OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
END pcpack;

ARCHITECTURE cpcpak OF pcpack IS
  SIGNAL pc, addPc, muxPc, bufferPc, jumpPc, nextPc: STD_LOGIC_VECTOR(31 DOWNTO 0);  
  SIGNAL branchDecs: STD_LOGIC;
  SIGNAL carry, carryMux: STD_LOGIC_VECTOR(32 DOWNTO 0);
  SIGNAL constantFour, inShift, jumpShift: STD_LOGIC_VECTOR(31 DOWNTO 0);
BEGIN
  PCREG: PROCESS(nextPc, RESET, CLK)
  BEGIN
    IF (RESET = '1') THEN
      pc <= x"00000000";
      OUT_PC <= x"00000000";
    ELSIF (RISING_EDGE(CLK)) THEN
      pc <= nextPc;
      OUT_PC <= nextPc;
    END IF;
  END PROCESS PCREG;
  
  carry(0) <= '0';
  constantFour <= x"00000004";
  ripple_adder_1: for s in 0 to 31 generate
    addPc(s) <= pc(s) XOR constantFour(s) XOR carry(s);
    carry(s + 1) <= (pc(s) AND constantFour(s)) OR (constantFour(s) AND carry(s)) OR (carry(s) AND pc(s));
  end generate ripple_adder_1;
  
  inShift <= SIGN_EXTENDED(29 DOWNTO 0) & "00";
  
  carryMux(0) <= '0';
  ripple_adder_2: for s in 0 to 31 generate
    muxPc(s) <= addPc(s) XOR inShift(s) XOR carryMux(s);
    carryMux(s + 1) <= (addPc(s) AND inShift(s)) OR (inShift(s) AND carryMux(s)) OR (carryMux(s) AND addPc(s));
  end generate ripple_adder_2;
  
  branchDecs <= BRANCH AND ZERO;
  jumpPc <= addPc(31 DOWNTO 28) & JUMP_ADDRESS(25 DOWNTO 0) & "00";
      
  nextPc <= pc WHEN HALT = '1' ELSE
            jumpPc WHEN JUMP = '1' ELSE
            addPc WHEN branchDecs = '0' ELSE
            muxPc;
              
END cpcpak;
    