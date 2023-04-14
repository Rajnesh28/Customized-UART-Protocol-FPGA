library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

--generic (
--	data_width : integer := 8;
--	baud_rate  : integer := 19200;
--	cycles_per_bit : integer := 2605;
--	);
	
entity TRANSMITTER is
     port(
		  KEY		  : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		  CLOCK_50 : IN STD_LOGIC;
        UART_RTS : IN STD_LOGIC;
		  UART_RTX : IN STD_LOGIC;
		  
		  LEDG	  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		  UART_CTS : OUT STD_LOGIC;
		  UART_TXD : OUT STD_LOGIC); 
end TRANSMITTER;

architecture RTL of TRANSMITTER IS

TYPE STATE_TYPE IS (init, transmit, endTransmit);
SIGNAL transmitState : STATE_TYPE;

BEGIN
implicitFSM: PROCESS(CLOCK_50)

VARIABLE memoryCounter : INTEGER RANGE 0 TO 256;
VARIABLE messageByteCounter : INTEGER Range 0 TO 256;
VARIABLE messageByte : STD_LOGIC_VECTOR(7 DOWNTO 0);
VARIABLE K : INTEGER RANGE 0 TO 11;

VARIABLE parityBit : STD_LOGIC;
VARIABLE stopBit : STD_LOGIC;
VARIABLE startBit : STD_LOGIC;
VARIABLE DATA_CYCLES : INTEGER RANGE 0 to 2700;
VARIABLE COUNTER : INTEGER RANGE 0 TO 100000000;

VARIABLE messageToTransmit : STD_LOGIC_VECTOR (10 DOWNTO 0);

BEGIN

IF (KEY(3) = '0') THEN
	COUNTER := 0;
	K := 0;
	DATA_CYCLES := 0;
	MESSAGETOTRANSMIT := "00000000000";
	transmitState <= init;
	
ELSIF(RISING_EDGE(CLOCK_50)) THEN
	CASE transmitState IS 
	
	WHEN init =>
		--messageByte := "01000001";
		parityBit := '0';
		startBit := '0';
		stopBit := '1';
		UART_CTS <= '1';
		UART_TXD <= '1';
		
		messageToTransmit := startbit & "10101010" & parityBit & stopBit;	--its transmitting backwards!!!!
		UART_TXD <= messageToTransmit(K);
		transmitState<= transmit;
		
	WHEN transmit =>
	IF (DATA_CYCLES = 10) THEN
		IF (K < 10) THEN
			K := K + 1;
			UART_TXD <= messageToTransmit(K);
			DATA_CYCLES := 0;
			TRANSMITSTATE <= TRANSMIT;
		ELSIF (K = 10) THEN
			UART_TXD <= messageToTransmit(K);
			TRANSMITSTATE <= ENDTRANSMIT;
		END IF;
	ELSE	
		DATA_CYCLES := DATA_CYCLES + 1;
		transmitState <= transmit;
		END IF;

		
	WHEN endTransmit =>
		LEDG(0) <= '1';
		transmitState <= endTransmit;
	
	
	END CASE;
END IF;
END PROCESS;
END;

			