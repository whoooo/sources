library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
    Port (	clk			: in std_logic;
			din			: in std_logic_vector(15 downto 0);
			busy 		: in std_logic;
			uart_in		: in std_logic;
			uart_out	: out std_logic;
			rc 			: out std_logic);
end top;

architecture Behavioral of top is

-- uart 
signal txbyte_ready, rxbyte_ready, txfinished : std_logic := '0';
signal rxbyte : std_logic_vector(7 downto 0) := x"00";
--signal uart_data : std_logic_vector(63 downto 0) := (others => '0');
signal ifft_finished : std_logic := '0';

-- ad976 control signals
signal run_adc, rst : std_logic := '0';
signal n_fft, n_samples : natural range 1024 to 32768 := 4096;
signal ram_initialized : std_logic := '0';
signal samp_data_ready : std_logic := '0';

-- sample ram signals
signal samp_ram_addra, samp_ram_addrb : std_logic_vector(11 downto 0) := x"000";
signal samp_ram_wea : std_logic_vector(0 downto 0) := "0";

-- mux for zero padding
signal samp_data : std_logic_vector(15 downto 0) := x"0000";
signal samp_data_mux : std_logic_vector(15 downto 0) := x"0000";
signal zp : std_logic := '0';

-- fingerprint ram and complex multiplier control signals
signal fp_ram_addra, fp_addrb : std_logic_vector(12 downto 0) := (others => '0');
signal fp_wea : std_logic_vector(0 downto 0) := "0";
signal fp_tvalid, fp_tready : std_logic := '0';
signal fp_tdata : std_logic_vector(31 downto 0) := (others => '0');

-- misc fft signals
signal scaling_sch : std_logic_vector(13 downto 0) := (others => '0');
signal fft_rst : std_logic := '1';

-- fwd fft signals
signal s_axis_config_tdata_f : std_logic_vector(23 downto 0) := (others => '0');
signal s_axis_config_tvalid_f : std_logic := '0';
signal s_axis_config_tready_f : std_logic := '0';
signal s_axis_data_tvalid_f : std_logic := '0';	
signal s_axis_data_tready_f : std_logic := '0';	
signal s_axis_data_tlast_f : std_logic := '0';	
signal m_axis_data_tdata_f : std_logic_vector(31 downto 0) := (others => '0');
signal m_axis_data_tvalid_f : std_logic := '0';	
signal m_axis_data_tready_f : std_logic := '0';	
signal m_axis_data_tlast_f : std_logic := '0';
signal event_frame_started_f : std_logic := '0';	
signal event_tlast_unexpected_f : std_logic := '0';	
signal event_tlast_missing_f : std_logic := '0';	
signal event_status_channel_halt_f: std_logic := '0';	
signal event_data_in_channel_halt_f : std_logic := '0';	
signal event_data_out_channel_halt_f : std_logic := '0';

-- ifft signals
signal s_axis_config_tdata_r : std_logic_vector(23 downto 0) := (others => '0');
signal s_axis_config_tvalid_r : std_logic := '0';
signal s_axis_config_tready_r : std_logic := '0';
signal s_axis_data_tdata_r : std_logic_vector(63 downto 0) := (others => '0');
signal s_axis_data_tvalid_r : std_logic := '0';	
signal s_axis_data_tready_r : std_logic := '0';	
signal s_axis_data_tlast_r : std_logic := '0';	
signal m_axis_data_tvalid_r : std_logic := '0';	
signal m_axis_data_tready_r : std_logic := '0';	
signal m_axis_data_tlast_r : std_logic := '0';	
signal event_frame_started_r : std_logic := '0';	
signal event_tlast_unexpected_r : std_logic := '0';	
signal event_tlast_missing_r : std_logic := '0';	
signal event_status_channel_halt_r: std_logic := '0';	
signal event_data_in_channel_halt_r : std_logic := '0';	
signal event_data_out_channel_halt_r : std_logic := '0';

signal xcorr, xcorr_out : std_logic_vector(63 downto 0) := (others => '0');

-- output ram for correlation values
signal corr_ram_addra, corr_ram_addrb : std_logic_vector(14 downto 0) := (others => '0');
signal corr_ram_wea : std_logic_vector(0 downto 0) := "0";
signal corr_data : std_logic_vector(31 downto 0) := (others => '0');
signal done : std_logic := '0';


attribute keep : string;
attribute keep of event_frame_started_r 			: signal is "true";
attribute keep of event_tlast_unexpected_r 			: signal is "true";	
attribute keep of event_tlast_missing_r 			: signal is "true";
attribute keep of event_status_channel_halt_r		: signal is "true";	
attribute keep of event_data_in_channel_halt_r		: signal is "true";
attribute keep of event_data_out_channel_halt_r 	: signal is "true";	
attribute keep of event_frame_started_f				: signal is "true";	
attribute keep of event_tlast_unexpected_f 			: signal is "true";	
attribute keep of event_tlast_missing_f				: signal is "true";	
attribute keep of event_status_channel_halt_f		: signal is "true";		
attribute keep of event_data_in_channel_halt_f		: signal is "true";		
attribute keep of event_data_out_channel_halt_f		: signal is "true";	

begin

--scaling_sch <= "10101010101011";

vio : entity work.vio_0
  PORT MAP (
	clk => clk,
   				probe_out0 => scaling_sch);
 
uartRX : entity work.uart_rx
	generic map(clk_counts_per_bit  => 868)
	port map(	clk => clk,
				rxdata_in => uart_in,		
				rxbyte_out => rxbyte,
				rxbyte_ready => rxbyte_ready);				
						
cmd_decode : entity work.xcorr_cmd_decode
	port map(	clk => clk,
				rxbyte_ready => rxbyte_ready,
				rxbyte_in => rxbyte,
				run => run_adc,
				rst => rst,
				n_fft => n_fft,
				n_samples => n_samples,
				ram_initialized => ram_initialized);

adc_control : entity work.ad976_control_v2
	generic map( clk_rate => 100)
	Port map( 	sample_rate => 40,
				n_samples => n_samples,
				run => run_adc,
				rst => rst,		
				clk => clk,			
				busy => busy,	
				ram_initialized => ram_initialized,
				samp_ram_addr => samp_ram_addra,
				samp_ram_wea => samp_ram_wea,
				data_ready => samp_data_ready,
				rc => rc);
					
samp_ram1 : entity work.samp_ram
	PORT MAP (	clka => clk,
				wea => samp_ram_wea,
				addra => samp_ram_addra,
				dina => din,
				clkb => clk,
				addrb => samp_ram_addrb,
				doutb => samp_data);				
					
mux21 : entity work.mux_2to1
	generic map(data_width => 16)
	port map(   clk => clk,
				i1 => samp_data,
				i2 => x"0000",
				control => zp,
				o => samp_data_mux);

fft_control1 : entity work.fft_control 
	Port map(  	n_fft => n_fft, 		
				n_samples => n_samples, 	
				data_ready => samp_data_ready,	
				rst => rst, 		
				clk => clk,  		
				scaling_sch => scaling_sch, 
				zp => zp,			
				ifft_finished => ifft_finished,
				fft_rst => fft_rst,			
				samp_ram_addrb => samp_ram_addrb,	
				ifft_ram_addra => corr_ram_addra,	
				ifft_ram_wea => corr_ram_wea,
				s_axis_config_tdata_f => s_axis_config_tdata_f,
				s_axis_config_tvalid_f => s_axis_config_tvalid_f, 	
				s_axis_config_tready_f => s_axis_config_tready_f, 	
				s_axis_data_tvalid_f => s_axis_data_tvalid_f, 	
				s_axis_data_tready_f => s_axis_data_tready_f,	
				s_axis_data_tlast_f	=> s_axis_data_tlast_f,		              
				s_axis_config_tdata_r => s_axis_config_tdata_r, 	 
				s_axis_config_tvalid_r => s_axis_config_tvalid_r, 	 
				s_axis_config_tready_r => s_axis_config_tready_r, 	 
				m_axis_data_tvalid_r => m_axis_data_tvalid_r, 	
				m_axis_data_tready_r => m_axis_data_tready_r,	
				m_axis_data_tlast_r => m_axis_data_tlast_r 	);         
	      					
samp_fft1 : entity work.samp_fft
	PORT MAP(	aclk => clk,
				aresetn => fft_rst,
				s_axis_config_tdata => s_axis_config_tdata_f,
				s_axis_config_tvalid => s_axis_config_tvalid_f,
				s_axis_config_tready => s_axis_config_tready_f,
				s_axis_data_tdata(31 downto 16) => (others => '0'),
				s_axis_data_tdata(15 downto 0) => samp_data_mux,
				s_axis_data_tvalid => s_axis_data_tvalid_f,
				s_axis_data_tready => s_axis_data_tready_f,
				s_axis_data_tlast => s_axis_data_tlast_f,
				m_axis_data_tdata => m_axis_data_tdata_f,
				m_axis_data_tvalid => m_axis_data_tvalid_f,
				m_axis_data_tready => m_axis_data_tready_f,
				m_axis_data_tlast => m_axis_data_tlast_f,
				event_frame_started => event_frame_started_f,
				event_tlast_unexpected => event_tlast_unexpected_f,
				event_tlast_missing => event_tlast_missing_f,
				event_status_channel_halt => event_status_channel_halt_f,
				event_data_in_channel_halt => event_data_in_channel_halt_f,
				event_data_out_channel_halt => event_data_out_channel_halt_f);
				
fingerprint_ram : entity work.fp_ram
	PORT MAP (
	clka => clk,
				wea => "0",
				addra => fp_ram_addra,
				dina => (others => '0'),
				douta => fp_tdata
);
				
fp_ram_ctrl : entity work.fp_ram_control 
	port map(   m_axis_data_tvalid_f => m_axis_data_tvalid_f,
				m_axis_data_tready_f => m_axis_data_tready_f,
				n_fft => n_fft,
				clk => clk,
				rst => rst,
				fp_tready => fp_tready,
				fp_tvalid => fp_tvalid,
				fp_ram_addra => fp_ram_addra);
				
complex_mult : entity work.cmpy_0
	PORT MAP(	aclk => clk,
				aresetn => fft_rst,
				s_axis_a_tvalid => m_axis_data_tvalid_f,
				s_axis_a_tready => m_axis_data_tready_f,
				s_axis_a_tlast => m_axis_data_tlast_f,
				s_axis_a_tdata => m_axis_data_tdata_f,
				s_axis_b_tvalid => fp_tvalid,
				s_axis_b_tready => fp_tready,
				s_axis_b_tdata => fp_tdata,
				m_axis_dout_tvalid => s_axis_data_tvalid_r,
				m_axis_dout_tready => s_axis_data_tready_r,
				m_axis_dout_tlast => s_axis_data_tlast_r,
				m_axis_dout_tdata => s_axis_data_tdata_r);					
					
ifft1 : entity work.ifft
	  PORT MAP (aclk => clk,
				aresetn => fft_rst,
				s_axis_config_tdata => s_axis_config_tdata_r,
				s_axis_config_tvalid => s_axis_config_tvalid_r,
				s_axis_config_tready => s_axis_config_tready_r,
				s_axis_data_tdata => s_axis_data_tdata_r,
				s_axis_data_tvalid => s_axis_data_tvalid_r,
				s_axis_data_tready => s_axis_data_tready_r,
				s_axis_data_tlast => s_axis_data_tlast_r,
				m_axis_data_tdata => xcorr,
--				m_axis_data_tdata(79 downto 73) => open,
--				m_axis_data_tdata(72 downto 41) => xcorr(63 downto 32),
--				m_axis_data_tdata(40 downto 33) => open,
--				m_axis_data_tdata(32 downto 1) => xcorr(31 downto 0),
--				m_axis_data_tdata(0) => open,
				m_axis_data_tvalid => m_axis_data_tvalid_r,
				m_axis_data_tready => m_axis_data_tready_r,
				m_axis_data_tlast => m_axis_data_tlast_r,
				event_frame_started => event_frame_started_r,
				event_tlast_unexpected => event_tlast_unexpected_r,
				event_tlast_missing => event_tlast_missing_r,
				event_status_channel_halt => event_status_channel_halt_r,
				event_data_in_channel_halt => event_data_in_channel_halt_r,
				event_data_out_channel_halt => event_data_out_channel_halt_r);
				
correlation_ram : entity work.corr_ram
		PORT MAP(clka => clk,
				wea => corr_ram_wea,
				addra => corr_ram_addra,
				dina => xcorr,
				clkb => clk,
				addrb => corr_ram_addrb,
				doutb => xcorr_out);
				  
ram2uart : entity work.ram_to_uart
	generic map(addr_width => 14)
	port map(	clk => clk,
				rst => rst,
				start => ifft_finished,
				txfinished => txfinished,
				max_addr => n_fft, 
				done => done,   
				addr_out => corr_ram_addrb,
				txbyte_ready => txbyte_ready);

-- drop lowest bit of cross correlation to fit in 8 byte chunks								
uartTX1 : entity work.uart_tx_generic
	generic map(clock_counts_per_bit => 868,
				n_bytes => 8)
	port map(	data_in => xcorr_out,
--				data_in(63 downto 32) => xcorr_out(72 downto 41),
--				data_in(31 downto 0) => xcorr_out(32 downto 1),		
				byte_in_flag => txbyte_ready, 			
				clk => clk,					
				txfinished => txfinished,			
				txdata_out => uart_out);

end Behavioral;
