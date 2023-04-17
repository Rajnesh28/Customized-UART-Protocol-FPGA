--Rajnesh Joshi & Devon Sandhu
--ENSC 350
--Lab Group 28

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RECEIVER is
	PORT(   CLOCK_50 	: IN STD_LOGIC;
			  KEY 		: IN STD_LOGIC_VECTOR(3 downto 0);  
			  
			  UART_RXD  : IN STD_LOGIC;
			  UART_RTS  : IN STD_LOGIC;
			  
			  LEDG : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
);		
end RECEIVER;

architecture rtl of RECEIVER is
	
--States
type STATE IS (IDLE, WAITPERIODS, READ_DATA, VERIFY_PARITY, DISPLAY_LCD, TRANSMIT_MESSAGE); 
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
	LEDG(0) <= '1';

	CYCLES := 0;
	DATA_CYCLES := 0;
	INDEX := 0;
	DATA_R <= "00000000";
	CURRENT_STATE <= IDLE;

ELSIF (RISING_EDGE(CLOCK_50)) THEN

	CASE CURRENT_STATE IS 
--	WHEN RESET =>
--		LEDG(0) <= '1';
--
--		CYCLES := 0;
--		DATA_CYCLES := 0;
--		INDEX := 0;
--		DATA_R <= "00000000";
--		CURRENT_STATE <= IDLE;
	WHEN IDLE =>
		LEDG(0) <= '0';
		LEDG(1) <= '0';

		IF (UART_RXD = '0') THEN
			CURRENT_STATE <= WAITPERIODS;
		ELSE 
			CURRENT_STATE <= IDLE;
		END IF;
	
	WHEN WAITPERIODS => 
		IF (CYCLES = 3908) THEN	
			DATA_R(INDEX) <= UART_RXD;
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
						PARITY_T <= UART_RXD;
					ELSIF (INDEX = 10) THEN
						INDEX := 0;
						CURRENT_STATE <= VERIFY_PARITY;
					ELSE
						DATA_R(INDEX) <= UART_RXD;
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
			LEDG <= DATA_R;
			LEDG(1) <= '1';
			CURRENT_STATE <= TRANSMIT_MESSAGE;
			
		END CASE;
		
		
END IF;
END PROCESS;

END;