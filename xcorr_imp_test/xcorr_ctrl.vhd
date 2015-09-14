-- Jacob Tobin
-- Module Name: fft_control - Behavioral
-- Description: get command -> run adc -> send data to fft -> zero pad half of data -> store fft data in ram...
-- -> multiply transformed data and fingerprint -> send to ifft -> store xcorr and check threshold (parallel)...
-- -> send data if thresh met, repeat
-- n_samples should be, at most, half of nfft to allow for zero padding. 
-- zero padding length = n_fft - n_samples.

----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity xcorr_ctrl is 
    generic(    clk_rate                : natural := 100; -- MHz
                samp_ram_addr_length    : natural := 13;
                adc_samp_rate           : natural := 40; --kHz
                mux_data_width          : natural := 16);
	Port(       rst 			        : in std_logic;
				clk 			        : in std_logic;
                -- control signals
                run                     : in std_logic;
                run_single_flag         : in std_logic;
                n_fft			        : in natural; -- N points for fft. 512 to 8192 in power of 2 increments
                n_samples               : in natural;
				scaling_sch 	        : in std_logic_vector(13 downto 0);
                use_adc                 : in std_logic;                
                -- adc ports
                busy                    : in std_logic;
                rc                      : out std_logic;
                -- sample ram ports
                samp_ram_wea            : out std_logic_vector(0 downto 0);
                samp_ram_addra          : out std_logic_vector(samp_ram_addr_length - 1 downto 0);
                samp_ram_addrb          : out std_logic_vector(samp_ram_addr_length - 1 downto 0);
               -- mux ports for zero padding
                mux_in1                 : in std_logic_vector(mux_data_width-1 downto 0);
                mux_in2                 : in std_logic_vector(mux_data_width-1 downto 0);
                mux_out                 : out std_logic_vector(mux_data_width-1 downto 0);
                -- fft signals
                s_axis_config_tdata_f 	: out STD_LOGIC_VECTOR(23 DOWNTO 0); -- config for fft. (22:9)=scaling schedule, (8:8) = fww/reverse, (4:0) = nfft
                s_axis_config_tvalid_f 	: out STD_LOGIC; -- signals that master is ready to send data to fft
                s_axis_config_tready_f 	: in STD_LOGIC; -- signals that fft is ready for config data
                s_axis_data_tvalid_f 	: out STD_LOGIC; -- signals that master is ready to send data to fft
                s_axis_data_tready_f	: in STD_LOGIC; -- signals that fft is ready to receive data
                s_axis_data_tlast_f		: out  STD_LOGIC; -- asserted by master on last sample being sent to fft  
                -- cmplx mult signals
                mult_a_tlast            : out std_logic;
                mult_a_tready           : in std_logic;
                mult_a_tvalid           : out std_logic;
                mult_b_tready           : in std_logic;
                mult_b_tvalid           : out std_logic;    
                -- ifft signals
                s_axis_config_tdata_r 	: out STD_LOGIC_VECTOR(23 DOWNTO 0); 
                s_axis_config_tvalid_r 	: out STD_LOGIC; 
                s_axis_config_tready_r 	: in STD_LOGIC; 
                m_axis_data_tvalid_r 	: in STD_LOGIC; -- asserted by fft to signal that it's ready to provide output data
                m_axis_data_tready_r	: out STD_LOGIC; -- asserted by fsm to alert fft that it's ready for output data
                m_axis_data_tlast_r 	: in STD_LOGIC; -- asserted by fft on last sample being sent out               
                -- xcorr mem
                xcorr_ram_wea            : out std_logic_vector(0 downto 0);
                xcorr_ram_addra          : out std_logic_vector(samp_ram_addr_length - 1 downto 0);
                xcorr_ram_addrb          : out std_logic_vector(samp_ram_addr_length - 1 downto 0);
                
                
				xcorr_finished	        : out std_logic;
				fft_rst			        : out std_logic;
				samp_ram_addrb	        : out std_logic_vector(11 downto 0);
				ifft_ram_addra	        : out std_logic_vector(14 downto 0);
				ifft_ram_wea	        : out std_logic_vector(0 downto 0);
                
                rxbyte_ready            : in std_logic;
                rxbyte_in               : in std_logic_vector(7 downto 0);

                
                led                     : out std_logic

		);         
end xcorr_ctrl;

architecture Behavioral of xcorr_ctrl is

-- loop control signals
signal state_loop : natural range 0 to 5 := 0;

-- adc and sample memory signals
signal run_adc  : std_logic := '0';
signal adc_busy : std_logic := '0'; -- 1= adc in middle of conversion, 0 = no conversion
signal adc_counts : natural range 0 to 5000 := 0;
signal adc_data_ready : std_logic:= '0';
signal adc_counts_per_sample : natural range 50 to 5000 := 0;
signal samp_ram_addra_s, samp_ram_addrb_s : std_logic_vector(samp_ram_addr_length - 1 downto 0);
signal samp_ram_max_addra, samp_ram_max_addrb : std_logic_vector(samp_ram_addr_length - 1 downto 0);
signal samp_ram_flag : std_logic := '0'; -- switches range of values to read (allows for xcorr to be performed while data is taken in)
signal state_adc : natural range 0 to 5;

-- uart cmd decode signals
signal state_cmd_decode : natural range 0 to 2 := 0;

-- fft config signals
signal state_config_fft : natural range 0 to 5 := 0;
signal run_fft_config : std_logic := '0';
signal nfft_config : std_logic_vector(4 downto 0) := "00000";

-- fft, cmplx mult, and ifft signals
signal pad_count : natural range 0 to 4096 := 0;
signal pad_length : natural range 1024 to 4096 := 1024;
signal run_xcorr : std_logic := '0';
signal scaling_sch_s : std_logic_vector(13 downto 0) := "10101010101011";
signal state_xcorr : natural range 0 to 20 := 0;
signal xcorr_busy : std_logic := '0'; -- 1= xcorr in middle of processing, 0 = xcorr not busy
signal xcorr_fft_cfg_flag : std_logic := '0';
signal xcorr_ram_addra_s, xcorr_ram_addrb_s : std_logic_vector(12 downto 0);
signal zp : std_logic := '0';

begin

    adc_counts_per_sample <= (clk_rate * 1000) / sample_rate; -- use to set sampling rate of adc from 20 to 100 kHz

    samp_ram_addra <= samp_ram_addra_s
	samp_ram_addrb <= samp_ram_addrb_s;
	xcorr_ram_addra <= xcorr_ram_addra_s;
    xcorr_ram_addrb <= xcorr_ram_addrb_s;
    
    scaling_sch_s <= scaling_sch;

    
    -- decode uart data to get commands and configs
    cmd_decode : process(clk, rst)
    begin
        if rst = '1' then
            run_fft_config <= '0';
            state_cmd_decode <= 0;         
        elsif rising_edge(clk) then
            case state_cmd_decode is
                when 0 =>
                    if rxbyte_ready = '1' then
                        run <= rxbyte_in(7);
                        rst <= rxbyte_in(6);
                        use_adc <= rxbyte_in(5);
                        run_once <= rxbyte_in(4);
                        state_cmd_decode <= 1;
                        case rxbyte_in(2 downto 0) is
                            when "000" =>
                                n_samples <= 256;
                                n_fft <= 512;
                                nfft_config <= "01001";                     
                            when "001" =>
                                n_samples <= 512;
                                n_fft <= 1024;
                                nfft_config <= "01010";
                            when "010" =>
                                n_samples <= 1024;
                                n_fft <= 2048;	
                                nfft_config <= "01011";
                            when "011" =>
                                n_samples <= 2048;
                                n_fft <= 4096;	
                                nfft_config <= "01100";
                            when "100" =>
                                n_samples <= 4096;
                                n_fft <= 8192;
                                nfft_config <= "01101";
                            when others =>
                                n_samples <= 4096;
                                n_fft <= 8192;
                                nfft_config <= "01101";
                        end case;			
                    end if;
                when 1 =>
                    run_fft_config <= '1';
                    state_cmd_decode <= 2;
                when 2 =>
                    run_fft_config <= '0';
                    state_cmd_decode <= 0;
                when others =>
                    state_cmd_decode <= 0;
            end case;
        end if;
    end process;
    
    -- configure the fft and ifft ip blocks
    config_ffts : process(clk, rst)
    begin
        if rst = '1' then
            s_axis_config_tvalid_f <= '0';
            s_axis_config_tvalid_r <= '0';
        elsif rising_edge(clk) then
            case state_config_fft is
                when 0 =>
                    s_axis_config_tvalid_f <= '0';
                    s_axis_config_tvalid_r <= '0';
                    -- fft
                    s_axis_config_tdata_f(23) <= '0';
                    s_axis_config_tdata_f(22 downto 9) <= scaling_sch;
                    s_axis_config_tdata_f(8) <= '1'; -- fwd
                    s_axis_config_tdata_f(7 downto 5) <= "000"; -- padding
                    s_axis_config_tdata_f(4 downto 0) <= nfft_config;
                    --ifft
                    s_axis_config_tdata_r(23) <= '0'; -- padding
                    s_axis_config_tdata_r(22 downto 9) <= scaling_sch;
                    s_axis_config_tdata_r(8) <= '0'; -- rev
                    s_axis_config_tdata_r(7 downto 5) <= "000"; -- padding
                    s_axis_config_tdata_r(4 downto 0) <= nfft_config;   
                    if run_fft_config = '1' then           
                        s_axis_config_tvalid_f <= '1';
                        s_axis_config_tvalid_r <= '1';  
                        state_config_fft <= 1;
                    else
                        state_config_fft <= 0;
                    end if;
                when 1 =>
                 	if s_axis_config_tready_f = '1' and s_axis_config_tready_r = '1' then
                        state_config_fft <= 0;
                    else
                        state_config_fft <= 1;
                    end if;				
				end if;   
            end case;
        end if;
    end process;
                        
    -- control looping of xcorr calculation
    loop_control : process(clk, rst)
    begin
        if rst = '1' then
            run_adc <= '0';
        elsif rising_edge(clk) then
            case state_loop is
                when 0 =>
                    run_adc <= '0';
                    led <= '0';
                    if run = '1' then
                        if use_adc = '1' then
                            run_adc <= '1';
                            state_loop <= 1;
                        else
                            run_xcorr <= '1';
                            state_loop <= 2;
                        end if;
                    else
                        state_loop <= 0;
                    end if
                when 1 =>
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
    -- get adc data
    adc_proc : process(clk, rst)
    begin
		if rst = '1' then
			samp_ram_wea <= "0";
			samp_ram_addra_s <= (others => '0');
			state_adc <= 0;
			rc <= '1';
			adc_counts <= 0;
			data_ready <= '0';
		elsif rising_edge(clk) then
			-- wait for run command
			if state_adc = 0 then 
				samp_ram_wea <= "0";
				adc_counts <= 0;
				rc <= '1';
				adc_data_ready <= '0';
				if run_adc = '1' then
                    state_adc <= 1;
                    -- save data at 0 to n_samples if samp_ram_flag = 0, otherwise save data in upper half of mem
					if samp_ram_flag = '0' then 
                        samp_ram_addra_s <= (others => '0');
						samp_ram_max_addra <= std_logic_vector(to_unsigned(n_samples - 1, samp_ram_addr_length));
                    else
                        samp_ram_addra_s <= adc_n_samples;
                        samp_ram_max_addra <= std_logic_vector(to_unsigned(2*n_samples - 1, samp_ram_addr_length));
					end if;
				else
					state_adc <= 0;
				end if;															
			-- drop rc low to begin converting
			elsif state_adc = 1 then
				rc <= '0';
				state_adc <= 2;
			-- wait to ensure that sampling period is maintained
			elsif state_adc = 2 then
				rc <= '1';
				-- 4 cycle delay due to state changes
				if adc_counts = (adc_counts_per_sample - 4) then
					state_adc <= 3;
				else 
					adc_counts <= adc_counts + 1;
					state_adc <= 2;
				end if;
			-- check to make sure adc is finished converting data
			elsif state_adc = 3 then
				if busy = '1' then
					samp_ram_wea <= "1";
					state_adc <= 4;
				elsif busy = '0' then
					state_adc <= 3;
				end if;			
			-- check to see if desired number of samples has been reached
			elsif state_adc = 4 then
				samp_ram_wea <= "0";
				if samp_ram_addra_s = samp_ram_max_addra then
					adc_data_ready <= '1';
					state_adc <= 5;
				else
					adc_counts <= 0;
					samp_ram_addr_s <= std_logic_vector(unsigned(samp_ram_addr_s) + 1);
					state_adc <= 1;
				end if;
            elsif state_adc = 5 then
                samp_ram_flag <= samp_ram_flag + '1';
                adc_data_ready <= '0';
                state_adc <= 0;
			end if;
		end if;
     end process;     		

	 
    mux_proc : process(clk)
    begin
        if rising_edge(clk) then
            case zp is
                when '0' =>
                    mux_out <= mux_in1;
                when '1' => 
                    mux_out <= mux_in2;
                when others =>
                    mux_out <= mux_in1;
            end case;
        end if;
    end process;  
    
                     
            
	xcorr_proc : process(clk, rst)
	begin	
		if rst = '1' then
			fft_rst <= '0'; -- active low reset (2 cycles)
			samp_ram_addrb_s <= (others => '0');
			xcorr_ram_addra_s <= (others => '0');
			xcorr_ram_wea <= "0";
			pad_count <= 0;
			zp <= '0';
			s_axis_data_tvalid_f <= '0';
			s_axis_data_tlast_f <= '0';
            s_axis_config_tvalid_r <= '0';
			m_axis_data_tready_r <= '0';
			xcorr_finished <= '0';
			state_xcorr <= 0;
		elsif rising_edge(clk) then
			-- wait for data_ready to initialize config data transfer
			if state_xcorr = 0 then
				fft_rst <= '1';
				xcorr_ram_wea <= "0";
				xcorr_ram_addra_s <= (others => '0');
                samp_ram_addrb_s <= (others => '0'); -- 9/9/15
				s_axis_data_tvalid_f <= '0';
				s_axis_data_tlast_f <= '0';
				m_axis_data_tready_r <= '0';
				xcorr_finished <= '0';
				pad_count <= 0;
				zp <= '0';
				pad_length <= n_fft - n_samples;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
				if run_xcorr = '1' then              
					           
					state_xcorr <= 1;
                    if run_single_flag = '1' then                   
                        samp_ram_max_addr <= std_logic_vector(to_unsigned(n_samples - 1, 12));

				else
					state_xcorr <= 0;
				end if; 
			-- wait for tready to go high
			elsif state_xcorr= 1 then
				if s_axis_config_tready_f = '1' and s_axis_config_tready_r = '1' then
					state_xcorr <= 2;
				else
					state_xcorr <= 1;
				end if;
			elsif state_xcorr= 2 then
				-- begin sending samples to fft
				s_axis_config_tvalid_f <= '0';
                s_axis_config_tvalid_r <= '0';
				s_axis_data_tvalid_f <= '1';
				if s_axis_data_tready_f = '1' then
					state_xcorr <= 3;
					-- samp_ram_addrb_s <= std_logic_vector(unsigned(samp_ram_addrb_s) + 1);
				else
					state_xcorr <= 2;
				end if;
			elsif state_xcorr= 3 then
				-- continue to send samples until limit is reached, then begin zero padding
				if s_axis_data_tready_f = '1' then
					samp_ram_addrb_s <= std_logic_vector(unsigned(samp_ram_addrb_s) + 1);
					if samp_ram_addrb_s =  samp_ram_max_addr then
						zp <= '1';
						state_xcorr <= 4;
					else
						state_xcorr <= 3;
					end if;
				else
					state_xcorr <= 3;
				end if;
			elsif state_xcorr = 4 then
				if s_axis_data_tready_f = '1' then
					pad_count <= pad_count + 1;
					if pad_count = (pad_length - 2) then
						s_axis_data_tlast_f <= '1';
						state_xcorr <= 5;
					else
						state_xcorr <= 4;
					end if;
				else
					state_xcorr <= 4;
				end if;		
			elsif state_xcorr = 5 then
				zp <= '0';
				s_axis_data_tlast_f <= '0';
				s_axis_data_tvalid_f <= '0';
                m_axis_data_tready_r <= '1';
                ifft_ram_wea <= "1";
				state_xcorr <= 6;
            elsif state_xcorr = 6 then
                if m_axis_data_tvalid_r = '1' then
                    ifft_ram_addra_s <= std_logic_vector(unsigned(ifft_ram_addra_s) + 1); -- correct? need wea 1?
                    state_xcorr <= 7;
                end if;
			elsif state_xcorr = 7 then
				if m_axis_data_tvalid_r = '1' then
					ifft_ram_wea <= "1";
					ifft_ram_addra_s <= std_logic_vector(unsigned(ifft_ram_addra_s) + 1);
					if m_axis_data_tlast_r = '1' then	
                        ifft_ram_wea <= "0";
						xcorr_finished <= '1';
						state_xcorr <= 8;
					else
						state_xcorr <= 7;
					end if;
				else
					ifft_ram_wea <= "0";
					state_xcorr <= 7;
				end if;	
            elsif state_xcorr = 8 then
                xcorr_finished <= '0';
                state_xcorr <= 0;
			end if;
		end if;
	end process;
    
                      

    
    
	
end behavioral;