LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY pcpack IS
  PORT(CLK, RESET: IN STD_LOGIC;
    HALT, JREG, BRANCHDECS, JUMP, MEMWAIT: IN STD_LOGIC;
    JUMP_ADDRESS: IN STD_LOGIC_VECTOR(25 DOWNTO 0);
    JUMP_REGISTER: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGN_EXTENDED: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    JAL_ADDRESS: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    OUT_PC: OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
END pcpack;

ARCHITECTURE cpcpak OF pcpack IS
  SIGNAL pc, addPc, muxPc, prePc, bufferPc, jumpPc, jregPc, nextPc: STD_LOGIC_VECTOR(31 DOWNTO 0);  
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
  
  jumpPc <= addPc(31 DOWNTO 28) & JUMP_ADDRESS(25 DOWNTO 0) & "00";
  
  prePc <= muxPc WHEN BRANCHDECS = '1' ELSE addPc;
  bufferPc <= jumpPc WHEN JUMP = '1' ELSE prePc;
  jregPc <= JUMP_REGISTER WHEN JREG = '1' ELSE bufferPc; 
  nextPc <= pc WHEN HALT = '1' OR MEMWAIT = '1' ELSE jregPc;
  JAL_ADDRESS <= addPc;
              
END cpcpak;
    