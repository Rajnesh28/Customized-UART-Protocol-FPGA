LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
 
LIBRARY WORK;
USE WORK.ALL;

ENTITY simulatedUART IS
	PORT(   CLOCK_50 	: IN STD_LOGIC; -- the fast clock for spinning wheel
			  KEY 		: IN STD_LOGIC_VECTOR(3 downto 0);  -- includes slow_clock and reset
			  
			  MESSAGE1   		  : IN STD_LOGIC_VECTOR(7 downto 0);
			  MESSAGE2   		  : IN STD_LOGIC_VECTOR(7 downto 0);
			  
			  recievedMessage1	  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			  recievedMessage2	  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
			  
END simulatedUART;


ARCHITECTURE structural OF simulatedUART IS

COMPONENT UART IS
	PORT(   CLOCK_50 	: IN STD_LOGIC; -- the fast clock for spinning wheel
			  KEY 		: IN STD_LOGIC_VECTOR(3 downto 0);  -- includes slow_clock and reset
			  
			  MESSAGE   : IN STD_LOGIC_VECTOR(7 downto 0);
			  
			  UART_RXD  : IN STD_LOGIC;
			  UART_RTS  : IN STD_LOGIC;
			  
			  
			  UART_TXD	: OUT STD_LOGIC;
			  UART_CTS	: OUT STD_LOGIC;
			  
			  recievedMessage	  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	
			  );
END COMPONENT;

 


SIGNAL txd1, txd2 : STD_LOGIC;

SIGNAL cts1, cts2 : STD_LOGIC;

BEGIN
UART_1: UART PORT MAP (CLOCK_50=>CLOCK_50, KEY=>KEY, MESSAGE => MESSAGE1, recievedMessage => recievedMessage1, UART_RXD => txd2, UART_RTS => cts2, UART_TXD => txd1, UART_CTS => cts1);

UART_2: UART PORT MAP (CLOCK_50=>CLOCK_50, KEY=>KEY, MESSAGE => MESSAGE2, recievedMessage => recievedMessage2, UART_RXD => txd1, UART_RTS => cts1, UART_TXD =>txd2, UART_CTS => cts2);

END;