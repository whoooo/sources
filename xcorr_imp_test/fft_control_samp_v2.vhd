-- Jacob Tobin
-- Module Name: fft_control - Behavioral
-- Description: sends sample data from ram to fft. reconfigurable on a frame by frame basis.
-- n_samples should be, at most, half of nfft to allow for zero padding. 
-- zero padding length = n_fft - n_samples

----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fft_control is 
	Port(  		n_fft			: in natural; -- N points for fft. 512 to 8192 in power of 2 increments
				n_samples 		: in natural; -- number of samples to read from ram
				data_ready		: in std_logic; -- incoming sample data ready
				rst 			: in std_logic;
				clk 			: in std_logic;
				scaling_sch 	: in std_logic_vector(15 downto 0);
				fwd				: in std_logic; -- 1=fwd, 0=rev
				zp				: out std_logic;
				fft_finished	: out std_logic;
				fft_rst			: out std_logic;
				samp_ram_addr	: out std_logic_vector(11 downto 0);
				fft_ram_addr	: out std_logic_vector(14 downto 0);
				fft_ram_wea		: out std_logic_vector(0 downto 0);
		s_axis_config_tdata 	: out STD_LOGIC_VECTOR(31 DOWNTO 0); -- config for fft. (24:9)=scaling schedule, (8:8) = fww/reverse, (4:0) = nfft
		s_axis_config_tvalid 	: out STD_LOGIC; -- signals that master is ready to send data to fft
		s_axis_config_tready 	: in STD_LOGIC; -- signals that fft is ready for config data
		s_axis_data_tvalid 		: out STD_LOGIC; -- signals that master is ready to send data to fft
		s_axis_data_tready 		: in STD_LOGIC; -- signals that fft is ready to receive data
		s_axis_data_tlast 		: out  STD_LOGIC; -- asserted by master on last sample being sent to fft
		m_axis_data_tvalid 		: in STD_LOGIC; -- asserted by fft to signal that it's ready to provide output data
		m_axis_data_tready 		: out STD_LOGIC; -- asserted by external unit to signal that it's ready for output data
		m_axis_data_tlast 		: in STD_LOGIC -- asserted by fft on last sample being sent out
		);         
end fft_control;

architecture Behavioral of fft_control is

signal fft_config : std_logic_vector(22 downto 0) := (others => '0');
signal samp_ram_addr_s, samp_ram_max_addr : std_logic_vector(11 downto 0) := (others => '0');
signal fft_ram_addr_s : std_logic_vector(14 downto 0) := (others => '0');
signal state : natural range 0 to 20 := 0;
signal nfft_config : std_logic_vector(4 downto 0) := "00000";
signal pad_length : natural range 1024 to 4096 := 1024;
signal pad_count : natural range 0 to 4096 := 0;

begin

	samp_ram_addr <= samp_ram_addr_s;
	fft_ram_addr <= fft_ram_addr_s;
	
	process(clk, rst)
	begin	
		if rst = '1' then
			fft_rst <= '0'; -- active low reset (2 cycles)
			samp_ram_addr_s <= (others => '0');
			fft_ram_addr_s <= (others => '0');
			fft_ram_wea <= "0";
			pad_count <= 0;
			zp <= '0';
			s_axis_config_tvalid <= '0';
			s_axis_data_tvalid <= '0';
			s_axis_data_tlast <= '0';
			m_axis_data_tready <= '0';
			fft_finished <= '0';
			state <= 0;
		elsif rising_edge(clk) then
			-- wait for data_ready to initialize config data transfer
			if state = 0 then
				fft_rst <= '1';
				fft_ram_wea <= "0";
				fft_ram_addr_s <= (others => '0');
				s_axis_config_tvalid <= '0';
				s_axis_data_tvalid <= '0';
				s_axis_data_tlast <= '0';
				m_axis_data_tready <= '0';
				fft_finished <= '0';
				pad_count <= 0;
				zp <= '0';
				samp_ram_max_addr <= std_logic_vector(to_unsigned(n_samples - 1, 12));
				pad_length <= n_fft - n_samples;
				s_axis_config_tdata(31 downto 25) <= (others => '0');
				s_axis_config_tdata(24 downto 9) <= scaling_sch;
				s_axis_config_tdata(8) <= fwd;
				s_axis_config_tdata(7 downto 5) <= "000";
				s_axis_config_tdata(4 downto 0) <= nfft_config;			
				if (data_ready = '1' and rst = '0') then
					s_axis_config_tvalid <= '1';
					state <= 1;
				else
					state <= 0;
				end if;
			-- wait for tready to go high
			elsif state = 1 then
				if s_axis_config_tready = '1' then
					state <= 2;
				else
					state <= 1;
				end if;
			elsif state = 2 then
				-- begin sending samples to fft
				s_axis_config_tvalid <= '0';
				s_axis_data_tvalid <= '1';
				if s_axis_data_tready = '1' then
					state <= 3;
					samp_ram_addr_s <= std_logic_vector(unsigned(samp_ram_addr_s) + 1);
				else
					state <= 2;
				end if;
			elsif state = 3 then
				-- continue to send samples until limit is reached, then begin zero padding
				if s_axis_data_tready = '1' then
					samp_ram_addr_s <= std_logic_vector(unsigned(samp_ram_addr_s) + 1);
					if samp_ram_addr_s =  samp_ram_max_addr then --std_logic_vector(unsigned(samp_ram_max_addr) - 1) then
						zp <= '1';
						state <= 4;
					else
						state <= 3;
					end if;
				else
					state <= 3;
				end if;
			elsif state = 4 then
				if s_axis_data_tready = '1' then
					pad_count <= pad_count + 1;
					if pad_count = (pad_length - 2) then
						s_axis_data_tlast <= '1';
						state <= 5;
					else
						state <= 4;
					end if;
				else
					state <= 4;
				end if;		
			elsif state = 5 then
				zp <= '0';
				s_axis_data_tlast <= '0';
				s_axis_data_tvalid <= '0';
				m_axis_data_tready <= '1';
				fft_ram_wea <= "1";
				state <= 6;
			elsif state = 6 then
				if m_axis_data_tvalid = '1' then
					fft_ram_wea <= "1";
					fft_ram_addr_s <= std_logic_vector(unsigned(fft_ram_addr_s) + 1);
					if m_axis_data_tlast = '1' then	
						fft_finished <= '1';
						state <= 0;
					else
						state <= 6;
					end if;
				else
					fft_ram_wea <= "0";
					state <= 6;
				end if;		
			end if;
		end if;
	end process;
					
	
	decode_n_fft : process(clk)
	begin
		if rising_edge(clk) then
			if n_fft = 512 then
				nfft_config <= "01001";
			elsif n_fft = 1024 then 
				nfft_config <= "01010";
			elsif n_fft = 2048 then 
				nfft_config <= "01011";
			elsif n_fft = 4096 then 
				nfft_config <= "01100";
			elsif n_fft = 8192 then 
				nfft_config <= "01101";
			elsif n_fft = 16384 then
				nfft_config <= "01110";
			elsif n_fft = 32768 then
				nfft_config <= "01111";
			else
				nfft_config <= "01100"; -- default state of 4096
			end if;
		end if;
	end process;
	
end behavioral;