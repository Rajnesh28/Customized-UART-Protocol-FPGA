library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

	
ENTITY tb_Transmitter is
--No inputs or outputs
END tb_Transmitter;

ARCHITECTURE test OF tb_Transmitter IS

COMPONENT Transmitter is
     PORT(
		  KEY		  : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		  CLOCK_50 : IN STD_LOGIC;
        UART_RTS : IN STD_LOGIC;
		  UART_RTX : IN STD_LOGIC;
		  
		  LEDG	  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		  UART_CTS : OUT STD_LOGIC;
		  UART_TXD : OUT STD_LOGIC); 
END COMPONENT;



CONSTANT period : time := 10ns;
SIGNAL clksig : STD_LOGIC := '1'; 

SIGNAL UART_RTSsig, UART_RTXsig : STD_LOGIC;
SIGNAL KEYsig : STD_LOGIC_VECTOR(3 DOWNTO 0);

BEGIN

DUT : Transmitter 

PORT MAP(KEY=>KEYsig, CLOCK_50=>clksig, UART_RTS=>UART_RTSsig, UART_RTX=>UART_RTXsig);

clksig <= NOT clksig after period;


PROCESS

BEGIN

Keysig(3) <= '0';

wait for period;

Keysig(3) <= '1';

wait for 2500ns;

wait;

END PROCESS;
END test;