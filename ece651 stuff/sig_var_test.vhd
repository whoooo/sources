library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sig_var_test is
    port(   clk     : in std_logic;
            out_sig : out std_logic_vector(1 downto 0);
            out_var : out std_logic_Vector(1 downto 0));
end sig_var_test;

architecture behavioral of sig_var_test is

signal a : std_logic_vector(1 downto 0) := "00";

begin

    sig_proc : process(clk)
    begin
        if rising_edge(clk) then
            a <= "11";
            out_sig <= a;
        end if;
    end process;

    var_proc : process(clk)
    variable b : std_logic_vector(1 downto 0) := "00";
    begin
        if rising_edge(clk) then
            b := "11";
            out_var <= b;
        end if;
    end process;
      
end behavioral;