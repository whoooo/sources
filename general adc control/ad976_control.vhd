-- Jacob Tobin
-- Create Date: 11/04/2014 12:40:02 PM
-- Module Name: ad976_control - Behavioral
-- Description: control logic to read from ad976 adc and alert fpga that data is ready to be taken in
-- 				see figure 2 on page 8 of ad976 datasheet for timing diagram
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ad976_control is
	generic( 	clk_rate : natural := 5; -- MHz
				sample_rate : natural := 100); -- kHz
    Port(  din : in STD_LOGIC_VECTOR(15 downto 0);
           clk : in std_logic;
           busy : in STD_LOGIC;
           cs : out STD_LOGIC;
           rc : out STD_LOGIC;
           adc_en : in std_logic;
           adc_clk : out std_logic;
           dout : out std_logic_vector(15 downto 0);
           dready: out std_logic);         
end ad976_control;

architecture Behavioral of ad976_control is

signal state : std_logic_vector (1 downto 0) := "00";
signal clk_counter : natural range 0 to 5000 := 0;
signal sample_count : natural range 50 to 5000 := 2500;



begin
sample_count <= (clk_rate * 1000) / sample_rate; -- use to set sampling rate of adc from 40 to 100 kHz
cs <= '0'; -- tie ~cs low to control adc976 w r/c
    process(clk, adc_en)
    begin
		if (adc_en = '0') then
            dout <= (others => '0');
            dready <= '0';
            state <= "00"; 
            rc <= '1';
            clk_counter <= 0 ;         
         elsif rising_edge(clk) then
         	if (state = "00") then -- idle state
         		clk_counter <= 0;
         		dready <= '0';
         		if (adc_en = '1') then
         			rc <= '0'; -- drop rc low to tell adc to convert current data
         			state <= "01";
         		else state <= "00";
         		end if;
         	elsif (state = "01") then 
				rc <= '1';
				if clk_counter = (sample_count -1) then
					state <= "10";
					adc_clk <= '1';
				else 
					clk_counter <= clk_counter + 1;
         		end if;	        	
         	elsif (state = "10") then
				if (busy = '0') then -- wait until data is ready to be read					
         			state <= "10";
         			adc_clk <= '0';
         		elsif (busy = '1') then --busy going high shows that data is ready
         			dready <= '1';
         			dout <= din;
         			state <= "00";
         			adc_clk <= '0';
         		end if;
         	end if;
         end if;
     end process;     		
end Behavioral;
