library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity threshold_detect_sim is
end threshold_detect_sim;

architecture behavioral of threshold_detect_sim is

constant clk100_period : time := 10 ns;
signal clk100, flag, rst : std_logic := '0';
signal xcorr_in, threshold : std_logic_vector(31 downto 0) := (others => '0');

begin

clk_process : process
	begin
	 	clk100 <= '0';
	 	wait for clk100_period/2;
	 	clk100 <= '1';
	 	wait for clk100_period/2;
end process;

uut : entity work.threshold_detect 
    port map(   clk => clk100,
				rst => rst,
                threshold => threshold,
                xcorr_in => xcorr_in,
                flag => flag
            );
            
stim_proc : process
begin
    wait for clk100_period;
    xcorr_in <= x"00000064";
    wait for clk100_period;
    threshold <= x"00007D00";  
    wait for clk100_period;      
    wait for clk100_period;
    xcorr_in <= x"00007D00"; 
    wait for clk100_period;          
    wait for clk100_period;
    xcorr_in <= x"00007DDD";                
    wait for clk100_period;
    xcorr_in <= x"00006DDD";
    wait;
end process;

end behavioral;