library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity resize_tb is
end resize_tb;

architecture behavioral of resize_tb is

constant clk100_period : time := 10 ns;
signal clk100, rsta : std_logic := '0';
signal wea : std_logic_vector(0 downto 0) := "0";
signal addra, max_addra : std_logic_vector(13 downto 0) := (others => '0');
signal dina, douta, test_resize : std_logic_vector(15 downto 0) := (others => '0');
signal data, test_original : std_logic_vector(7 downto 0) := x"00";
signal state : natural := 0;

begin

mem : entity work.mem_coe
  PORT MAP (
    clka => clk100,
    wea => wea,
    addra => addra,
    dina => dina,
    douta => douta);
  
clk100_process : process
	begin
	 	clk100 <= '0';
	 	wait for clk100_period/2;
	 	clk100 <= '1';
	 	wait for clk100_period/2;
end process;


stm_proc : process
begin
	
	wait until rising_edge(clk100);
	if state = 0 then
		max_addra <= "00000000000111";
		state <= 1;
	elsif state = 1 then
		data <= x"aa";
		state <= 2;
	elsif state = 2 then
		dina <= std_logic_vector(resize(signed(data), 16));
		wea <= "1";
		if addra = max_addra then
			state <= 5;
		else
			addra <= std_logic_vector(unsigned(addra) + 1);
			data <= std_logic_vector(unsigned(data) + 1);
		end if;
	elsif state = 5 then
		addra <= (others => '0');
		wea <= "0";
		state <= 6;
	elsif state = 6 then 
		if addra = max_addra then
			state <= 7;
			wait;
		else
			addra <= std_logic_vector(unsigned(addra) + 1);	
		end if;
	end if;
end process;
			
-- stim_proc : process	
	-- begin
	
		-- -- wait until rising_edge(clk100);
		-- -- test_original <= x"aa";
		
		-- -- wait until rising_edge(clk100);
		-- -- test_original <= x"ab";
		-- -- test_resize <= std_logic_vector(resize(signed(test_original), 16));

		-- -- wait until rising_edge(clk100);
		-- -- test_resize <= std_logic_vector(resize(signed(test_original), 16));

		-- wait until rising_edge(clk100);
		-- dina <= std_logic_vector(resize(signed(data), 16));
		-- data <= x"01";
		-- wea <= "1";
		
		-- wait for clk100_period;
		-- addra <= std_logic_vector(unsigned(addra) + 1);
		-- dina <= std_logic_vector(resize(signed(data), 16));
		-- data <= x"02";
		
		-- wait for clk100_period;
		-- dina <= std_logic_vector(resize(signed(data), 16));
		-- addra <= std_logic_vector(unsigned(addra) + 1);
		-- data <= x"03";		
		
		-- wait for clk100_period;
		-- dina <= std_logic_vector(resize(signed(data), 16));
		-- addra <= std_logic_vector(unsigned(addra) + 1);
		-- data <= x"04";	
		
		-- wait for clk100_period;
		-- dina <= std_logic_vector(resize(signed(data), 16));
		-- addra <= std_logic_vector(unsigned(addra) + 1);
		-- data <= x"FF";
		
		-- wait for clk100_period;
		-- addra <= x"000";
		
		-- wait for clk100_period;
		-- wea <= "0";
		
		-- wait for clk100_period;
		-- addra <= std_logic_vector(unsigned(addra) + 1);
		
		-- wait for clk100_period;
		-- addra <= std_logic_vector(unsigned(addra) + 1);
		
		-- wait for clk100_period;
		-- addra <= std_logic_vector(unsigned(addra) + 1);
		
		-- wait for clk100_period;
		-- addra <= std_logic_vector(unsigned(addra) + 1);
		
		-- wait for clk100_period;
		-- addra <= std_logic_vector(unsigned(addra) + 1);
		
		-- wait for clk100_period;
		-- addra <= std_logic_vector(unsigned(addra) + 1);
		
		-- wait;
	
--end process;

end behavioral;
