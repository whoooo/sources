library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sram_tester is
    port(   clk         : in std_logic;   
            rst         : in std_logic;
            addr_c      : out std_logic_vector(1 downto 0);
            addr_r      : out std_logic_vector(4 downto 0);
            pre_charge  : out std_logic;
            read_en     : out std_logic;
            write_en    : out std_logic;
            dout        : out std_logic_vector(3 downto 0)
            );
end sram_tester;

architecture behavioral of sram_tester is

signal state_write, state_read, state_next : natural range 0 to 10 := 0;
signal write_complete : std_logic := '0';
signal addr_c_s, addr_r_s : natural range 0 to 31 := 0;

begin

addr_c <= std_logic_vector(to_unsigned(addr_c_s, 2));
addr_r <= std_logic_vector(to_unsigned(addr_r_s, 5));

write_proc : process(clk, rst)
begin
    if rst = '1' then
        state_write <= 0;
    elsif rising_edge(clk) then
        case state_write is
            when 0 =>
                dout <= "1010";
                addr_c_s <= 0;
                addr_r_s <= 0;
                state_write <= 1;
            when 1 => 
                write_en <= '1';
                state_write <= 2;
            when 2 =>
                addr_c_s <= 1;
                addr_r_s <= 7;
                dout <= "0101";
                state_write <= 3;
            when 3 =>
                addr_c_s <= 0;
                addr_r_s <= 15;
                dout <= "1100";
                state_write <= 4;
            when 4 => 
                addr_c_s <= 1;
                addr_r_s <= 23;
                dout <= "0011";
                state_write <= 5;
            when 5 => 
                addr_c_s <= 0;
                addr_r_s <= 31;
                dout <= "1111";
                state_write <= 6;
            when 6 =>
                write_en <= '0';
                write_complete <= '1';
                addr_c_s <= 0;
                addr_r_s <= 0;
                state_write <= 7;
            when 7 =>
                null;
            when others =>
                state_write <= 0;
        end case;
    end if;
end process;

read_proc : process(clk, rst)
begin
    if rst = '1' then
        state_read <= 0;
    elsif rising_edge(clk) then
        case state_read is
            when 0 =>
                if write_complete = '1' then
                    pre_charge <= '1';
                    addr_c_s <= 0;
                    addr_r_s <= 0;
                    state_read <= 1;
                    state_next <= 2;                  
                else
                    state_read <= 0;
                end if;
            when 1 =>
                pre_charge <= '0';
                read_en <= '1';
                state_read <= state_next;
            when 2 =>
                read_en <= '0';
                pre_charge <= '1';
                addr_c_s <= 1;
                addr_r_s <= 7;
                state_read <= 1;
                state_next <= 3;
            when 3 =>
                read_en <= '0';
                pre_charge <= '1';
                addr_c_s <= 0;
                addr_r_s <= 15;
                state_read <= 1;
                state_next <= 4; 
            when 4 =>
                read_en <= '0';
                pre_charge <= '1';
                addr_c_s <= 1;
                addr_r_s <= 23;
                state_read <= 1;
                state_next <= 5;
            when 5 =>
                read_en <= '0';
                pre_charge <= '1';
                addr_c_s <= 0;
                addr_r_s <= 31;
                state_read <= 1;
                state_next <= 6;
            when 6 =>
                read_en <= '0';
                state_read <= 6;
			when others =>
				state_read <= 0;
        end case;
    end if;
end process;

end behavioral;
            
                
                
                
                
                
                
                

