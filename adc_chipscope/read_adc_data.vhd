----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/13/2014 01:06:56 PM
-- Design Name: 
-- Module Name: read_adc_data - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity read_adc_data is
    Port ( clk100 : in STD_LOGIC;
           din : in STD_LOGIC_vector(15 downto 0);
           busy : in STD_LOGIC;
           cs : out STD_LOGIC;
           rc : out STD_LOGIC);
end read_adc_data;

architecture Behavioral of read_adc_data is

	component ad976_control 
		generic( 	clk_rate : integer := 5;
					sample_rate : integer := 100); 
		Port(
	    	din : in STD_LOGIC_VECTOR(15 downto 0);
	      	clk : in std_logic;
	     	busy : in STD_LOGIC;
	    	cs : out STD_LOGIC;
	      	rc : out STD_LOGIC;
	       	adc_en : in std_logic;
	       	adc_clk : out std_logic;
	       	dout : out std_logic_vector(15 downto 0);
	       	dready: out std_logic);	
	 end component;
	 
	component clk_wiz_0
	 	port(
	 		  clk_in1           : in     std_logic;
	 		  clk5          : out    std_logic;
	 		  reset             : in     std_logic;
	 		  locked            : out    std_logic);
	 	end component;
	 	
	 	ATTRIBUTE SYN_BLACK_BOX OF clk_wiz_0 : COMPONENT IS TRUE;		
	 	ATTRIBUTE BLACK_BOX_PAD_PIN OF clk_wiz_0 : COMPONENT IS "clk_in1,clk5,reset,locked";
	 	
 	COMPONENT ila_0
	 	  PORT (
	 	    clk : IN STD_LOGIC;
	 	    probe1 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
	 	    probe0 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
	 	    probe2 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
	 	    probe3 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
	 	    probe4 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
	 	    probe5 : IN STD_LOGIC_VECTOR(0 DOWNTO 0)
	 	  );
	 	END COMPONENT;
	 ATTRIBUTE SYN_BLACK_BOX OF ila_0 : COMPONENT IS TRUE;
	 ATTRIBUTE BLACK_BOX_PAD_PIN OF ila_0 : COMPONENT IS "clk,probe1[0:0],probe0[15:0],probe2[0:0],probe3[0:0],probe4[7:0],probe5[0:0]";
	 
	COMPONENT vio_0
	 		  PORT (
	 		    clk : IN STD_LOGIC;
	 		    probe_out0 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
	 		    probe_out1 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0));
	 		END COMPONENT;
	 	ATTRIBUTE SYN_BLACK_BOX OF vio_0 : COMPONENT IS TRUE;
	 	ATTRIBUTE BLACK_BOX_PAD_PIN OF vio_0 : COMPONENT IS "clk,probe_out0[0:0],probe_out1[0:0]";
 	
 	
ATTRIBUTE SYN_BLACK_BOX : BOOLEAN;	
ATTRIBUTE BLACK_BOX_PAD_PIN : STRING;
signal clk5_s, dready_s, adc_clk_s, adc_en_s, locked_s : std_logic := '0';
signal adc_dout_s : std_logic_vector(15 downto 0) := (others => '0');
signal adc_en_pr, adc_clk_pr, dready_pr, unused : std_logic_vector(0 downto 0) := "0";

begin

adc_en_s <= adc_en_pr(0);
adc_clk_pr(0) <= adc_clk_s;
dready_pr(0) <= dready_s;
		
	ila : ila_0
	  	PORT MAP (	clk => clk100,
					probe0 => adc_dout_s,
					probe1 => adc_clk_pr,
					probe2 => dready_pr,
					probe3 => "0",
					probe4 => (others => '0'),
					probe5 => "0");
	
	vio : vio_0 
		PORT MAP (	clk => clk100,
					probe_out0 => adc_en_pr,
					probe_out1 => unused);
					
	adc_control : ad976_control 
		generic map(clk_rate => 5,
					sample_rate => 40)
		port map(	din => din,
					clk => clk5_s,
					busy => busy,
					cs => cs,
					rc => rc,
					adc_en => adc_en_s,
					adc_clk => adc_clk_s,
					dout => adc_dout_s,
					dready => dready_s);
					
	clk_gen : clk_wiz_0
		port map (	clk_in1 => clk100,
					clk5 => clk5_s,
					reset => '0',
					locked => locked_s);

end Behavioral;
