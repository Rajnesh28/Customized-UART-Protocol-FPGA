library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

    
ENTITY tb_RECEIVER is
--No inputs or outputs
END tb_receiver;

ARCHITECTURE test OF tb_receiver IS

COMPONENT receiver is
	PORT(
		  KEY		  			  : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		  CLOCK_50 			  : IN STD_LOGIC;
		  
		  UART_RXD 			  : IN STD_LOGIC;
        UART_CTS 			  : OUT STD_LOGIC;
		  
		  recievedMessage	  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
);		
END COMPONENT;



CONSTANT period : time := 10ns;
SIGNAL clksig : STD_LOGIC := '1'; 

SIGNAL UART_RXDsig, UART_CTSsig : STD_LOGIC;
SIGNAL KEYsig : STD_LOGIC_VECTOR(3 DOWNTO 0);

SIGNAL DATASIG : STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN

DUT : receiver 

PORT MAP(KEY=>KEYsig, CLOCK_50=>clksig, UART_RXD=>UART_RXDsig, UART_CTS=>UART_CTSsig, recievedMessage => DATASIG);

clksig <= NOT clksig after period;


PROCESS

BEGIN

Keysig(3) <= '0';
UART_RXDsig <= '1';
wait for 100ns;

Keysig(3) <= '1';
UART_RXDsig <= '0';
wait for 78160ns;



UART_RXDsig <= '1';
wait for 52100ns;

UART_RXDsig <= '0';
wait for 52100ns;

UART_RXDsig <= '1';
wait for 52100ns;

UART_RXDsig <= '0';
wait for 52100ns;

UART_RXDsig <= '1';
wait for 52100ns;

UART_RXDsig <= '0';
wait for 52100ns;

UART_RXDsig <= '1';
wait for 52100ns;

UART_RXDsig <= '0';
wait for 52100ns;




UART_RXDsig <= '1';
wait for 52100ns;

UART_RXDsig <= '1';        --stop bit
wait for 500000NS;

wait;

END PROCESS;
END test;