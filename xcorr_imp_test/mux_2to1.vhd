library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_2to1 is
    generic(data_width  : natural := 8);     
	port(   clk         : in std_logic;	
            i1          : in std_logic_vector(data_width-1 downto 0);
            i2          : in std_logic_vector(data_width-1 downto 0);
            control     : in std_logic;
            o           : out std_logic_vector(data_width-1 downto 0));
end mux_2to1;

architecture behavioral of mux_2to1 is

begin

process(clk)
begin
    if rising_edge(clk) then
        case control is
            when '0' =>
                o <= i1;
            when '1' => 
                o <= i2;
            when others =>
                o <= i2;
        end case;
	end if;
end process;

end behavioral;