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
            fp_ram_addr            : out std_logic_vector(12 downto 0));
end fp_ram_control;

architecture behavioral of fp_ram_control is

signal fp_ram_addr_s : std_logic_vector(12 downto 0) := (others=>'0');
signal finished : std_logic := '0';
signal count, count_lim : natural range 0 to 30 := 0;

begin

fp_ram_addr <= fp_ram_addr_s;
count_lim <= 20;

process(clk)
begin
    if rst = '1' then
        fp_tvalid <= '0';
        fp_ram_addr_s <= (others => '0');
        finished <= '0';
        count <= 0;
    elsif rising_edge(clk) then
        if finished = '0' then
            count <= 0;
            fp_tvalid <= '1';
            -- if (m_axis_data_tready_f = '1') and (m_axis_data_tvalid_f = '1') and (fp_tready = '1') then
            if fp_tready = '1' then
                fp_ram_addr_s <= std_logic_vector(unsigned(fp_ram_addr_s) + 1);
                if (fp_ram_addr_s >= std_logic_vector(to_unsigned(n_fft - 1,13))) then
                    finished <= '1';
                    fp_tvalid <= '0';
                else
                    fp_tvalid <= '1';
                    finished <= '0';
                end if;
            else
                null;
            end if;
        else
            if (count = count_lim) then
                fp_tvalid <= '0';
                finished <= '0';
                fp_ram_addr_s <= (others => '0');
            else
                count <= count + 1;
            end if;
        end if;
    end if;
end process;

end;
        