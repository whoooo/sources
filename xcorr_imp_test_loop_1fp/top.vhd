-- used for newer version of looping control logic- xcorr_ctrl, which combined functionality from multiple modules
-- single fingerprint implementation which loops until threshold is surpassed, then sends data

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top is
    port(   clk         : in std_logic;
            adc_din     : in std_logic_vector(15 downto 0);
            busy        : in std_logic;
            uart_in     : in std_logic;
            uart_out	: out std_logic;
            led         : out std_logic;
			rc 			: out std_logic);  
end top;

architecture behavioral of top is

constant samp_ram_addr_length_c    : natural := 13;
constant samp_f_ram_addr_length_c  : natural := 13;
constant adc_samp_rate_c           : natural := 40;
constant mux_data_width_c          : natural := 16;

-- vio signals
signal scaling_sch : std_logic_vector(13 downto 0) := x"2AAB";
signal threshold : std_logic_vector(31 downto 0) := x"00004000";
-- reset signals
signal fft_rst : std_logic := '1';
signal rst : std_logic := '0';

--uart signals
signal tx_ready, rxbyte_ready, tx_finished : std_logic := '0';
signal uart_tx_start, uart_tx_done : std_logic := '0';
signal rxbyte : std_logic_vector(7 downto 0) := x"00"; 

-- sample memory (adc in)
signal samp_ram_wea : std_logic_vector(0 downto 0) := "0";
signal samp_ram_addra, samp_ram_addrb : std_logic_vector(samp_ram_addr_length_c - 1 downto 0) := (others => '0'); 

-- sample memory f 
signal samp_f_ram_wea : std_logic_vector(0 downto 0) := "0";
signal samp_f_ram_addra, samp_f_ram_addrb : std_logic_vector(samp_ram_addr_length_c - 1 downto 0) := (others => '0'); 
signal adc_data_f : std_logic_vector(31 downto 0) := (others => '0');

-- fingerprint memory
signal fingerprint : std_logic_vector(31 downto 0) := (others => '0');
signal fp_ram_addrb : std_logic_vector(samp_f_ram_addr_length_c - 1 downto 0) := (others => '0');

-- xcorr memory                  
signal xcorr_ram_wea : std_logic_vector(0 downto 0) := "0";        
signal xcorr_ram_addra, xcorr_ram_addrb : std_logic_vector(samp_f_ram_addr_length_c - 1 downto 0) := (others => '0');
 
--mux signals
signal adc_data_mux : std_logic_vector(15 downto 0) := (others => '0');
signal adc_dout : std_logic_vector(15 downto 0) := (others => '0');

signal mult_tready, mult_a_tlast, mult_a_tvalid, mult_b_tvalid : std_logic := '0';

signal threshold_check, threshold_detected : std_logic := '0';

signal n_fft : natural range 0 to 8192 := 0;

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


begin

vio : entity work.vio_0
    PORT MAP (      clk => clk,
                    probe_out0 => scaling_sch,
                    probe_out1 => threshold);

uartRX : entity work.uart_rx
	generic map(    clk_counts_per_bit  => 868)
	port map(	    clk => clk,
                    rxdata_in => uart_in,		
                    rxbyte_out => rxbyte,
                    rxbyte_ready => rxbyte_ready);	           

control : entity work.xcorr_ctrl 
    generic map(    clk_rate                => 100,
                    samp_ram_addr_length    => samp_ram_addr_length_c,
                    samp_f_ram_addr_length  => samp_f_ram_addr_length_c,
                    adc_samp_rate           => adc_samp_rate_c,
                    mux_data_width          => mux_data_width_c)
	Port map(       
                    clk 			        => clk,
                    scaling_sch 	        => scaling_sch,
                    threshold               => threshold,
                    n_fft_out               => n_fft,
                    fft_rst	                => fft_rst,
                    rst_out                 => rst,
                    led		                => led,
                    -- adc ports
                    busy                    => busy,
                    rc                      => rc,
                    -- sample ram ports
                    samp_ram_wea            => samp_ram_wea,
                    samp_ram_addra          => samp_ram_addra,
                    samp_ram_addrb          => samp_ram_addrb,
                    -- mux ports for zero padding
                    mux_in1                 => adc_dout,
                    mux_in2                 => (others => '0'),
                    mux_out                 => adc_data_mux,        
                    -- fft signals
                    s_axis_config_tdata_f   => s_axis_config_tdata_f,
                    s_axis_config_tvalid_f  => s_axis_config_tvalid_f,
                    s_axis_config_tready_f  => s_axis_config_tready_f,
                    s_axis_data_tvalid_f 	=> s_axis_data_tvalid_f,
                    s_axis_data_tready_f	=> s_axis_data_tready_f,
                    s_axis_data_tlast_f		=> s_axis_data_tlast_f,
                    m_axis_data_tvalid_f 	=> m_axis_data_tvalid_f,
                    m_axis_data_tready_f	=> m_axis_data_tready_f,
                    m_axis_data_tlast_f	    => m_axis_data_tlast_f,
                    -- transformed sample memory
                    samp_f_ram_wea          => samp_f_ram_wea,
                    samp_f_ram_addra        => samp_f_ram_addra,
                    samp_f_ram_addrb        => samp_f_ram_addrb,   
                    -- fingerprint memory
                    fp_ram_addrb            => fp_ram_addrb,
                    -- cmplx mult signals
                    mult_tready             => mult_tready,
                    mult_a_tlast            => mult_a_tlast,
                    mult_a_tvalid           => mult_a_tvalid,
                    mult_b_tvalid           => mult_b_tvalid,
                    -- ifft signals
                    s_axis_config_tdata_r   => s_axis_config_tdata_r,
                    s_axis_config_tvalid_r  => s_axis_config_tvalid_r,
                    s_axis_config_tready_r  => s_axis_config_tready_r,
                    m_axis_data_tvalid_r 	=> m_axis_data_tvalid_r,
                    m_axis_data_tready_r	=> m_axis_data_tready_r,
                    m_axis_data_tlast_r 	=> m_axis_data_tlast_r,
                    -- xcorr mem
                    xcorr_ram_wea           => xcorr_ram_wea,         
                    xcorr_ram_addra         => xcorr_ram_addra,
                    xcorr_ram_addrb         => xcorr_ram_addrb,
                    -- threshold signals
                    threshold_check         => threshold_check,
                    threshold_detected      => threshold_detected,       
                    -- uart rx signals
                    rxbyte_ready            => rxbyte_ready,
                    rxbyte_in               => rxbyte,
                    -- uart tx signals
                    tx_start                => uart_tx_start,
                    tx_finished             => uart_tx_done);
                    
mem_samp0 : entity work.mem_samp
  PORT map(         clka => clk,
                    wea => samp_ram_wea,
                    addra => samp_ram_addra,
                    dina => adc_din,
                    clkb => clk,
                    addrb => samp_ram_addrb,
                    doutb => adc_dout);                
                    
samp_fft1 : entity work.fft_fwd
	PORT MAP(	    aclk => clk,
                    aresetn => fft_rst,
                    s_axis_config_tdata         => s_axis_config_tdata_f,
                    s_axis_config_tvalid        => s_axis_config_tvalid_f,
                    s_axis_config_tready        => s_axis_config_tready_f,
                    s_axis_data_tdata(31 downto 16) => (others => '0'),
                    s_axis_data_tdata(15 downto 0) => adc_data_mux,
                    s_axis_data_tvalid          => s_axis_data_tvalid_f,
                    s_axis_data_tready          => s_axis_data_tready_f,
                    s_axis_data_tlast           => s_axis_data_tlast_f,
                    m_axis_data_tdata           => m_axis_data_tdata_f,
                    m_axis_data_tvalid          => m_axis_data_tvalid_f,
                    m_axis_data_tready          => m_axis_data_tready_f,
                    m_axis_data_tlast           => m_axis_data_tlast_f,
                    event_frame_started         => event_frame_started_f,
                    event_tlast_unexpected      => event_tlast_unexpected_f,
                    event_tlast_missing         => event_tlast_missing_f,
                    event_status_channel_halt   => event_status_channel_halt_f,
                    event_data_in_channel_halt  => event_data_in_channel_halt_f,
                    event_data_out_channel_halt => event_data_out_channel_halt_f);       

mem_samp_f_0 : entity work.mem_samp_f
    PORT MAP (      clka => clk,
                    wea => samp_f_ram_wea,
                    addra => samp_f_ram_addra,
                    dina => m_axis_data_tdata_f,
                    clkb => clk,
                    addrb => samp_f_ram_addrb,
                    doutb => adc_data_f);   
                    
mem_fp_ram_0 : entity work.mem_fp
    PORT MAP (      clka => clk,
                    wea => "0",
                    addra => (others => '0'),
                    dina => (others => '0'),
                    clkb => clk,
                    addrb => fp_ram_addrb,
                    doutb => fingerprint);

cmplx_mult : entity work.cmpy_0
  PORT MAP (        aclk => clk,
                    aresetn => rst,
                    s_axis_a_tvalid => mult_a_tvalid,
                    s_axis_a_tready => mult_tready,
                    s_axis_a_tlast => mult_a_tlast,
                    s_axis_a_tdata => adc_data_f,
                    s_axis_b_tvalid => mult_b_tvalid,
                    s_axis_b_tready => open,
                    s_axis_b_tdata => fingerprint,
                    m_axis_dout_tvalid => s_axis_data_tvalid_r,
                    m_axis_dout_tready => s_axis_data_tready_r,
                    m_axis_dout_tlast => s_axis_data_tlast_r,
                    m_axis_dout_tdata => s_axis_data_tdata_r);   

ifft1 : entity work.fft_rev
	  PORT MAP (    aclk => clk,
                    aresetn => fft_rst,
                    s_axis_config_tdata => s_axis_config_tdata_r,
                    s_axis_config_tvalid => s_axis_config_tvalid_r,
                    s_axis_config_tready => s_axis_config_tready_r,
                    s_axis_data_tdata => s_axis_data_tdata_r,
                    s_axis_data_tvalid => s_axis_data_tvalid_r,
                    s_axis_data_tready => s_axis_data_tready_r,
                    s_axis_data_tlast => s_axis_data_tlast_r,
                    m_axis_data_tdata => xcorr,
                    m_axis_data_tvalid => m_axis_data_tvalid_r,
                    m_axis_data_tready => m_axis_data_tready_r,
                    m_axis_data_tlast => m_axis_data_tlast_r,
                    event_frame_started => event_frame_started_r,
                    event_tlast_unexpected => event_tlast_unexpected_r,
                    event_tlast_missing => event_tlast_missing_r,
                    event_status_channel_halt => event_status_channel_halt_r,
                    event_data_in_channel_halt => event_data_in_channel_halt_r,
                    event_data_out_channel_halt => event_data_out_channel_halt_r);   

mem_xcorr_0 : entity work.mem_xcorr
        PORT MAP (  clka => clk,
                    wea => xcorr_ram_wea,
                    addra => xcorr_ram_addra,
                    dina => xcorr,
                    clkb => clk,
                    addrb => xcorr_ram_addrb,
                    doutb => xcorr_out);
                    
threshold_detector : entity work.threshold_detect 
	port map(       clk => clk,
                    rst => rst,
                    data_tvalid => threshold_check,
                    threshold => threshold,
                    xcorr_in => xcorr(31 downto 0),
                    flag => threshold_detected);
                    
ram2uart : entity work.ram_to_uart_v2
        generic map(addr_width => 14)
        port map(	clk => clk,
                    rst => rst,
                    start => uart_tx_start,
                    txfinished => tx_finished,
                    max_addr => n_fft, 
                    done => uart_tx_done,   
                    addr_out => xcorr_ram_addrb,
                    tx_ready => tx_ready);

uartTX1 : entity work.uart_tx_generic
        generic map(clock_counts_per_bit => 868,
                    n_bytes => 8)
        port map(	data_in => xcorr_out,		
                    byte_in_flag => tx_ready, 			
                    clk => clk,					
                    txfinished => tx_finished,			
                    txdata_out => uart_out);                    
                    
end behavioral;
                    