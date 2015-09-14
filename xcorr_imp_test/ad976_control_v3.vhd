-- Controls AD976 and related RAM for storing samples. 
-- v2 was for single runs and needed to be reset after each instance. v3 automatically returns to the 
-- idle state after running

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ad976_control_v3 is
	generic( 	clk_rate 		: natural := 100 -- MHz
			); 
	Port(  		sample_rate 	: in natural;
				n_samples 		: in natural;
				run 			: in std_logic;
				rst 			: in std_logic;
				clk 			: in std_logic;
				busy 			: in std_logic;
				ram_initialized : in std_logic;
				samp_ram_addr	: out std_logic_vector(11 downto 0);
				samp_ram_wea	: out std_logic_vector(0 downto 0);
				data_ready 		: out std_logic;
				rc 				: out std_logic
		);         
end ad976_control_v3;

architecture Behavioral of ad976_control_v3 is

signal state : natural range 0 to 5 := 0;
signal clk_counter : natural range 0 to 5000 := 0;
signal sample_counts : natural range 50 to 5000 := 2500;
signal samp_ram_addr_s, samp_ram_max_addr : std_logic_vector(11 downto 0) := (others => '0');


begin

sample_counts <= (clk_rate * 1000) / sample_rate; -- use to set sampling rate of adc from 20 to 100 kHz
samp_ram_addr <= samp_ram_addr_s;

    process(clk, rst)
    begin
		if rst = '1' then
			samp_ram_wea <= "0";
			samp_ram_addr_s <= (others => '0');
			state <= 0;
			rc <= '1';
			clk_counter <= 0;
			data_ready <= '0';
		elsif rising_edge(clk) then
			-- wait for run command
			if state = 0 then 
				samp_ram_wea <= "0";
				samp_ram_addr_s <= (others => '0');
				clk_counter <= 0;
				rc <= '1';
				data_ready <= '0';
				if (run = '1' and rst = '0') then
					if ram_initialized = '0' then 
						samp_ram_max_addr <= std_logic_vector(to_unsigned(n_samples - 1, 12));
						state <= 1;
					elsif ram_initialized = '1' then -- using initialized values
						state <= 0;
						data_ready <= '1';
					end if;
				else
					state <= 0;
				end if;															
			-- drop rc low to begin converting
			elsif state = 1 then
				rc <= '0';
				state <= 2;
			-- wait to ensure that sampling period is maintained
			elsif state = 2 then
				rc <= '1';
				-- 4 cycle delay due to 
				if clk_counter = (sample_counts - 4) then
					state <= 3;
				else 
					clk_counter <= clk_counter + 1;
					state <= 2;
				end if;
			-- check to make sure adc is finished converting data
			elsif state = 3 then
				if busy = '1' then
					samp_ram_wea <= "1";
					state <= 4;
				elsif busy = '0' then
					state <= 3;
				end if;			
			-- check to see if desired number of samples has been reached
			elsif state = 4 then
				samp_ram_wea <= "0";
				if samp_ram_addr_s = samp_ram_max_addr then
					samp_ram_addr_s <= (others => '0');
					data_ready <= '1';
					state <= 5;
				else
					clk_counter <= 0;
					samp_ram_addr_s <= std_logic_vector(unsigned(samp_ram_addr_s) + 1);
					state <= 1;
				end if;
            elsif state = 5 then
                data_ready <= '0';
                state <= 0;
			end if;
		end if;
     end process;     		
end Behavioral;
