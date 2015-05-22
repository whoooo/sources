----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/29/2015 04:52:27 PM
-- Design Name: 
-- Module Name: ad976_control_sim - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ad976_control_sim is
end ad976_control_sim;

architecture Behavioral of ad976_control_sim is

component ad976_control_v2 
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
end component;

constant clk100_period : time := 10 ns;
signal sample_rate, n_samples, state : natural := 0;
signal run, rst, clk100, busy, data_ready, rc, ram_initialized : std_logic := '0';
signal samp_ram_addr : std_logic_vector(11 downto 0) := (others => '0');
signal samp_ram_wea : std_logic_vector(0 downto 0) := "0";

begin

clk100_process : process
	begin
	 	clk100 <= '0';
	 	wait for clk100_period/2;
	 	clk100 <= '1';
	 	wait for clk100_period/2;
end process;

uut : ad976_control_v2
	generic map (
					clk_rate => 100)
	port map(	
					sample_rate => 100,
					n_samples => 1024,
					run => run,
					rst => rst,
					clk => clk100,
					busy => 1,
					ram_initialized => ram_initialized,
					samp_ram_addr => samp_ram_addr,
					samp_ram_wea => samp_ram_wea,
					data_ready => data_ready,
					rc => rc);
					
stim_proc : process
	begin
	wait for clk100_period;
	busy <= '1';
	ram_initialized <= '1';
	rst <= '1';
	wait for clk100_period;
	rst <= '0';
	wait for clk100_period;
	run <= '1';
	wait for clk100_period;
	run <= '0';
	wait for 50 ns;
	rst <= '1';
	wait for 10 ns;
	rst <= '0';
	ram_initialized <= '0';
	wait for 10 ns;
	run <= '1';
	wait for 10 ns;
	run <= '0';
	wait;
end process;


end Behavioral;
