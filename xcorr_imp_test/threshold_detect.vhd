-- sets flag high if incoming xcorr value is greater than threshold set in this module
-- only takes real part from output of ifft

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity threshold_detect is
    port(   clk: in std_logic;
            rst : in std_logic;
            threshold : in std_logic_vector(31 downto 0);
            xcorr_in : in std_logic_vector(31 downto 0);
            flag : out std_logic);
end threshold_detect;

architecture behavioral of threshold_detect is 

begin

process(clk) 
begin
    if rst = '1' then
        flag <= '0';
    elsif rising_edge(clk) then
        if xcorr_in >= threshold then -- use abs?
            flag <= '1';
        else
            flag <= '0';
        end if;
    end if;
end process;

end behavioral;