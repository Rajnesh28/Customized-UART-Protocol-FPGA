LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
 
LIBRARY WORK;
USE WORK.ALL;

ENTITY tb_UART IS
END tb_UART;

ARCHITECTURE test of tb_UART IS
COMPONENT completeUART
	PORT(   CLOCK_50 	: IN STD_LOGIC; -- the fast clock for spinning wheel
			  KEY 		: IN STD_LOGIC_VECTOR(3 downto 0);  -- includes slow_clock and reset
			  
			  MESSAGE1   		  : IN STD_LOGIC_VECTOR(7 downto 0);
			  MESSAGE2   		  : IN STD_LOGIC_VECTOR(7 downto 0);
			  
			  recievedMessage1	  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			  recievedMessage2	  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
END COMPONENT;




CONSTANT period : time := 10ns;
SIGNAL clksig : STD_LOGIC := '1'; 

SIGNAL MESSAGE1SIG   		  :  STD_LOGIC_VECTOR(7 downto 0);
SIGNAL MESSAGE2SIG   		  :  STD_LOGIC_VECTOR(7 downto 0);

SIGNAL KEYsig : STD_LOGIC_VECTOR(3 DOWNTO 0);

SIGNAL recievedMessage1SIG	  :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL recievedMessage2SIG	  :  STD_LOGIC_VECTOR(7 DOWNTO 0);


BEGIN

DUT : completeUART 

PORT MAP(KEY=>KEYsig, CLOCK_50=>clksig, MESSAGE1=>MESSAGE1SIG, MESSAGE2=>MESSAGE2SIG, recievedMessage1 => recievedMessage1SIG, recievedMessage2 => recievedMessage2SIG);

clksig <= NOT clksig after period;

PROCESS

BEGIN

Keysig(3) <= '0';

wait for 40ns;

Keysig(3) <= '1';
MESSAGE1SIG <= "10001000";
MESSAGE2SIG <= "10101010";

WAIT FOR 550000ns;

MESSAGE1SIG <= "11111111";
MESSAGE2SIG <= "000000010";

WAIT FOR 550000ns;

MESSAGE1SIG <= "10101000";
MESSAGE2SIG <= "10000010";

WAIT FOR 550000ns;


WAIT;
END PROCESS;
END test;