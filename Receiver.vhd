--Rajnesh Joshi & Devon Sandhu
--ENSC 350
--Lab Group 28

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RECEIVER is
  port(
		  KEY		  : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		  CLOCK_50 : IN STD_LOGIC;
        UART_RTS : IN STD_LOGIC;
		  UART_RTX : IN STD_LOGIC;--
		  
		  LEDG	  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		  UART_CTS : OUT STD_LOGIC;
		  UART_TXD : OUT STD_LOGIC);					
end RECEIVER;

architecture rtl of RECEIVER is
	
--States
type STATE IS (RESET, IDLE, WAITPERIODS, READ_DATA, VERIFY_PARITY, DISPLAY_LCD, TRANSMIT_MESSAGE); 
SIGNAL CURRENT_STATE : STATE; 

--SIGNAL DATA_T 		: UNSIGNED(8 DOWNTO 0);
SIGNAL REDO_TRANSMIT : STD_LOGIC := '0';
SIGNAL PARITY_T		: STD_LOGIC := '0';
SIGNAL DATA_R		: STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL PARITY_R		: STD_LOGIC := '1';

begin
	
NEXT_LOGIC : PROCESS(CLOCK_50, KEY)
variable CYCLES : INTEGER;
variable DATA_CYCLES : INTEGER;
variable INDEX : INTEGER;
BEGIN
IF (KEY(3) = '0') THEN
	CURRENT_STATE <= RESET;


ELSIF (RISING_EDGE(CLOCK_50)) THEN

	CASE CURRENT_STATE IS 
	WHEN RESET =>
		CYCLES := 0;
		DATA_CYCLES := 0;
		INDEX := 0;
		CURRENT_STATE <= IDLE;
		
	WHEN IDLE =>
		IF (UART_RTX = '0') THEN
			CURRENT_STATE <= WAITPERIODS;
		ELSE 
			CURRENT_STATE <= IDLE;
		END IF;
	
	WHEN WAITPERIODS => 
		IF (CYCLES = 3908) THEN	
			DATA_R(INDEX) <= UART_RTX;
			CURRENT_STATE <= READ_DATA;
		ELSE 
			CYCLES := CYCLES + 1;
			CURRENT_STATE <= WAITPERIODS;
		END IF;

		WHEN READ_DATA =>
			IF (DATA_CYCLES = 2605) THEN
				IF (INDEX < 10) THEN
					INDEX := INDEX + 1;
					IF (INDEX = 9) THEN
						PARITY_T <= UART_RTX;
					ELSIF (INDEX = 10) THEN
						INDEX := 0;
						CURRENT_STATE <= VERIFY_PARITY;
					ELSE
						DATA_R(INDEX) <= UART_RTX;
						DATA_CYCLES := 0;
						CURRENT_STATE <= READ_DATA;
					END IF;
				END IF;
			ELSE
				DATA_CYCLES := DATA_CYCLES + 1;
				CURRENT_STATE <= READ_DATA;
			END IF;

		WHEN VERIFY_PARITY =>
			IF (DATA_R(INDEX) = '1') THEN
				PARITY_R <= NOT PARITY_R;
			ELSE
				PARITY_R <= PARITY_R;
			END IF;
			
			IF (INDEX < 7)THEN
				INDEX := INDEX + 1;
				CURRENT_STATE <= VERIFY_PARITY;
			ELSIF (PARITY_R = PARITY_T) THEN
				CURRENT_STATE <= DISPLAY_LCD;
			ELSE
				REDO_TRANSMIT <= '1';
				CURRENT_STATE <= IDLE;
			END IF;
			
		WHEN DISPLAY_LCD =>
			CURRENT_STATE <= TRANSMIT_MESSAGE;
			
		WHEN TRANSMIT_MESSAGE =>
			CURRENT_STATE <= IDLE;
			
		END CASE;
		
		
END IF;
END PROCESS;

END;