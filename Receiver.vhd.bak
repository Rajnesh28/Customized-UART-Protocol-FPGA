--Rajnesh Joshi & Devon Sandhu
--ENSC 350
--Lab Group 28

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RECIEVER is
  port(CLOCK_50            : in  std_logic;
       KEY                 : in  std_logic_vector(3 downto 0););
end Bresenham;

architecture rtl of RECIEVER is


component vga_adapter
 generic(RESOLUTION : string);
 port (reset                                       : in  std_logic;
		 clock                                        : in  std_logic;);
end component;

	
--States
type STATE IS (RESET, IDLE, WAIT1.5PERIODS, READ_DATA, VERIFY_PARITY, DISPLAY_LCD, TRANSMIT_MESSAGE); 
SIGNAL CURRENT_STATE : STATE; 

SIGNAL DATA_T 		: UNSIGNED(8 DOWNTO 0);
SIGNAL REDO_TRANSMIT : STD_LOGIC := '0';
SIGNAL PARITY_T		: STD_LOGIC := '0';
SIGNAL START		: STD_LOGIC := '0';

begin

vga_u0 : vga_adapter
 generic map(RESOLUTION => "160x120") 
 port map(reset    => KEY(3),
			 clock     => CLOCK_50);

			
NEXT_LOGIC : PROCESS(CLOCK_50, KEY)
variable CYCLES : INTEGER
variable DATA_CYCLES : INTEGER
variable INDEX : INTEGER
VARIABLE  PARITY_R : STD_LOGIC := 0;
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
		IF (START = '1') THEN
			CURRENT_STATE <= WAIT1.5PERIODS;
		ELSE 
			CURRENT_STATE <= IDLE;
		END IF;
	
	WHEN WAIT1.5PERIODS => 
		IF (CYCLES = 3908) THEN	
			CURRENT_STATE <= READ_DATA;
		ELSE 
			CYCLES := CYCLES + 1;
			CURRENT_STATE <= WAIT1.5PERIODS;
		END IF;

		WHEN READ_DATA =>
			IF (DATA_CYCLES = 2605) THEN
				DATA_R(INDEX) <= DATA_T(INDEX);
				IF (INDEX < 8) THEN
					INDEX := INDEX + 1;
					DATA_CYCLES := 0;
					CURRENT_STATE <= READ_DATA;
				ELSE 
					INDEX := 0;
					CURRENT_STATE <= VERIFY_PARITY;
				END IF;
			ELSE
				DATA_CYCLES := DATA_CYCLES + 1;
				CURRENT_STATE <= READ_DATA;
			END IF;

		WHEN VERIFY_PARITY =>
			IF (DATA_R(INDEX) = '1')
				PARITY_R := NOT PARITY_R;
			ELSE
				PARITY_R := PARITY_R;
			END IF;
			
			IF (INDEX < 8)THEN
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
			CURERNT_STATE <= IDLE;
			
		END CASE;
		
		
END IF;
END PROCESS;

END;