library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

	
entity txSerialport is
     port(
		  KEY		  : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		  CLOCK_50 : IN STD_LOGIC;
		  
        UART_RTS : IN STD_LOGIC;
		  UART_TXD : OUT STD_LOGIC;
		  
		  LEDG	  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
		  ); 
end txSerialport;

architecture RTL of txSerialport IS

TYPE STATE_TYPE IS (idle, calculateParity, beginTransmit, transmit, endTransmit, STOP);
SIGNAL TRANSMIT_STATE : STATE_TYPE;
SIGNAL MESSAGE : STD_LOGIC_VECTOR(7 DOWNTO 0) := "00000001";

BEGIN

implicitFSM: PROCESS(CLOCK_50)

VARIABLE K : INTEGER RANGE 0 TO 11;

VARIABLE stopBit 		: STD_LOGIC;
VARIABLE startBit 	: STD_LOGIC;
VARIABLE dataCycles  : INTEGER RANGE 0 to 2700;
VARIABLE COUNTER   	: INTEGER RANGE 0 TO 100000000;
VARIABLE parityBit 	: STD_LOGIC := '1';

VARIABLE INDEX					: INTEGER RANGE 0 TO 15;
VARIABLE messageToTransmit : STD_LOGIC_VECTOR (10 DOWNTO 0);

BEGIN

IF (KEY(3) = '0') THEN
	TRANSMIT_STATE <= idle;
	
ELSIF(RISING_EDGE(CLOCK_50)) THEN
	
	CASE TRANSMIT_STATE IS 
	WHEN STOP =>
		UART_TXD <= '1';
		TRANSMIT_STATE <= STOP;
		
	WHEN idle =>
		COUNTER := 0;
		K := 0;
		dataCycles := 0;
		index := 0;
		
		startBit := '0';
		stopBit := '1';
		
		UART_TXD <= '1';
		
		IF (UART_RTS = '1') THEN 
			TRANSMIT_STATE <= calculateParity;
		ELSE 
			TRANSMIT_STATE <= idle;
		END IF;
		
	WHEN calculateParity => 
	
		IF (message(INDEX) = '1') THEN
			parityBit := NOT parityBit;
		ELSE
			parityBit := parityBit;
		END IF;

		
		IF (INDEX < 7)THEN
			INDEX := INDEX + 1;
			TRANSMIT_STATE <= calculateParity;
		ELSE 
			index := 0;
			TRANSMIT_STATE <= beginTransmit;
		END IF;
			
		
	WHEN beginTransmit =>
	
		messageToTransmit := stopBit & parityBit & MESSAGE & startBit;
		
		UART_TXD <= messageToTransmit(K);
		
		TRANSMIT_STATE <= transmit;
		
	WHEN transmit =>
	
		IF (dataCycles = 2605) THEN
		
			IF (K < 10) THEN
				K := K + 1;
				UART_TXD <= messageToTransmit(K);
				dataCycles := 0;
				
				TRANSMIT_STATE <= TRANSMIT;
				
			ELSIF (K = 10) THEN
				UART_TXD <= messageToTransmit(K);
				
				TRANSMIT_STATE <= endTransmit;
				
			END IF;
			
		ELSE	
			dataCycles := dataCycles + 1;
			TRANSMIT_STATE <= transmit;
		END IF;

		
	WHEN endTransmit =>
	IF (MESSAGE = "10000000")THEN
			TRANSMIT_STATE <= STOP;
	ELSE
		MESSAGE <= STD_LOGIC_VECTOR(UNSIGNED(MESSAGE) + 1);
		TRANSMIT_STATE <= idle;
	END IF;
	
	
	END CASE;
END IF;
END PROCESS;
END;

			