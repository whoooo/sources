-- used for newer version of looping control logic- xcorr_ctrl, which combined functionality from multiple modules
-- single fingerprint implementation which loops until threshold is surpassed, then sends data

-- v2: includes changes due to fixes in xcorr_ctrl_v2. 20fp uses different mem than top_V2

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_20fp is
    port(   clk         : in std_logic;
            din         : in std_logic_vector(15 downto 0);
            busy        : in std_logic;
            uart_in     : in std_logic;
            sw          : in std_logic_vector(15 downto 0);
            uart_out	: out std_logic;
            led         : out std_logic_vector(15 downto 0);
			rc 			: out std_logic);  
end top_20fp;

architecture behavioral of top_20fp is

constant fp_ram_addr_length_c      : natural := 17;
constant samp_ram_addr_length_c    : natural := 13;
constant samp_f_ram_addr_length_c  : natural := 13;
constant adc_samp_rate_c           : natural := 48;
constant mux_data_width_c          : natural := 16;

-- vio signals
signal scaling_sch : std_logic_vector(13 downto 0) := "10101010101011";
signal threshold : std_logic_vector(31 downto 0) := x"00004000";

-- reset signals
signal fft_rst : std_logic := '1';
signal rst : std_logic := '0';

--uart signals
signal tx_ready, rxbyte_ready, tx_finished : std_logic := '0';
signal uart_tx_start, uart_tx_done : std_logic := '0';
signal rxbyte : std_logic_vector(7 downto 0) := x"00"; 

signal state_fuckit : natural range 0 to 3 := 0;

-- adc memory muxing
signal samp_ram_flag : std_logic := '0';

-- sample memory (adc in)
signal samp_overlap_quarters : natural range 0 to 3 := 1;
signal samp_ram0_wea, samp_ram1_wea : std_logic_vector(0 downto 0) := "0";
signal samp_ram0_addra, samp_ram1_addra, samp_ram0_addrb, samp_ram1_addrb : std_logic_vector(samp_ram_addr_length_c - 1 downto 0) := (others => '0'); 

-- sample memory f 
signal samp_f_ram_wea : std_logic_vector(0 downto 0) := "0";
signal samp_f_ram_addra, samp_f_ram_addrb : std_logic_vector(samp_ram_addr_length_c - 1 downto 0) := (others => '0'); 
signal adc_data_f : std_logic_vector(31 downto 0) := (others => '0');
signal adc_mux_mem_data : std_logic_vector(mux_data_width_c - 1 downto 0) := (others => '0');

-- fingerprint memory
signal fingerprint : std_logic_vector(31 downto 0) := (others => '0');
signal fp_ram_addrb : std_logic_vector(fp_ram_addr_length_c - 1 downto 0) := (others => '0');

-- xcorr memory                  
signal xcorr_ram_wea : std_logic_vector(0 downto 0) := "0";        
signal xcorr_ram_addra, xcorr_ram_addrb : std_logic_vector(samp_f_ram_addr_length_c - 1 downto 0) := (others => '0');
 
--mux signals
signal adc_data_mux : std_logic_vector(15 downto 0) := (others => '0');
signal adc_dout0, adc_dout1 : std_logic_vector(15 downto 0) := (others => '0');

-- multiplier signals
signal mult_tready, mult_a_tlast, mult_a_tvalid, mult_b_tvalid : std_logic := '0';

signal threshold_check, threshold_detected : std_logic := '0';
signal n_fft : natural range 0 to 8192 := 0;
signal led_s : std_logic := '0';

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

-- results
signal n_detections, n_detections_total : std_logic_vector(15 downto 0) := (others => '0');
signal fp_match_index : std_logic_vector(31 downto 0) := (others => '0');
signal clk_run_counts : natural range 0 to 2147483646 := 0;
signal adc_run_counts : natural range 0 to 2147483646 := 0;

signal scaling_sw : std_logic_vector(5 downto 0) := (others => '0');

signal run_out : std_logic := '0';
signal state_loop_out : natural range 0 to 5 := 0;
signal adc_finished_out : std_logic := '0';
signal state_counts : natural range 0 to 5 := 0;


attribute keep : string;
attribute keep of led_s								: signal is "true";
attribute keep of fft_rst					    	: signal is "true";
attribute keep of rst								: signal is "true";
attribute keep of samp_ram0_wea				    	: signal is "true";
attribute keep of samp_ram1_wea				    	: signal is "true";
--attribute keep of run								: signal is "true";
attribute keep of n_detections					    : signal is "true";
attribute keep of n_detections_total			    : signal is "true";
attribute keep of fp_match_index					: signal is "true";
attribute keep of samp_ram0_addra					: signal is "true";
attribute keep of samp_ram1_addra					: signal is "true";
attribute keep of samp_ram0_addrb					: signal is "true";
attribute keep of samp_ram1_addrb					: signal is "true";
attribute keep of samp_f_ram_wea				   	: signal is "true";
attribute keep of samp_f_ram_addra					: signal is "true";
attribute keep of samp_f_ram_addrb					: signal is "true";
attribute keep of fp_ram_addrb				    	: signal is "true";
attribute keep of xcorr_ram_addra				   	: signal is "true";
attribute keep of xcorr_ram_addrb					: signal is "true";
attribute keep of xcorr_ram_wea 					: signal is "true";
attribute keep of mult_a_tlast			    	   	: signal is "true";
attribute keep of mult_a_tvalid			    		: signal is "true";
attribute keep of mult_b_tvalid			    		: signal is "true";
attribute keep of mult_tready			    	   	: signal is "true";
attribute keep of threshold_check      				: signal is "true";
attribute keep of threshold_detected				: signal is "true";
attribute keep of uart_tx_start						: signal is "true";
attribute keep of tx_finished						: signal is "true";
attribute keep of uart_tx_done						: signal is "true";
--attribute keep of thresh_flag						: signal is "true";
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
attribute keep of state_loop_out            		: signal is "true";	
attribute keep of clk_run_counts            		: signal is "true";	
attribute keep of adc_run_counts            		: signal is "true";
attribute keep of adc_finished_out            		: signal is "true";	
	



begin



scaling_sch <= "10101010101011";
led(15) <= run_out;
led(14) <= rst;

counts : process(clk, rst)
begin
    if rst = '1' then
        clk_run_counts <= 0;
        adc_run_counts <= 0;
        state_counts <= 0;
    elsif rising_edge(clk) then
        if state_counts = 0 then
            clk_run_counts <= 0;
            adc_run_counts <= 0;          
            if run_out = '1' then
                state_counts <= 1;
            else
                state_counts <= 0;
            end if;
        elsif state_counts = 1 then
            adc_run_counts <= adc_run_counts + 1;
            if adc_finished_out = '1' then
                state_counts <= 2;
            else
                state_counts <= 1;
            end if;
        elsif state_counts = 2 then
            clk_run_counts <= clk_run_counts + 1;
            if state_loop_out = 6 then
                state_counts <= 3;
            else
                state_counts <= 2;
            end if;
        elsif state_counts = 3 then
            null;
        end if;
    end if;
end process;
            
        


-- use switch to control what's shown on led and amount of overlap (1/2-1/4)
process(sw, clk)
begin
    if rising_edge(clk) then
        if sw(0) = '1' then
            led(12 downto 0) <= n_detections_total(12 downto 0);
            -- led <= n_detections_total;
        else
            led(12 downto 0) <= n_detections(12 downto 0);
            -- led <= n_detections;
        end if;
        
        if sw(1) = '1' then
            samp_overlap_quarters <= 2;
        else
            samp_overlap_quarters <= 1;
        end if;
         
        case sw(15 downto 11) is
            when "00000" => threshold <= std_logic_vector(to_unsigned(8000, 32));
            when "00001" => threshold <= std_logic_vector(to_unsigned(9000, 32));
            when "00010" => threshold <= std_logic_vector(to_unsigned(10000, 32));
            when "00011" => threshold <= std_logic_vector(to_unsigned(11000, 32));
            when "00100" => threshold <= std_logic_vector(to_unsigned(12000, 32));
            when "00101" => threshold <= std_logic_vector(to_unsigned(13000, 32));
            when "00110" => threshold <= std_logic_vector(to_unsigned(14000, 32));
            when "00111" => threshold <= std_logic_vector(to_unsigned(15000, 32));
            when "01000" => threshold <= std_logic_vector(to_unsigned(16000, 32));
            when "01001" => threshold <= std_logic_vector(to_unsigned(17000, 32));
            when "01010" => threshold <= std_logic_vector(to_unsigned(18000, 32));
            when "01011" => threshold <= std_logic_vector(to_unsigned(19000, 32));
            when "01100" => threshold <= std_logic_vector(to_unsigned(20000, 32));
            when "01101" => threshold <= std_logic_vector(to_unsigned(21000, 32));
            when "01110" => threshold <= std_logic_vector(to_unsigned(22000, 32));
            when "01111" => threshold <= std_logic_vector(to_unsigned(23000, 32));
            when "10000" => threshold <= std_logic_vector(to_unsigned(24000, 32));
            when "10001" => threshold <= std_logic_vector(to_unsigned(25000, 32));
            when "10010" => threshold <= std_logic_vector(to_unsigned(26000, 32));
            when "10011" => threshold <= std_logic_vector(to_unsigned(27000, 32));
            when "10100" => threshold <= std_logic_vector(to_unsigned(28000, 32));
            when "10101" => threshold <= std_logic_vector(to_unsigned(29000, 32));
            when "10110" => threshold <= std_logic_vector(to_unsigned(30000, 32));
            when "10111" => threshold <= std_logic_vector(to_unsigned(31000, 32));
            when "11000" => threshold <= std_logic_vector(to_unsigned(32000, 32));
            when "11001" => threshold <= std_logic_vector(to_unsigned(33000, 32));
            when "11010" => threshold <= std_logic_vector(to_unsigned(34000, 32));
            when "11011" => threshold <= std_logic_vector(to_unsigned(35000, 32));
            when "11100" => threshold <= std_logic_vector(to_unsigned(36000, 32));
            when "11101" => threshold <= std_logic_vector(to_unsigned(37000, 32));
            when "11110" => threshold <= std_logic_vector(to_unsigned(38000, 32));
            when "11111" => threshold <= std_logic_vector(to_unsigned(39000, 32));
            when others => threshold <= std_logic_vector(to_unsigned(14000, 32));
        end case;        
    end if;   
end process;

process(clk)
begin
    if rising_edge(clk) then
        if sw(4) = '1' then
            if (sw(3) = '1') and (sw(2) = '0') then
                if state_fuckit = 0 then
                    rxbyte <= "10100110"; 
                    rxbyte_ready <= '1';
                    state_fuckit <= 1;
                elsif state_fuckit = 1 then
                    rxbyte_ready <= '0';
                end if;
            elsif (sw(3) = '0') and (sw(2) = '0') then
                if state_fuckit = 0 then
                    rxbyte <= "00100110";
                    rxbyte_ready <= '1';
                    state_fuckit <= 1;
                elsif state_fuckit = 1 then
                    rxbyte_ready <= '0';
                end if;
            elsif (sw(3) = '0') and (sw(2) = '1') then
               if state_fuckit = 0 then
                    rxbyte <= "01100110";
                    rxbyte_ready <= '1';
                    state_fuckit <= 1;
                elsif state_fuckit = 1 then
                    rxbyte_ready <= '0';
                end if; 
            end if;
        else
            state_fuckit <= 0;
        end if;
    end if;
end process;
            
                
            


-- *** set overlap with switch

-- vio : entity work.vio_0
    -- PORT MAP (      clk => clk,
                    -- probe_out0 => scaling_sch,
                    -- probe_out1 => open);

uartRX : entity work.uart_rx
	generic map(    clk_counts_per_bit  => 868)
	port map(	    clk => clk,
                    rxdata_in => uart_in,		
                    rxbyte_out => open,
                    rxbyte_ready => open);	           

control : entity work.xcorr_ctrl_v2 
    generic map(    clk_rate                => 100,
                    fp_ram_addr_length      => fp_ram_addr_length_c,
                    samp_ram_addr_length    => samp_ram_addr_length_c,
                    samp_f_ram_addr_length  => samp_f_ram_addr_length_c,
                    adc_samp_rate           => adc_samp_rate_c,
                    mux_data_width          => mux_data_width_c,
                    n_fingerprints			=> 19) -- actual number -1
	Port map(       
                    clk 			        => clk,
                    scaling_sch 	        => scaling_sch,
                    threshold               => threshold,
                    n_fft_out               => n_fft,
                    fft_rst	                => fft_rst,
                    rst_out                 => rst,
                    run_out                 => run_out,
                    state_loop_out          => state_loop_out,
                    adc_finished_out        => adc_finished_out,
                    -- led		                => led_s,
                    -- adc ports
                    busy                    => busy,
                    rc                      => rc,
                    -- adc memory mux
                    samp_ram_flag           => samp_ram_flag,
                    -- sample ram ports
					samp_overlap_quarters	=> samp_overlap_quarters,
                    samp_ram0_wea           => samp_ram0_wea,
                    samp_ram1_wea           => samp_ram1_wea,
                    samp_ram0_addra         => samp_ram0_addra,
                    samp_ram0_addrb         => samp_ram0_addrb,
                    samp_ram1_addra         => samp_ram1_addra,
                    samp_ram1_addrb         => samp_ram1_addrb,					
                    -- mux ports for zero padding
                    mux_in1                 => adc_mux_mem_data,
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
                    -- data to send over uart
                    n_detections            => n_detections,
                    n_detections_total      => n_detections_total,
                    fp_match_index          => fp_match_index,
                    -- uart rx signals
                    rxbyte_ready            => rxbyte_ready,
                    rxbyte_in               => rxbyte,
                    -- uart tx signals
                    tx_start                => uart_tx_start,
                    tx_finished             => uart_tx_done);
                    
mem_samp0 : entity work.mem_samp
  PORT map(         clka => clk,
                    wea => samp_ram0_wea,
                    addra => samp_ram0_addra,
                    dina => din,
                    clkb => clk,
                    addrb => samp_ram0_addrb,
                    doutb => adc_dout0);  

mem_samp1 : entity work.mem_samp
  PORT map(         clka => clk,
                    wea => samp_ram1_wea,
                    addra => samp_ram1_addra,
                    dina => din,
                    clkb => clk,
                    addrb => samp_ram1_addrb,
                    doutb => adc_dout1);    

mux : entity work.mux_2to1
    generic map (   data_width  => 16)    
	port map    (   clk         => clk,
                    i1          => adc_dout0,
                    i2          => adc_dout1,
                    control     => not samp_ram_flag,
                    o           => adc_mux_mem_data);
                    
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
                    
-- mem_fp_ram_0 : entity work.mem_fp
    -- PORT MAP (      clka => clk,
                    -- wea => "0",
                    -- addra => (others => '0'),
                    -- dina => (others => '0'),
                    -- clkb => clk,
                    -- addrb => fp_ram_addrb,
                    -- doutb => fingerprint);
                    
mem_fp20_0 : entity work.mem_20fp
    PORT MAP (      clka => clk,
                    wea => "0",
                    addra => (others => '0'),
                    dina => (others => '0'),
                    clkb => clk,
                    addrb => fp_ram_addrb,
                    doutb => fingerprint);                    

cmplx_mult : entity work.cmpy_0
  PORT MAP (        aclk => clk,
                    aresetn => not rst,
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
                    
-- ram2uart : entity work.ram_to_uart_v2
        -- generic map(addr_width => 13)
        -- port map(	clk => clk,
                    -- rst => rst,
                    -- start => uart_tx_start,
                    -- txfinished => tx_finished,
                    -- max_addr => n_fft, 
                    -- done => uart_tx_done,   
                    -- addr_out => xcorr_ram_addrb,
                    -- tx_ready => tx_ready);
					

uartTX1 : entity work.uart_tx_generic
        generic map(clock_counts_per_bit => 868,
                    n_bytes => 8)
        port map(	data_in => n_detections & n_detections_total & fp_match_index,		
                    byte_in_flag => uart_tx_start, 			
                    clk => clk,					
                    txfinished => uart_tx_done,			
                    txdata_out => uart_out);                    
                    
end behavioral;
                    