library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ulogic_example is
    port(   clk         : in std_logic;
        	d           : out std_ulogic);
end ulogic_example;

architecture behavioral of ulogic_example is

signal a, b, c : std_ulogic;

begin

d <= b;
d <= c;
    
end behavioral;