LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY Clock_Divider IS
PORT(CLOCK_50  : IN STD_LOGIC;
		KEY      : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		clk_out  : OUT STD_LOGIC);
END ENTITY;

ARCHITECTURE behav OF Clock_Divider IS

SIGNAL tmp : STD_LOGIC;
BEGIN
process(CLOCK_50, KEY(3))
begin
    if KEY(3) = '0' then
        tmp <= '0';
    elsif rising_edge(CLOCK_50) then
        tmp <= not(tmp);
    end if;
	 clk_out <= tmp;
end process;


END ARCHITECTURE behav;
