-- comparison between typical 16 bit adc output values and resized 32 bit values in both 32 bit wide input and 16 bit
-- wide input fft. will additionally send zero padded data to fft w/ nfft_padded = 2*nfft.
-- send data to 16 bit fft, save results to mem, then repeat for 32 bit fft.
-- data is then sent over uart in 16 bit chunks

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fsm is
	generic(clk_rate : natural := 100); -- clk rate in MHz
    Port   (clk : in std_logic;
    		-- initialization settings
    		fft_points : in std_logic_vector(4 downto 0); -- n point fft. 01010 = 1024 point
    		n_samples : in natural; -- number of samples to save to ram if not using initialized values. 1024, 2048, etc.
    		sample_rate : in natural; -- sampling rate of adc in kHz
    		init_max_addr : in natural; -- max address if using initialized values. 1023, 2047, etc.
			zeropad : in std_logic;
        	ram_initialized : in std_logic; -- 1= data already initialized, do not use adc. 0= use adc, store data in ram before sending to fft
        	-- control and debug ports
    		fsm_state : out natural; -- fsm state for debugging
        	run : in std_logic; -- begin state machine
        	rst : in std_logic; -- reset state machine
        	--adc ports
    		busy : in std_logic; -- ad976 busy signal
    		cs : out std_logic; -- tie low to control adc with rc
    		rc : out std_logic; -- tells adc to start conversion when held low for >=50ns
    		-- mem_coe : stores initialized values or recorded ADC values
			ram0_din : in std_logic_vector(15 downto 0);
    		ram0_wea : out STD_LOGIC_VECTOR(0 DOWNTO 0); 
    		ram0_addra : out STD_LOGIC_VECTOR(13 DOWNTO 0);
			ram0_resize_out : out std_logic_vector(31 downto 0); -- goes to fft32 input
			-- mem16: 16 bit input fft results 
			ram1_data_in : in std_logic_vector(31 downto 0); -- read ram contents for repackaging
    		ram1_wea : out STD_LOGIC_VECTOR(0 DOWNTO 0);
    		ram1_addra : out STD_LOGIC_VECTOR(12 DOWNTO 0);		
			-- mem32: 32 bit input fft results
			ram2_data_in : in std_logic_vector(63 downto); -- read ram contents for repackaging
    		ram2_wea : out STD_LOGIC_VECTOR(0 DOWNTO 0);
    		ram2_addra : out STD_LOGIC_VECTOR(12 DOWNTO 0);			
    		-- fft16 ports
       		fft_rst16 : out std_logic; --active low reset, must be held low for 2 cycles
    	  	s_axis_config_tdata16 : out STD_LOGIC_VECTOR(24 DOWNTO 0); -- (22:9) scaling, (8) fwd/inv, (4:0) nfft
    	  	s_axis_config_tvalid16 : out STD_LOGIC; -- signals that master is ready to send data to fft
    	  	s_axis_config_tready16 : in STD_LOGIC; -- signals that fft is ready for config data
    	  	s_axis_data_tvalid16 : out STD_LOGIC; -- signals that master is ready to send data to fft
    	  	s_axis_data_tready16 : in STD_LOGIC; -- signals that fft is ready to receive data
    	  	s_axis_data_tlast16 : out  STD_LOGIC; -- asserted by master on last sample being sent to fft
    	  	m_axis_data_tvalid16 : in STD_LOGIC; -- asserted by fft to signal that it's ready to provide output data
    	  	m_axis_data_tready16 : out STD_LOGIC; -- asserted by external unit to signal that it's ready for output data
    	  	m_axis_data_tlast16 : in STD_LOGIC; -- asserted by fft on last sample being sent out
			-- fft32 ports
			fft_rst32 : out std_logic; 
    	  	s_axis_config_tdata32 : out STD_LOGIC_VECTOR(24 DOWNTO 0); 
    	  	s_axis_config_tvalid32 : out STD_LOGIC; 
    	  	s_axis_config_tready32 : in STD_LOGIC; 
    	  	s_axis_data_tvalid32 : out STD_LOGIC; 
    	  	s_axis_data_tready32 : in STD_LOGIC; 
    	  	s_axis_data_tlast32 : out  STD_LOGIC; 
    	  	m_axis_data_tvalid32 : in STD_LOGIC; 
    	  	m_axis_data_tready32 : out STD_LOGIC; 
    	  	m_axis_data_tlast32 : in STD_LOGIC; 
    	  	-- uart ports
    	  	txfinished : in std_logic;
    	  	uart_data : out std_logic_vector(15 downto 0); -- 16 bit data to send via uart
    	  	txready : out std_logic);
end fsm;

architecture behavioral of fsm is

signal fft_config : std_logic_vector(23 downto 0) := (others => '0');
signal ram0_addra_s : std_logic_vector(13 downto 0) := (others => '0');
signal ram1_addra_s, ram2_addra_s : std_logic_vector(12 downto 0) := (others => '0');
signal resized_sample : std_logic_vector(31 downto 0) := (others => '0');
signal scaling_sch : std_logic_vector(13 downto 0) := (others => '0');
signal state : natural range 0 to 30 := 0;
signal clk_counter, addr_counter : natural range 0 to 5000 := 0;
signal counts_per_sample : natural range 50 to 5000 := 50;

begin

	cs <= '0';
	ram0_addra <= ram0_addra_s;
	ram1_addra <= ram1_addra_s;
	ram2_addra <= ram2_addra_s;
	fsm_state <= state;
	counts_per_sample <= (clk_rate * 1000) / sample_rate;
	scaling_sch <= "10101010101011"; -- conservative schedule
	process(clk, run, rst)
		begin
		if rst = '1' then
			ram0_wea <= "0";
			ram1_wea <= "0";
			ram2_wea <= "0";
			ram0_addra_s <= (others => '0');
			ram1_addra_s <= (others => '0');
			ram2_addra_s <= (others => '0');
			txready <= '0';
			state <= 0;
			rc <= '1';
			clk_counter <= 0;
			addr_counter <= 0;
			fft_rst16 <= '0'; -- active low
			fft_rst32 <= '0';
			s_axis_config_tvalid16 <= '0';
			s_axis_data_tvalid16 <= '0';
			s_axis_config_tvalid32 <= '0';
			s_axis_data_tvalid32 <= '0';
		elsif rising_edge(clk) then
			fft_rst16 <= '1'; -- active low
			fft_rst32 <= '1'; 
			-- wait for run command
			if state = 0 then 
				ram0_addra_s <= (others => '0');
				ram1_addra_s <= (others => '0');
				ram2_addra_s <= (others => '0');
				clk_counter <= 0;
				addr_counter <= 0;
				--set config command to send to fft
				fft_config(22:9) <= scaling_sch;
				fft_config(8) <= '1'; -- fwd fft		
				-- double the transform length if zeropad = 1 since sample length will double.
				-- this means that the max input sample length (for current ram size) will be 4096 w/ zeropad
				-- enabled, and 8192 without
				if zeropad = '1' then
					fft_config(4 downto 0) <= std_logic_vector(unsigned(fft_points + 1);
				else
					fft_config(4 downto 0) <= fft_points;
				end if;
				if (run = '1' and rst = '0') then
					s_axis_config_tdata16 <= fft_config;
					if ram_initialized = '0' then -- using adc
						ram0_max_addr <= std_logic_vector(to_unsigned(n_samples - 1, 14));
						ram0_rst <= '1';
						clk_counter <= 0;					
						state <= 1;
					elsif ram_initialized = '1' then -- using initialized values
						ram0_max_addr <= std_logic_vector(to_unsigned(init_max_addr, 13));
						state <= 5;
					end if;
				end if;
				
		--BEGIN ADC STATES *************************************************************
				
		-- drop rc low to begin converting
		elsif state = 1 then
			rc <= '0';
			state <= 2;
		-- wait to ensure that sampling period is maintained
		elsif state = 2 then
			rc <= '1';
			if clk_counter = (counts_per_sample - 2) then
				state <= 3;
			else 
				clk_counter <= clk_counter + 1;
				state <= 2;
			end if;
		-- check to make sure adc is finished converting data
		elsif state = 3 then
			if busy = '1' then
				ram0_wea <= "1";
				state <= 4;
			elsif busy = '0' then
				state <= 3;
			end if;			
		-- check to see if desired number of samples has been reached
		elsif state = 4 then
			ram0_wea <= "0";
			if ram0_addra_s = ram0_max_addr then
				ram0_addra_s <= (others => '0');
				state <= 5;
			else
				clk_counter <= 0;
				ram0_addra_s <= std_logic_vector(unsigned(ram1_addra_s) + 1);
				state <= 1;
			end if;
		
		-- END ADC STATES *************************************************************				
				
				
				
				
				
				
				
				
				
				
				
				