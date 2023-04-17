library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

    
ENTITY tb_RECEIVER is
--No inputs or outputs
END tb_receiver;

ARCHITECTURE test OF tb_receiver IS

COMPONENT receiver is
     port(
          KEY          : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
          CLOCK_50 : IN STD_LOGIC;
        UART_RTS : IN STD_LOGIC;
          UART_RXD : IN STD_LOGIC;--
          
          LEDG      : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
          UART_CTS : OUT STD_LOGIC;
          UART_TXD : OUT STD_LOGIC;
          DATA      : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
);        
END COMPONENT;



CONSTANT period : time := 10ns;
SIGNAL clksig : STD_LOGIC := '1'; 

SIGNAL UART_RTSsig, UART_RTXsig : STD_LOGIC;
SIGNAL KEYsig : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL DATASIG : STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN

DUT : receiver 

PORT MAP(KEY=>KEYsig, CLOCK_50=>clksig, UART_RTS=>UART_RTSsig, UART_RXD=>UART_RTXsig, DATA => DATASIG);

clksig <= NOT clksig after period;


PROCESS

BEGIN

Keysig(3) <= '0';
UART_RTXsig <= '1';

wait for 100ns;

Keysig(3) <= '1';
UART_RTXsig <= '0';

wait for 72100ns;

Keysig(3) <= '1';
UART_RTXsig <= '1';

wait for 52100ns;

Keysig(3) <= '1';
UART_RTXsig <= '0';

wait for 52100ns;

Keysig(3) <= '1';
UART_RTXsig <= '1';
wait for 52100ns;

Keysig(3) <= '1';
UART_RTXsig <= '0';

wait for 52100ns;

Keysig(3) <= '1';
UART_RTXsig <= '1';

wait for 52100ns;

Keysig(3) <= '1';
UART_RTXsig <= '0';

wait for 52100ns;

Keysig(3) <= '1';
UART_RTXsig <= '1';

wait for 52100ns;

Keysig(3) <= '1';
UART_RTXsig <= '0';

wait for 52100ns;

Keysig(3) <= '1';
UART_RTXsig <= '1';        --stop bit

wait for 2500ns;

wait;

END PROCESS;
END test;