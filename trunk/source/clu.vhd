LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY clu IS
  PORT(QIN: IN STD_LOGIC_VECTOR(5 DOWNTO 0);
    LCTL: IN STD_LOGIC_VECTOR(5 DOWNTO 0);
    REGDST, EXTSIGN, MEMTOREG, ALUSRC, REGWRITE, MEMWRITE, HALT: OUT STD_LOGIC;
    JREG, JUMP, LINK, BEQ, BNE, UPPER, SHIFT: OUT STD_LOGIC;
    SETU: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    ALUCTL: OUT STD_LOGIC_VECTOR(2 DOWNTO 0));
END CLU;

ARCHITECTURE pcclu OF clu IS
  TYPE decodedOperation IS (oADDU, oAND, oJR, oNOR, oOR, oSLT, oSLTU, oSLL, oSRL, oSUBU, oXOR,
    oADDIU, oANDI, oBEQ, oBNE, oLUI, oLW, oORI, oSLTI, oSLTIU, oSW, oXORI, oJ, oJAL, oHALT, oX);
  SIGNAL dcOp: decodedOperation;
BEGIN
  dcOp <= oADDU   WHEN QIN = "000000" AND LCTL = "100001" ELSE -- ADDU
          oAND    WHEN QIN = "000000" AND LCTL = "100100" ELSE -- AND
          oJR     WHEN QIN = "000000" AND LCTL = "001000" ELSE -- JR
          oNOR    WHEN QIN = "000000" AND LCTL = "100111" ELSE -- NOR
          oOR     WHEN QIN = "000000" AND LCTL = "100101" ELSE -- OR
          oSLT    WHEN QIN = "000000" AND LCTL = "101010" ELSE -- SLT
          oSLTU   WHEN QIN = "000000" AND LCTL = "101011" ELSE -- SLTU
          oSLL    WHEN QIN = "000000" AND LCTL = "000000" ELSE -- SLL
          oSRL    WHEN QIN = "000000" AND LCTL = "000010" ELSE -- SRL
          oSUBU   WHEN QIN = "000000" AND LCTL = "100011" ELSE -- SUBU
          oXOR    WHEN QIN = "000000" AND LCTL = "100110" ELSE -- XOR
          
          oADDIU  WHEN QIN = "001001" ELSE -- ADDIU
          oANDI   WHEN QIN = "001100" ELSE -- ANDI
          oBEQ    WHEN QIN = "000100" ELSE -- BEQ
          oBNE    WHEN QIN = "000101" ELSE -- BNE
          oLUI    WHEN QIN = "001111" ELSE -- LUI
          oLW     WHEN QIN = "100011" ELSE -- LW
          oORI    WHEN QIN = "001101" ELSE -- ORI
          oSLTI   WHEN QIN = "001010" ELSE -- SLTI
          oSLTIU  WHEN QIN = "001011" ELSE -- SLTIU
          oSW     WHEN QIN = "101011" ELSE -- SW
          oXORI   WHEN QIN = "001110" ELSE -- XORI
          oJ      WHEN QIN = "000010" ELSE -- J
          oJAL    WHEN QIN = "000011" ELSE -- JAL
          oHALT   WHEN QIN = "111111" ELSE -- HALT
          oX; -- NOP or UNRECOGNIZED OPERATION
          
  WITH dcOp SELECT
    REGDST <= '1' WHEN oADDU | oAND | oNOR | oOR | oSLT | oSLTU | oSLL | oSRL | oSUBU | oXOR,
              '0' WHEN OTHERS;
  WITH dcOp SELECT
    ALUSRC <= '1' WHEN oADDU | oAND | oNOR | oOR | oSLT | oSLTU | oSLL | oSRL | oSUBU | oXOR | oBNE | oBEQ,
              '0' WHEN OTHERS;
  WITH dcOp SELECT
    EXTSIGN <= '1' WHEN oADDIU | oLW | oSLTI | oSW | oJ | oJAL | oBNE | oBEQ,
               '0' WHEN OTHERS;
  WITH dcOp SELECT
    REGWRITE <= '0' WHEN oJR | oBEQ | oBNE | oSW | oJ | oHALT | oX,
                '1' WHEN OTHERS;
                
  JREG <= '1' WHEN dcOp = oJR ELSE '0';
  JUMP <= '1' WHEN dcOp = oJ OR dcOp = oJAL ELSE '0';
  LINK <= '1' WHEN dcOp = oJAL ELSE '0';
  BEQ <= '1' WHEN dcOp = oBEQ ELSE '0';
  BNE <= '1' WHEN dcOp = oBNE ELSE '0';
  SETU <= "01" WHEN dcOp = oSLT OR dcOp = oSLTI ELSE
          "11" WHEN dcOp = oSLTU OR dcOp = oSLTIU ELSE "00";
  UPPER <= '1' WHEN dcOp = oLUI ELSE '0';
  ALUCTL <= "000" WHEN dcOp = oSLL ELSE
            "001" WHEN dcOp = oSRL ELSE
            "010" WHEN dcOp = oADDU OR dcOp = oADDIU OR dcOp = oLW OR dcOp = oSW ELSE
            "011" WHEN dcOp = oSUBU OR dcOp = oBEQ OR dcOp = oBNE ELSE
            "100" WHEN dcOp = oAND OR dcOP = oANDI ELSE
            "101" WHEN dcOp = oNOR ELSE
            "110" WHEN dcOp = oOR OR dcOp = oORI ELSE
            "111" WHEN dcOp = oXOR OR dcOp = oXORI;
  MEMTOREG <= '1' WHEN dcOp = oLW ELSE '0';
  HALT <= '1' WHEN dcOp = oHALT ELSE '0';
  MEMWRITE <= '1' WHEN dcOp = oSW ELSE '0';
  SHIFT <= '1' WHEN dcOp = oSLL OR dcOp = oSRL ELSE '0';
  
END PCCLU;