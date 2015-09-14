-- loop process. if threshold is detected, turn on led and send data. otherwise loop again


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity loop_control_1fp is
    port(   clk             	: in std_logic;
            rst            	 	: in std_logic;
            run_loop       	 	: in std_logic;
            ifft_finished  		: in std_logic;
            thresh_detected 	: in std_logic;
            ram2uart_done   	: in std_logic;
            m_axis_data_tvalid_r : in std_logic;
            start_adc       	: out std_logic;    
            rst_out         	: out std_logic;
            ram2uart_start  	: out std_logic;
            led             	: out std_logic);
end loop_control_1fp;

architecture behavioral of loop_control_1fp is

signal state : natural range 0 to 10 := 0;
signal thresh_flag : std_logic := '0';

begin

process(clk, rst)
begin
    if rst = '1' then
        state <= 0;
        thresh_flag <= '0';
        start_adc <= '0';
        rst_out <= '0';
        ram2uart_start <= '0';
        led <= '0';
    elsif rising_edge(clk) then
        case state is       
            when 0 =>
                -- start ad976_control which tells fft_control when to run
                thresh_flag <= '0';
                if run_loop = '1' then
                    start_adc <= '1';
                    state <= 1;
                else
                    state <= 0;
                end if;
            when 1 =>
                -- wait until cross correlation operation is complete,
                -- then move to next state
                start_adc <= '0';
                if m_axis_data_tvalid_r = '1' then
                    state <= 2;
                else
                    state <= 1;
                end if;
            when 2 =>
                -- set flag if threshold is met before moving to next state
                if thresh_detected = '1' then
                    thresh_flag <= '1';
                end if;                  
                if ifft_finished = '1' then
                    state <= 3;  
                else
                    state <= 2;
                end if;
            when 3 =>
                -- transfer data via uart if threshold met, otherwise loop back through
                if thresh_flag = '1' then
                    led <= '1';
                    ram2uart_start <= '1';
                    state <= 4;
                else
                    led <= '0';
                    state <= 0;
                end if;
            when 4 =>
                ram2uart_start <= '0';
                thresh_flag <= '0';
                if ram2uart_done = '1' then
                    state <= 0;
                else
                    state <= 4;
                end if;
            when others =>
                state <= 0;
        end case;
    end if;
end process;

end behavioral;
            
