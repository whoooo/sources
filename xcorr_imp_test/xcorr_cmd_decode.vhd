library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity xcorr_cmd_decode is
	port(clk : in std_logic;
		rxbyte_ready : in std_logic;
		rxbyte_in : in std_logic_vector(7 downto 0);
		run : out std_logic;
		rst : out std_logic;
		n_fft : out natural;
		n_samples : out natural;
		ram_initialized : out std_logic);
end xcorr_cmd_decode;

architecture behavioral of xcorr_cmd_decode is

begin

process(clk, rxbyte_ready)
begin
	if rising_edge(clk) then
		if rxbyte_ready = '1' then
			-- run if bit 7 is 1, rst if 0
			if rxbyte_in(7) = '0' then
				rst <= '1';
				run <= '0';
			else
				rst <= '0';
				run <= '1';
			end if;
			-- use preinitialized values if 1
			ram_initialized <= rxbyte_in(6);
			-- set n_samples
			case rxbyte_in(5 downto 3) is
				when "000" => n_samples <= 1024;
				when "001" => n_samples <= 2048;
				when "010" => n_samples <= 4096;
				when "011" => n_samples <= 8192;
				when "100" => n_samples <= 16384;
				when others => n_samples <= 4096;
			end case;
			-- set n_fft
			case rxbyte_in(2 downto 0) is
				when "000" => n_fft <= 2048;
				when "001" => n_fft <= 4096;
				when "010" => n_fft <= 8192;
				when "011" => n_fft <= 16384;
				when "100" => n_fft <= 32768;
				when others => n_fft <= 8192;
			end case;			
		end if;
	end if;
end process;
end behavioral;

			
			
			
			