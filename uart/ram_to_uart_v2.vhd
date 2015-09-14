-- v2 fixed issue where extra 1 extra packet was being sent

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ram_to_uart_v2 is
    generic(addr_width      : natural := 14);
    port(	clk 			: in std_logic;
            rst				: in std_logic;
            start			: in std_logic;
            txfinished 		: in std_logic;
            max_addr        : in natural;
            done    		: out std_logic;
            addr_out		: out std_logic_vector(addr_width downto 0);
            txbyte_ready 	: out std_logic);
end ram_to_uart_v2;

architecture behavioral of ram_to_uart_v2 is 

signal addr_out_s, max_addr_s : std_logic_vector(14 downto 0) := (others => '0');
signal state : std_logic := '0';

begin

addr_out <= addr_out_s;

process(clk)
begin
	if rst = '1' then
		state <= '0';
		addr_out_s <= (others => '0');
		max_addr_s <= std_logic_vector(to_unsigned(max_addr, addr_width+1));
		done <= '0';
		txbyte_ready <= '0';
	elsif rising_edge(clk) then
		case state is
        when '0' =>
            max_addr_s <= std_logic_vector(to_unsigned(max_addr, addr_width+1));
            addr_out_s <= (others => '0');
            done <= '0';
            txbyte_ready <= '0';
            if start = '1' then
                txbyte_ready <= '1';
                -- addr_out_s <= std_logic_vector(unsigned(addr_out_s) + 1);
                state <= '1';
            else
                state <= '0';
            end if;
        when '1' =>
            txbyte_ready <= '0';
            if txfinished = '1' then
                addr_out_s <= std_logic_vector(unsigned(addr_out_s) + 1);
                if (addr_out_s >= max_addr_s) then
                    done <= '1';
                    state <= '0';
                else
                    txbyte_ready <= '1';
                    state <= '1';
                end if;
            end if;
        when others =>
            null;
        end case;
    end if;
end process;
end;
            
                