

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sig_var_test_sim is
end sig_var_test_sim;

architecture Behavioral of sig_var_test_sim is

constant clk100_period : time := 10 ns;
signal clk100 : std_logic := '0';
signal a_sig, b_var : std_logic_Vector(1 downto 0) := "00";

begin

uut : entity work.sig_var_test
	port map(	clk => clk100,
                out_sig => a_sig,
                out_var => b_var);
					
clk100_process : process
	begin
	 	clk100 <= '0';
	 	wait for clk100_period/2;
	 	clk100 <= '1';
	 	wait for clk100_period/2;
end process;

stim_proc : process
	begin
		 wait for 50 ns;
		 wait;
end process;


end Behavioral;
