library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fft_control_samp_sim is
end fft_control_samp_sim;

architecture Behavioral of fft_control_samp_sim is


constant clk100_period : time := 10 ns;
signal clk100, data_ready, rst, fwd, zp, fft_finished, fft_rst, s_axis_config_tvalid, s_axis_config_tready, s_axis_data_tvalid, s_axis_data_tready, s_axis_data_tlast, m_axis_data_tvalid, m_axis_data_tready, m_axis_data_tlast : std_logic := '0';
signal scaling_sch : std_logic_vector(15 downto 0) := (others => '0');
signal samp_ram_addr : std_logic_vector(11 downto 0) := (others => '0');
signal fft_ram_addr : std_logic_vector(14 downto 0) := (others => '0');
signal fft_ram_wea : std_logic_vector(0 downto 0) := "0";
signal s_axis_config_tdata : std_logic_vector(31 downto 0) := (others => '0');

begin

clk100_process : process
	begin
	 	clk100 <= '0';
	 	wait for clk100_period/2;
	 	clk100 <= '1';
	 	wait for clk100_period/2;
end process;

uut : entity work.fft_control
	Port map(  	n_fft			=> 2048,
				n_samples 		=> 1024,
				data_ready		=> data_ready,
				rst 			=> rst,
				clk 			=> clk100,
				scaling_sch 	=> scaling_sch,
				fwd				=> fwd,
				zp				=> zp,
				fft_finished	=> fft_finished,
				fft_rst			=> fft_rst,
				samp_ram_addr	=> samp_ram_addr,
				fft_ram_addr	=> fft_ram_addr,
				fft_ram_wea		=> fft_ram_wea,
		s_axis_config_tdata 	=> s_axis_config_tdata,
		s_axis_config_tvalid 	=> s_axis_config_tvalid,
		s_axis_config_tready 	=> s_axis_config_tready,
		s_axis_data_tvalid 		=> s_axis_data_tvalid,
		s_axis_data_tready 		=> s_axis_data_tready,
		s_axis_data_tlast 		=> s_axis_data_tlast,
		m_axis_data_tvalid 		=> m_axis_data_tvalid,
		m_axis_data_tready 		=> m_axis_data_tready,
		m_axis_data_tlast 		=> m_axis_data_tlast
		);     	
					
stim_proc : process
	begin
	wait for clk100_period;
		rst <= '1';
	wait for clk100_period;
		rst <= '0';
	wait for clk100_period;
		s_axis_config_tready <= '1';
		s_axis_data_tready <= '1';
		m_axis_data_tvalid <= '1';
	wait for clk100_period;
		data_ready <= '1';
	wait for 10 ns;
		data_ready <= '0';
	wait for 20 us;
		m_axis_data_tvalid <= '1';
	wait for 10.715 us;
		m_axis_data_tlast <= '1';
	wait for 10 ns;
		m_axis_data_tlast <= '0';
		m_axis_data_tvalid <= '0';
	wait for 50 ns;
	wait;
end process;


end Behavioral;
