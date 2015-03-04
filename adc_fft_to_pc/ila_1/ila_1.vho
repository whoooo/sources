-- (c) Copyright 1995-2015 Xilinx, Inc. All rights reserved.
-- 
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
-- 
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
-- 
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
-- 
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
-- 
-- DO NOT MODIFY THIS FILE.

-- IP VLNV: xilinx.com:ip:ila:4.0
-- IP Revision: 1

-- The following code must appear in the VHDL architecture header.

------------- Begin Cut here for COMPONENT Declaration ------ COMP_TAG
COMPONENT ila_1
  PORT (
    clk : IN STD_LOGIC;
    probe19 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    probe1 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    probe21 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    probe23 : IN STD_LOGIC_VECTOR(12 DOWNTO 0);
    probe24 : IN STD_LOGIC_VECTOR(12 DOWNTO 0);
    probe26 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    probe7 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    probe11 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    probe12 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    probe14 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    probe15 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    probe18 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    probe0 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    probe20 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    probe2 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    probe22 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    probe3 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    probe4 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    probe25 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    probe5 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    probe27 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    probe6 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    probe8 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    probe9 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    probe10 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    probe13 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    probe16 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    probe17 : IN STD_LOGIC_VECTOR(0 DOWNTO 0)
  );
END COMPONENT;
ATTRIBUTE SYN_BLACK_BOX : BOOLEAN;
ATTRIBUTE SYN_BLACK_BOX OF ila_1 : COMPONENT IS TRUE;
ATTRIBUTE BLACK_BOX_PAD_PIN : STRING;
ATTRIBUTE BLACK_BOX_PAD_PIN OF ila_1 : COMPONENT IS "clk,probe19[0:0],probe1[0:0],probe21[0:0],probe23[12:0],probe24[12:0],probe26[31:0],probe7[0:0],probe11[0:0],probe12[0:0],probe14[0:0],probe15[0:0],probe18[0:0],probe0[0:0],probe20[0:0],probe2[0:0],probe22[0:0],probe3[0:0],probe4[0:0],probe25[4:0],probe5[0:0],probe27[31:0],probe6[0:0],probe8[0:0],probe9[0:0],probe10[0:0],probe13[0:0],probe16[0:0],probe17[0:0]";

-- COMP_TAG_END ------ End COMPONENT Declaration ------------

-- The following code must appear in the VHDL architecture
-- body. Substitute your own instance name and net names.

------------- Begin Cut here for INSTANTIATION Template ----- INST_TAG
your_instance_name : ila_1
  PORT MAP (
    clk => clk,
    probe19 => probe19,
    probe1 => probe1,
    probe21 => probe21,
    probe23 => probe23,
    probe24 => probe24,
    probe26 => probe26,
    probe7 => probe7,
    probe11 => probe11,
    probe12 => probe12,
    probe14 => probe14,
    probe15 => probe15,
    probe18 => probe18,
    probe0 => probe0,
    probe20 => probe20,
    probe2 => probe2,
    probe22 => probe22,
    probe3 => probe3,
    probe4 => probe4,
    probe25 => probe25,
    probe5 => probe5,
    probe27 => probe27,
    probe6 => probe6,
    probe8 => probe8,
    probe9 => probe9,
    probe10 => probe10,
    probe13 => probe13,
    probe16 => probe16,
    probe17 => probe17
  );
-- INST_TAG_END ------ End INSTANTIATION Template ---------

-- You must compile the wrapper file ila_1.vhd when simulating
-- the core, ila_1. When compiling the wrapper file, be sure to
-- reference the VHDL simulation library.

