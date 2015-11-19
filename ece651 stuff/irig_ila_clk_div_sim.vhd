library IEEE;
library UNISIM; 
use IEEE.STD_LOGIC_1164.all;
use UNISIM.Vcomponents.ALL;

entity irig_ila_clk_div_sim is
end irig_ila_clk_div_sim;

architecture behavioral of irig_ila_clk_div_sim is

signal clk, clk_out : std_logic := '0';
constant clk_period : time := 10 ns;

begin

clk_proc : process
begin
	clk <= '0';
	wait for clk_period/2;
	clk <= '1';
	wait for clk_period/2;
end process;

-- output clock frequency = input_frequency / 2^(dividers + 1)
-- ex output_frequency = 100E6/2^(15) = 3051.75Hz => 327us period

uut : entity work.irig_ila_clk_div
	generic map(dividers => 14)
    port map(	clk_in => clk,
             	clk_out => clk_out);

stim_proc : process
begin
    wait for 10 ns;
    wait;
end process;

end;
