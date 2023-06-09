LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
 
LIBRARY WORK;
USE WORK.ALL;

ENTITY UART IS
	PORT(   CLOCK_50 	: IN STD_LOGIC; -- the fast clock for spinning wheel
			  KEY 		: IN STD_LOGIC_VECTOR(3 downto 0);  -- includes slow_clock and reset
			  
			  MESSAGE   : IN STD_LOGIC_VECTOR(7 downto 0);
			  
			  UART_RXD  : IN STD_LOGIC;
			  UART_RTS  : IN STD_LOGIC;
			  
			  
			  UART_TXD	: OUT STD_LOGIC;
			  UART_CTS	: OUT STD_LOGIC;
			  
			  recievedMessage	  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	
			  );
END UART;


ARCHITECTURE structural OF UART IS

COMPONENT TRANSMITTER is
     port(
		  KEY		  : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		  CLOCK_50 : IN STD_LOGIC;
		  MESSAGE  : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		  
        UART_RTS : IN STD_LOGIC;
		  UART_TXD : OUT STD_LOGIC;
		  
		  LEDG	  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
		  ); 
END COMPONENT;

COMPONENT RECEIVER is
	PORT(
		  KEY		  			  : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		  CLOCK_50 			  : IN STD_LOGIC;
		  
		  UART_RXD 			  : IN STD_LOGIC;
        UART_CTS 			  : OUT STD_LOGIC;
		  
		  recievedMessage	  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
);		
end COMPONENT;


BEGIN

UART_T: TRANSMITTER PORT MAP (CLOCK_50 => CLOCK_50, KEY => KEY, UART_TXD => UART_TXD, UART_RTS => UART_RTS, message => message);

UART_R: RECEIVER PORT MAP (CLOCK_50 => CLOCK_50, KEY => KEY, UART_RXD => UART_RXD, UART_CTS => UART_CTS, recievedMessage => recievedMessage);

END;
