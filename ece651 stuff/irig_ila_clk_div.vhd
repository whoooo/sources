-- use D-ff freq divider to generate ~3kHz clock from 100MHz clock
-- 

library IEEE;
library UNISIM; 
use IEEE.STD_LOGIC_1164.all;
use UNISIM.Vcomponents.ALL;

entity irig_ila_clk_div is
    generic(dividers : natural := 14);
    port(   clk_in : in std_logic;
            clk_out : out std_logic);
end irig_ila_clk_div;

architecture gen of irig_ila_clk_div is

signal s,s_inv : std_logic_vector((dividers + 1) downto 0) := (others => '0');
attribute keep : string;
attribute keep of s : signal is "true";
attribute keep of s_inv : signal is "true";


begin

generate_dff : for i in 0 to dividers generate

        dff : FDCE
        generic map(INIT => '0') 
        port map (  Q => s(i),      
                    C => s_inv(i),      
                    CE => '1',    
                    CLR => '0',  
                    D => s_inv(i+1));
                    
        s_inv(i+1) <= not s(i);
    
end generate generate_dff;  

s_inv(0) <= clk_in;
clk_out <= s(dividers);  

    
end;
                
                
                
                
                