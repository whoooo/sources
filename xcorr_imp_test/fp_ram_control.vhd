library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fp_ram_control is
    port(   m_axis_data_tvalid_f    : in std_logic;
            m_axis_data_tready_f    : in std_logic;
            fp_tready               : in std_logic;
            n_fft                   : in natural;
            clk                     : in std_logic;
            rst                     : in std_logic;
            fp_tvalid               : out std_logic;
            fp_ram_addra            : out std_logic_vector(12 downto 0));
end fp_ram_control;

architecture behavioral of fp_ram_control is

signal fp_ram_addra_s : std_logic_vector(12 downto 0) := (others=>'0');
signal finished : std_logic := '0';

begin

fp_ram_addra <= fp_ram_addra_s;

process(clk)
begin
    if rst = '1' then
        fp_tvalid <= '0';
        fp_ram_addra_s <= (others => '0');
        finished <= '0';
    elsif rising_edge(clk) then
        if finished = '0' then
            fp_tvalid <= '1';
            if (m_axis_data_tready_f = '1') and (m_axis_data_tvalid_f = '1') and (fp_tready = '1') then
                fp_ram_addra_s <= std_logic_vector(unsigned(fp_ram_addra_s) + 1);
                if (fp_ram_addra_s >= std_logic_vector(to_unsigned(n_fft,13))) then
                    finished <= '1';
                    fp_tvalid <= '0';
                end if;
            else
                null;
            end if;
        else
            fp_tvalid <= '0';
            finished <= '0';
            fp_ram_addra_s <= (others => '0');
        end if;
    end if;
end process;

end;
        