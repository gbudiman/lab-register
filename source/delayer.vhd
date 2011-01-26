LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY delayer IS
  PORT(CLK, RESET: IN STD_LOGIC;
    CIN: IN STD_LOGIC_VECTOR(5 DOWNTO 0);
    DELAY: OUT STD_LOGIC);
END delayer;

ARCHITECTURE seqD of delayer IS
  TYPE myState IS (S0, S1);
  SIGNAL state, nextState: myState;
BEGIN
  tld: PROCESS(CLK, RESET, nextState)
  BEGIN
    IF (RESET = '1') THEN
      state <= S0;
    ELSIF (RISING_EDGE(CLK)) THEN
      state <= nextState;
    END IF;
  END PROCESS tld;
  
  nsl: PROCESS(state, CIN)
  BEGIN
    CASE STATE IS
      WHEN S0 =>
        IF (CIN = "100011") THEN
          nextState <= S1;
        ELSE nextState <= S0;
        END IF;
      WHEN S1 =>
        nextState <= S0;
      --WHEN S2 =>
      --  nextState <= S0;
    END CASE;
  END PROCESS nsl;
  
  DELAY <= '1' WHEN nextState = S1 ELSE '0';
END seqD;