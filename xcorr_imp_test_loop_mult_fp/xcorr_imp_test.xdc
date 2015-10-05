## This file is a general .xdc for the Nexys4 rev B board
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

## Clock signal
##Bank = 35, Pin name = IO_L12P_T1_MRCC_35,					Sch name = CLK100MHZ
set_property PACKAGE_PIN E3 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports clk]


##USB-RS232 Interface
#Bank = 35, Pin name = IO_L7P_T1_AD6P_35,					Sch name = UART_TXD_IN
set_property PACKAGE_PIN C4 [get_ports uart_in]
set_property IOSTANDARD LVCMOS33 [get_ports uart_in]
#Bank = 35, Pin name = IO_L11N_T1_SRCC_35,					Sch name = UART_RXD_OUT
set_property PACKAGE_PIN D4 [get_ports uart_out]
set_property IOSTANDARD LVCMOS33 [get_ports uart_out]
##Bank = 35, Pin name = IO_L12N_T1_MRCC_35,					Sch name = UART_CTS
#set_property PACKAGE_PIN D3 [get_ports RsCts]
#set_property IOSTANDARD LVCMOS33 [get_ports RsCts]
##Bank = 35, Pin name = IO_L5N_T0_AD13N_35,					Sch name = UART_RTS
#set_property PACKAGE_PIN E5 [get_ports RsRts]
#set_property IOSTANDARD LVCMOS33 [get_ports RsRts]



#Pmod Header JC
#Bank = 35, Pin name = IO_L23P_T3_35,                                           Sch name = JC1
set_property PACKAGE_PIN K2 [get_ports {din[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {din[15]}]
#Bank = 35, Pin name = IO_L6P_T0_35,                                            Sch name = JC2
set_property PACKAGE_PIN E7 [get_ports {din[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {din[13]}]
#Bank = 35, Pin name = IO_L22P_T3_35,                                           Sch name = JC3
set_property PACKAGE_PIN J3 [get_ports {din[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {din[11]}]
#Bank = 35, Pin name = IO_L21P_T3_DQS_35,                                       Sch name = JC4
set_property PACKAGE_PIN J4 [get_ports {din[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {din[9]}]
#Bank = 35, Pin name = IO_L23N_T3_35,                                           Sch name = JC7
set_property PACKAGE_PIN K1 [get_ports {din[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {din[14]}]
#Bank = 35, Pin name = IO_L5P_T0_AD13P_35,                                      Sch name = JC8
set_property PACKAGE_PIN E6 [get_ports {din[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {din[12]}]
#Bank = 35, Pin name = IO_L22N_T3_35,                                           Sch name = JC9
set_property PACKAGE_PIN J2 [get_ports {din[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {din[10]}]
#Bank = 35, Pin name = IO_L19P_T3_35,                                           Sch name = JC10
set_property PACKAGE_PIN G6 [get_ports {din[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {din[8]}]

#Pmod Header JD
#Bank = 35, Pin name = IO_L21N_T2_DQS_35,                                       Sch name = JD1
set_property PACKAGE_PIN H4 [get_ports {din[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {din[6]}]
#Bank = 35, Pin name = IO_L17P_T2_35,                                           Sch name = JD2
set_property PACKAGE_PIN H1 [get_ports {din[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {din[4]}]
#Bank = 35, Pin name = IO_L17N_T2_35,                                           Sch name = JD3
set_property PACKAGE_PIN G1 [get_ports {din[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {din[2]}]
#Bank = 35, Pin name = IO_L20N_T3_35,                                           Sch name = JD4
set_property PACKAGE_PIN G3 [get_ports {din[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {din[0]}]
#Bank = 35, Pin name = IO_L15P_T2_DQS_35,                                       Sch name = JD7
set_property PACKAGE_PIN H2 [get_ports {din[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {din[7]}]
#Bank = 35, Pin name = IO_L20P_T3_35,                                           Sch name = JD8
set_property PACKAGE_PIN G4 [get_ports {din[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {din[5]}]
#Bank = 35, Pin name = IO_L15N_T2_DQS_35,                                       Sch name = JD9
set_property PACKAGE_PIN G2 [get_ports {din[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {din[3]}]
#Bank = 35, Pin name = IO_L13N_T2_MRCC_35,                                      Sch name = JD10
set_property PACKAGE_PIN F3 [get_ports {din[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {din[1]}]

##Pmod Header JA
#Bank = 15, Pin name = IO_L1N_T0_AD0N_15,                                       Sch name = JA1
set_property PACKAGE_PIN B13 [get_ports busy]
set_property IOSTANDARD LVCMOS33 [get_ports busy]
#Bank = 15, Pin name = IO_L5N_T0_AD9N_15,                                       Sch name = JA2
set_property PACKAGE_PIN F14 [get_ports rc]
set_property IOSTANDARD LVCMOS33 [get_ports rc]
##Bank = 15, Pin name = IO_L16N_T2_A27_15,                                      Sch name = JA3
#set_property PACKAGE_PIN D17 [get_ports rc]
#set_property IOSTANDARD LVCMOS33 [get_ports rc]
##Bank = 15, Pin name = IO_L16P_T2_A28_15,                                      Sch name = JA4
#set_property PACKAGE_PIN E17 [get_ports {JA[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {JA[3]}]
##Bank = 15, Pin name = IO_0_15,                                                                Sch name = JA7
#set_property PACKAGE_PIN G13 [get_ports {JA[4]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {JA[4]}]
##Bank = 15, Pin name = IO_L20N_T3_A19_15,                                      Sch name = JA8
#set_property PACKAGE_PIN C17 [get_ports {JA[5]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {JA[5]}]
##Bank = 15, Pin name = IO_L21N_T3_A17_15,                                      Sch name = JA9
#set_property PACKAGE_PIN D18 [get_ports {JA[6]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {JA[6]}]
##Bank = 15, Pin name = IO_L21P_T3_DQS_15,                                      Sch name = JA10
#set_property PACKAGE_PIN E18 [get_ports {JA[7]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {JA[7]}]


## Switches
##Bank = 34, Pin name = IO_L21P_T3_DQS_34,					Sch name = SW0
#set_property PACKAGE_PIN U9 [get_ports {sw[0]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw[0]}]
##Bank = 34, Pin name = IO_25_34,							Sch name = SW1
#set_property PACKAGE_PIN U8 [get_ports {sw[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw[1]}]
##Bank = 34, Pin name = IO_L23P_T3_34,						Sch name = SW2
#set_property PACKAGE_PIN R7 [get_ports {sw[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw[2]}]
##Bank = 34, Pin name = IO_L19P_T3_34,						Sch name = SW3
#set_property PACKAGE_PIN R6 [get_ports {sw[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw[3]}]
##Bank = 34, Pin name = IO_L19N_T3_VREF_34,					Sch name = SW4
#set_property PACKAGE_PIN R5 [get_ports {sw[4]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw[4]}]
##Bank = 34, Pin name = IO_L20P_T3_34,						Sch name = SW5
#set_property PACKAGE_PIN V7 [get_ports {sw[5]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw[5]}]
##Bank = 34, Pin name = IO_L20N_T3_34,						Sch name = SW6
#set_property PACKAGE_PIN V6 [get_ports {sw[6]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw[6]}]
##Bank = 34, Pin name = IO_L10P_T1_34,						Sch name = SW7
#set_property PACKAGE_PIN V5 [get_ports {sw[7]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw[7]}]
##Bank = 34, Pin name = IO_L8P_T1-34,						Sch name = SW8
#set_property PACKAGE_PIN U4 [get_ports {sw[8]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw[8]}]
##Bank = 34, Pin name = IO_L9N_T1_DQS_34,					Sch name = SW9
#set_property PACKAGE_PIN V2 [get_ports {sw[9]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw[9]}]
##Bank = 34, Pin name = IO_L9P_T1_DQS_34,					Sch name = SW10
#set_property PACKAGE_PIN U2 [get_ports {sw[10]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw[10]}]
##Bank = 34, Pin name = IO_L11N_T1_MRCC_34,					Sch name = SW11
#set_property PACKAGE_PIN T3 [get_ports {sw[11]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw[11]}]
##Bank = 34, Pin name = IO_L17N_T2_34,						Sch name = SW12
#set_property PACKAGE_PIN T1 [get_ports {sw[12]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw[12]}]
##Bank = 34, Pin name = IO_L11P_T1_SRCC_34,					Sch name = SW13
#set_property PACKAGE_PIN R3 [get_ports {sw[13]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw[13]}]
##Bank = 34, Pin name = IO_L14N_T2_SRCC_34,					Sch name = SW14
#set_property PACKAGE_PIN P3 [get_ports {sw[14]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw[14]}]
##Bank = 34, Pin name = IO_L14P_T2_SRCC_34,					Sch name = SW15
#set_property PACKAGE_PIN P4 [get_ports {sw[15]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw[15]}]



## LEDs
#Bank = 34, Pin name = IO_L24N_T3_34,						Sch name = LED0
set_property PACKAGE_PIN T8 [get_ports led]
set_property IOSTANDARD LVCMOS33 [get_ports led]
##Bank = 34, Pin name = IO_L21N_T3_DQS_34,					Sch name = LED1
#set_property PACKAGE_PIN V9 [get_ports {led[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led[1]}]
##Bank = 34, Pin name = IO_L24P_T3_34,						Sch name = LED2
#set_property PACKAGE_PIN R8 [get_ports {led[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led[2]}]
##Bank = 34, Pin name = IO_L23N_T3_34,						Sch name = LED3
#set_property PACKAGE_PIN T6 [get_ports {led[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led[3]}]
##Bank = 34, Pin name = IO_L12P_T1_MRCC_34,					Sch name = LED4
#set_property PACKAGE_PIN T5 [get_ports {led[4]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led[4]}]
##Bank = 34, Pin name = IO_L12N_T1_MRCC_34,					Sch	name = LED5
#set_property PACKAGE_PIN T4 [get_ports {led[5]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led[5]}]
##Bank = 34, Pin name = IO_L22P_T3_34,						Sch name = LED6
#set_property PACKAGE_PIN U7 [get_ports {led[6]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led[6]}]
##Bank = 34, Pin name = IO_L22N_T3_34,						Sch name = LED7
#set_property PACKAGE_PIN U6 [get_ports {led[7]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led[7]}]
##Bank = 34, Pin name = IO_L10N_T1_34,						Sch name = LED8
#set_property PACKAGE_PIN V4 [get_ports {led[8]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led[8]}]
##Bank = 34, Pin name = IO_L8N_T1_34,						Sch name = LED9
#set_property PACKAGE_PIN U3 [get_ports {led[9]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led[9]}]
##Bank = 34, Pin name = IO_L7N_T1_34,						Sch name = LED10
#set_property PACKAGE_PIN V1 [get_ports {led[10]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led[10]}]
##Bank = 34, Pin name = IO_L17P_T2_34,						Sch name = LED11
#set_property PACKAGE_PIN R1 [get_ports {led[11]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led[11]}]
##Bank = 34, Pin name = IO_L13N_T2_MRCC_34,					Sch name = LED12
#set_property PACKAGE_PIN P5 [get_ports {led[12]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led[12]}]
##Bank = 34, Pin name = IO_L7P_T1_34,						Sch name = LED13
#set_property PACKAGE_PIN U1 [get_ports {led[13]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led[13]}]
##Bank = 34, Pin name = IO_L15N_T2_DQS_34,					Sch name = LED14
#set_property PACKAGE_PIN R2 [get_ports {led[14]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led[14]}]
##Bank = 34, Pin name = IO_L15P_T2_DQS_34,					Sch name = LED15
#set_property PACKAGE_PIN P2 [get_ports {led[15]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led[15]}]
##Bank = 34, Pin name = IO_L5P_T0_34,						Sch name = LED16_R
#set_property PACKAGE_PIN K5 [get_ports RGB1_Red]
#set_property IOSTANDARD LVCMOS33 [get_ports RGB1_Red]
##Bank = 15, Pin name = IO_L5P_T0_AD9P_15,					Sch name = LED16_G
#set_property PACKAGE_PIN F13 [get_ports RGB1_Green]
#set_property IOSTANDARD LVCMOS33 [get_ports RGB1_Green]
##Bank = 35, Pin name = IO_L19N_T3_VREF_35,					Sch name = LED16_B
#set_property PACKAGE_PIN F6 [get_ports RGB1_Blue]
#set_property IOSTANDARD LVCMOS33 [get_ports RGB1_Blue]
##Bank = 34, Pin name = IO_0_34,								Sch name = LED17_R
#set_property PACKAGE_PIN K6 [get_ports RGB2_Red]
#set_property IOSTANDARD LVCMOS33 [get_ports RGB2_Red]
##Bank = 35, Pin name = IO_24P_T3_35,						Sch name =  LED17_G
#set_property PACKAGE_PIN H6 [get_ports RGB2_Green]
#set_property IOSTANDARD LVCMOS33 [get_ports RGB2_Green]
##Bank = CONFIG, Pin name = IO_L3N_T0_DQS_EMCCLK_14,			Sch name = LED17_B
#set_property PACKAGE_PIN L16 [get_ports RGB2_Blue]
#set_property IOSTANDARD LVCMOS33 [get_ports RGB2_Blue]


##7 segment display
##Bank = 34, Pin name = IO_L2N_T0_34,						Sch name = CA
#set_property PACKAGE_PIN L3 [get_ports {seg[0]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {seg[0]}]
##Bank = 34, Pin name = IO_L3N_T0_DQS_34,					Sch name = CB
#set_property PACKAGE_PIN N1 [get_ports {seg[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {seg[1]}]
##Bank = 34, Pin name = IO_L6N_T0_VREF_34,					Sch name = CC
#set_property PACKAGE_PIN L5 [get_ports {seg[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {seg[2]}]
##Bank = 34, Pin name = IO_L5N_T0_34,						Sch name = CD
#set_property PACKAGE_PIN L4 [get_ports {seg[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {seg[3]}]
##Bank = 34, Pin name = IO_L2P_T0_34,						Sch name = CE
#set_property PACKAGE_PIN K3 [get_ports {seg[4]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {seg[4]}]
##Bank = 34, Pin name = IO_L4N_T0_34,						Sch name = CF
#set_property PACKAGE_PIN M2 [get_ports {seg[5]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {seg[5]}]
##Bank = 34, Pin name = IO_L6P_T0_34,						Sch name = CG
#set_property PACKAGE_PIN L6 [get_ports {seg[6]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {seg[6]}]
##Bank = 34, Pin name = IO_L16P_T2_34,						Sch name = DP
#set_property PACKAGE_PIN M4 [get_ports dp]
#set_property IOSTANDARD LVCMOS33 [get_ports dp]
##Bank = 34, Pin name = IO_L18N_T2_34,						Sch name = AN0
#set_property PACKAGE_PIN N6 [get_ports {an[0]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {an[0]}]
##Bank = 34, Pin name = IO_L18P_T2_34,						Sch name = AN1
#set_property PACKAGE_PIN M6 [get_ports {an[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {an[1]}]
##Bank = 34, Pin name = IO_L4P_T0_34,						Sch name = AN2
#set_property PACKAGE_PIN M3 [get_ports {an[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {an[2]}]
##Bank = 34, Pin name = IO_L13_T2_MRCC_34,					Sch name = AN3
#set_property PACKAGE_PIN N5 [get_ports {an[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {an[3]}]
##Bank = 34, Pin name = IO_L3P_T0_DQS_34,					Sch name = AN4
#set_property PACKAGE_PIN N2 [get_ports {an[4]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {an[4]}]
##Bank = 34, Pin name = IO_L16N_T2_34,						Sch name = AN5
#set_property PACKAGE_PIN N4 [get_ports {an[5]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {an[5]}]
##Bank = 34, Pin name = IO_L1P_T0_34,						Sch name = AN6
#set_property PACKAGE_PIN L1 [get_ports {an[6]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {an[6]}]
##Bank = 34, Pin name = IO_L1N_T034,							Sch name = AN7
#set_property PACKAGE_PIN M1 [get_ports {an[7]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {an[7]}]


##Buttons
##Bank = 15, Pin name = IO_L3P_T0_DQS_AD1P_15,				Sch name = CPU_RESET
#set_property PACKAGE_PIN C12 [get_ports btnCpuReset]
#set_property IOSTANDARD LVCMOS33 [get_ports btnCpuReset]
##Bank = 15, Pin name = IO_L11N_T1_SRCC_15,					Sch name = BTNC
#set_property PACKAGE_PIN E16 [get_ports btnC]
#set_property IOSTANDARD LVCMOS33 [get_ports btnC]
##Bank = 15, Pin name = IO_L14P_T2_SRCC_15,					Sch name = BTNU
#set_property PACKAGE_PIN F15 [get_ports btnU]
#set_property IOSTANDARD LVCMOS33 [get_ports btnU]
##Bank = CONFIG, Pin name = IO_L15N_T2_DQS_DOUT_CSO_B_14,	Sch name = BTNL
#set_property PACKAGE_PIN T16 [get_ports btnL]
#set_property IOSTANDARD LVCMOS33 [get_ports btnL]
##Bank = 14, Pin name = IO_25_14,							Sch name = BTNR
#set_property PACKAGE_PIN R10 [get_ports btnR]
#set_property IOSTANDARD LVCMOS33 [get_ports btnR]
##Bank = 14, Pin name = IO_L21P_T3_DQS_14,					Sch name = BTND
#set_property PACKAGE_PIN V10 [get_ports btnD]
#set_property IOSTANDARD LVCMOS33 [get_ports btnD]


##Pmod Header JB
##Bank = 15, Pin name = IO_L15N_T2_DQS_ADV_B_15,				Sch name = JB1
#set_property PACKAGE_PIN G14 [get_ports {JB[0]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {JB[0]}]
##Bank = 14, Pin name = IO_L13P_T2_MRCC_14,					Sch name = JB2
#set_property PACKAGE_PIN P15 [get_ports {JB[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {JB[1]}]
##Bank = 14, Pin name = IO_L21N_T3_DQS_A06_D22_14,			Sch name = JB3
#set_property PACKAGE_PIN V11 [get_ports {JB[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {JB[2]}]
##Bank = CONFIG, Pin name = IO_L16P_T2_CSI_B_14,				Sch name = JB4
#set_property PACKAGE_PIN V15 [get_ports {JB[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {JB[3]}]
##Bank = 15, Pin name = IO_25_15,							Sch name = JB7
#set_property PACKAGE_PIN K16 [get_ports {JB[4]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {JB[4]}]
##Bank = CONFIG, Pin name = IO_L15P_T2_DQS_RWR_B_14,			Sch name = JB8
#set_property PACKAGE_PIN R16 [get_ports {JB[5]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {JB[5]}]
##Bank = 14, Pin name = IO_L24P_T3_A01_D17_14,				Sch name = JB9
#set_property PACKAGE_PIN T9 [get_ports {JB[6]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {JB[6]}]
##Bank = 14, Pin name = IO_L19N_T3_A09_D25_VREF_14,			Sch name = JB10
#set_property PACKAGE_PIN U11 [get_ports {JB[7]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {JB[7]}]


##Pmod Header JXADC
##Bank = 15, Pin name = IO_L9P_T1_DQS_AD3P_15,				Sch name = XADC1_P -> XA1_P
#set_property PACKAGE_PIN A13 [get_ports {JXADC[0]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {JXADC[0]}]
##Bank = 15, Pin name = IO_L8P_T1_AD10P_15,					Sch name = XADC2_P -> XA2_P
#set_property PACKAGE_PIN A15 [get_ports {JXADC[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {JXADC[1]}]
##Bank = 15, Pin name = IO_L7P_T1_AD2P_15,					Sch name = XADC3_P -> XA3_P
#set_property PACKAGE_PIN B16 [get_ports {JXADC[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {JXADC[2]}]
##Bank = 15, Pin name = IO_L10P_T1_AD11P_15,					Sch name = XADC4_P -> XA4_P
#set_property PACKAGE_PIN B18 [get_ports {JXADC[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {JXADC[3]}]
##Bank = 15, Pin name = IO_L9N_T1_DQS_AD3N_15,				Sch name = XADC1_N -> XA1_N
#set_property PACKAGE_PIN A14 [get_ports {JXADC[4]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {JXADC[4]}]
##Bank = 15, Pin name = IO_L8N_T1_AD10N_15,					Sch name = XADC2_N -> XA2_N
#set_property PACKAGE_PIN A16 [get_ports {JXADC[5]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {JXADC[5]}]
##Bank = 15, Pin name = IO_L7N_T1_AD2N_15,					Sch name = XADC3_N -> XA3_N
#set_property PACKAGE_PIN B17 [get_ports {JXADC[6]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {JXADC[6]}]
##Bank = 15, Pin name = IO_L10N_T1_AD11N_15,					Sch name = XADC4_N -> XA4_N
#set_property PACKAGE_PIN A18 [get_ports {JXADC[7]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {JXADC[7]}]


##Quad SPI Flash
##Bank = CONFIG, Pin name = CCLK_0,							Sch name = QSPI_SCK
#set_property PACKAGE_PIN E9 [get_ports {QspiSCK}]
#set_property IOSTANDARD LVCMOS33 [get_ports {QspiSCK}]
##Bank = CONFIG, Pin name = IO_L1P_T0_D00_MOSI_14,			Sch name = QSPI_DQ0
#set_property PACKAGE_PIN K17 [get_ports {QspiDB[0]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {QspiDB[0]}]
##Bank = CONFIG, Pin name = IO_L1N_T0_D01_DIN_14,			Sch name = QSPI_DQ1
#set_property PACKAGE_PIN K18 [get_ports {QspiDB[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {QspiDB[1]}]
##Bank = CONFIG, Pin name = IO_L20_T0_D02_14,				Sch name = QSPI_DQ2
#set_property PACKAGE_PIN L14 [get_ports {QspiDB[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {QspiDB[2]}]
##Bank = CONFIG, Pin name = IO_L2P_T0_D03_14,				Sch name = QSPI_DQ3
#set_property PACKAGE_PIN M14 [get_ports {QspiDB[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {QspiDB[3]}]
##Bank = CONFIG, Pin name = IO_L15N_T2_DQS_DOUT_CSO_B_14,	Sch name = QSPI_CSN
#set_property PACKAGE_PIN L13 [get_ports QspiCSn]
#set_property IOSTANDARD LVCMOS33 [get_ports QspiCSn]



##Cellular RAM
##Bank = 14, Pin name = IO_L14N_T2_SRCC_14,					Sch name = CRAM_CLK
#set_property PACKAGE_PIN T15 [get_ports RamCLK]
#set_property IOSTANDARD LVCMOS33 [get_ports RamCLK]
##Bank = 14, Pin name = IO_L23P_T3_A03_D19_14,				Sch name = CRAM_ADVN
#set_property PACKAGE_PIN T13 [get_ports RamADVn]
#set_property IOSTANDARD LVCMOS33 [get_ports RamADVn]
##Bank = 14, Pin name = IO_L4P_T0_D04_14,					Sch name = CRAM_CEN
#set_property PACKAGE_PIN L18 [get_ports RamCEn]
#set_property IOSTANDARD LVCMOS33 [get_ports RamCEn]
##Bank = 15, Pin name = IO_L19P_T3_A22_15,					Sch name = CRAM_CRE
#set_property PACKAGE_PIN J14 [get_ports RamCRE]
#set_property IOSTANDARD LVCMOS33 [get_ports RamCRE]
##Bank = 15, Pin name = IO_L15P_T2_DQS_15,					Sch name = CRAM_OEN
#set_property PACKAGE_PIN H14 [get_ports RamOEn]
#set_property IOSTANDARD LVCMOS33 [get_ports RamOEn]
##Bank = 14, Pin name = IO_0_14,								Sch name = CRAM_WEN
#set_property PACKAGE_PIN R11 [get_ports RamWEn]
#set_property IOSTANDARD LVCMOS33 [get_ports RamWEn]
##Bank = 15, Pin name = IO_L24N_T3_RS0_15,					Sch name = CRAM_LBN
#set_property PACKAGE_PIN J15 [get_ports RamLBn]
#set_property IOSTANDARD LVCMOS33 [get_ports RamLBn]
##Bank = 15, Pin name = IO_L17N_T2_A25_15,					Sch name = CRAM_UBN
#set_property PACKAGE_PIN J13 [get_ports RamUBn]
#set_property IOSTANDARD LVCMOS33 [get_ports RamUBn]
##Bank = 14, Pin name = IO_L14P_T2_SRCC_14,					Sch name = CRAM_WAIT
#set_property PACKAGE_PIN T14 [get_ports RamWait]
#set_property IOSTANDARD LVCMOS33 [get_ports RamWait]

##Bank = 14, Pin name = IO_L5P_T0_DQ06_14,					Sch name = CRAM_DQ0
#set_property PACKAGE_PIN R12 [get_ports {MemDB[0]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {MemDB[0]}]
##Bank = 14, Pin name = IO_L19P_T3_A10_D26_14,				Sch name = CRAM_DQ1
#set_property PACKAGE_PIN T11 [get_ports {MemDB[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {MemDB[1]}]
##Bank = 14, Pin name = IO_L20P_T3_A08)D24_14,				Sch name = CRAM_DQ2
#set_property PACKAGE_PIN U12 [get_ports {MemDB[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {MemDB[2]}]
##Bank = 14, Pin name = IO_L5N_T0_D07_14,					Sch name = CRAM_DQ3
#set_property PACKAGE_PIN R13 [get_ports {MemDB[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {MemDB[3]}]
##Bank = 14, Pin name = IO_L17N_T2_A13_D29_14,				Sch name = CRAM_DQ4
#set_property PACKAGE_PIN U18 [get_ports {MemDB[4]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {MemDB[4]}]
##Bank = 14, Pin name = IO_L12N_T1_MRCC_14,					Sch name = CRAM_DQ5
#set_property PACKAGE_PIN R17 [get_ports {MemDB[5]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {MemDB[5]}]
##Bank = 14, Pin name = IO_L7N_T1_D10_14,					Sch name = CRAM_DQ6
#set_property PACKAGE_PIN T18 [get_ports {MemDB[6]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {MemDB[6]}]
##Bank = 14, Pin name = IO_L7P_T1_D09_14,					Sch name = CRAM_DQ7
#set_property PACKAGE_PIN R18 [get_ports {MemDB[7]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {MemDB[7]}]
##Bank = 15, Pin name = IO_L22N_T3_A16_15,					Sch name = CRAM_DQ8
#set_property PACKAGE_PIN F18 [get_ports {MemDB[8]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {MemDB[8]}]
##Bank = 15, Pin name = IO_L22P_T3_A17_15,					Sch name = CRAM_DQ9
#set_property PACKAGE_PIN G18 [get_ports {MemDB[9]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {MemDB[9]}]
##Bank = 15, Pin name = IO_IO_L18N_T2_A23_15,				Sch name = CRAM_DQ10
#set_property PACKAGE_PIN G17 [get_ports {MemDB[10]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {MemDB[10]}]
##Bank = 14, Pin name = IO_L4N_T0_D05_14,					Sch name = CRAM_DQ11
#set_property PACKAGE_PIN M18 [get_ports {MemDB[11]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {MemDB[11]}]
##Bank = 14, Pin name = IO_L10N_T1_D15_14,					Sch name = CRAM_DQ12
#set_property PACKAGE_PIN M17 [get_ports {MemDB[12]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {MemDB[12]}]
##Bank = 14, Pin name = IO_L9N_T1_DQS_D13_14,				Sch name = CRAM_DQ13
#set_property PACKAGE_PIN P18 [get_ports {MemDB[13]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {MemDB[13]}]
##Bank = 14, Pin name = IO_L9P_T1_DQS_14,					Sch name = CRAM_DQ14
#set_property PACKAGE_PIN N17 [get_ports {MemDB[14]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {MemDB[14]}]
##Bank = 14, Pin name = IO_L12P_T1_MRCC_14,					Sch name = CRAM_DQ15
#set_property PACKAGE_PIN P17 [get_ports {MemDB[15]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {MemDB[15]}]

##Bank = 15, Pin name = IO_L23N_T3_FWE_B_15,					Sch name = CRAM_A0
#set_property PACKAGE_PIN J18 [get_ports {MemAdr[0]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {MemAdr[0]}]
##Bank = 15, Pin name = IO_L18P_T2_A24_15,					Sch name = CRAM_A1
#set_property PACKAGE_PIN H17 [get_ports {MemAdr[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {MemAdr[1]}]
##Bank = 15, Pin name = IO_L19N_T3_A21_VREF_15,				Sch name = CRAM_A2
#set_property PACKAGE_PIN H15 [get_ports {MemAdr[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {MemAdr[2]}]
##Bank = 15, Pin name = IO_L23P_T3_FOE_B_15,					Sch name = CRAM_A3
#set_property PACKAGE_PIN J17 [get_ports {MemAdr[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {MemAdr[3]}]
##Bank = 15, Pin name = IO_L13P_T2_MRCC_15,					Sch name = CRAM_A4
#set_property PACKAGE_PIN H16 [get_ports {MemAdr[4]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {MemAdr[4]}]
##Bank = 15, Pin name = IO_L24P_T3_RS1_15,					Sch name = CRAM_A5
#set_property PACKAGE_PIN K15 [get_ports {MemAdr[5]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {MemAdr[5]}]
##Bank = 15, Pin name = IO_L17P_T2_A26_15,					Sch name = CRAM_A6
#set_property PACKAGE_PIN K13 [get_ports {MemAdr[6]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {MemAdr[6]}]
##Bank = 14, Pin name = IO_L11P_T1_SRCC_14,					Sch name = CRAM_A7
#set_property PACKAGE_PIN N15 [get_ports {MemAdr[7]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {MemAdr[7]}]
##Bank = 14, Pin name = IO_L16N_T2_SRCC-14,					Sch name = CRAM_A8
#set_property PACKAGE_PIN V16 [get_ports {MemAdr[8]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {MemAdr[8]}]
##Bank = 14, Pin name = IO_L22P_T3_A05_D21_14,				Sch name = CRAM_A9
#set_property PACKAGE_PIN U14 [get_ports {MemAdr[9]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {MemAdr[9]}]
##Bank = 14, Pin name = IO_L22N_T3_A04_D20_14,				Sch name = CRAM_A10
#set_property PACKAGE_PIN V14 [get_ports {MemAdr[10]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {MemAdr[10]}]
##Bank = 14, Pin name = IO_L20N_T3_A07_D23_14,				Sch name = CRAM_A11
#set_property PACKAGE_PIN V12 [get_ports {MemAdr[11]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {MemAdr[11]}]
##Bank = 14, Pin name = IO_L8N_T1_D12_14,					Sch name = CRAM_A12
#set_property PACKAGE_PIN P14 [get_ports {MemAdr[12]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {MemAdr[12]}]
##Bank = 14, Pin name = IO_L18P_T2_A12_D28_14,				Sch name = CRAM_A13
#set_property PACKAGE_PIN U16 [get_ports {MemAdr[13]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {MemAdr[13]}]
##Bank = 14, Pin name = IO_L13N_T2_MRCC_14,					Sch name = CRAM_A14
#set_property PACKAGE_PIN R15 [get_ports {MemAdr[14]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {MemAdr[14]}]
##Bank = 14, Pin name = IO_L8P_T1_D11_14,					Sch name = CRAM_A15
#set_property PACKAGE_PIN N14 [get_ports {MemAdr[15]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {MemAdr[15]}]
##Bank = 14, Pin name = IO_L11N_T1_SRCC_14,					Sch name = CRAM_A16
#set_property PACKAGE_PIN N16 [get_ports {MemAdr[16]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {MemAdr[16]}]
##Bank = 14, Pin name = IO_L6N_T0_D08_VREF_14,				Sch name = CRAM_A17
#set_property PACKAGE_PIN M13 [get_ports {MemAdr[17]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {MemAdr[17]}]
##Bank = 14, Pin name = IO_L18N_T2_A11_D27_14,				Sch name = CRAM_A18
#set_property PACKAGE_PIN V17 [get_ports {MemAdr[18]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {MemAdr[18]}]
##Bank = 14, Pin name = IO_L17P_T2_A14_D30_14,				Sch name = CRAM_A19
#set_property PACKAGE_PIN U17 [get_ports {MemAdr[19]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {MemAdr[19]}]
##Bank = 14, Pin name = IO_L24N_T3_A00_D16_14,				Sch name = CRAM_A20
#set_property PACKAGE_PIN T10 [get_ports {MemAdr[20]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {MemAdr[20]}]
##Bank = 14, Pin name = IO_L10P_T1_D14_14,					Sch name = CRAM_A21
#set_property PACKAGE_PIN M16 [get_ports {MemAdr[21]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {MemAdr[21]}]
##Bank = 14, Pin name = IO_L23N_T3_A02_D18_14,				Sch name = CRAM_A22
#set_property PACKAGE_PIN U13 [get_ports {MemAdr[22]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {MemAdr[22]}]

set_property MARK_DEBUG true [get_nets event_data_in_channel_halt_f]
set_property MARK_DEBUG true [get_nets event_data_in_channel_halt_r]
set_property MARK_DEBUG true [get_nets event_data_out_channel_halt_f]
set_property MARK_DEBUG true [get_nets event_data_out_channel_halt_r]
set_property MARK_DEBUG true [get_nets event_frame_started_f]
set_property MARK_DEBUG true [get_nets event_frame_started_r]
set_property MARK_DEBUG true [get_nets event_status_channel_halt_f]
set_property MARK_DEBUG true [get_nets event_status_channel_halt_r]
set_property MARK_DEBUG true [get_nets event_tlast_missing_f]
set_property MARK_DEBUG true [get_nets event_tlast_missing_r]
set_property MARK_DEBUG true [get_nets event_tlast_unexpected_f]
set_property MARK_DEBUG true [get_nets event_tlast_unexpected_r]
set_property MARK_DEBUG true [get_nets fft_rst]
set_property MARK_DEBUG true [get_nets led_s]
set_property MARK_DEBUG true [get_nets mult_a_tlast]
set_property MARK_DEBUG true [get_nets mult_b_tvalid]
set_property MARK_DEBUG true [get_nets mult_tready]
set_property MARK_DEBUG true [get_nets rst]
set_property MARK_DEBUG true [get_nets samp_f_ram_wea]
set_property MARK_DEBUG true [get_nets samp_ram_wea]
set_property MARK_DEBUG true [get_nets threshold_check]
set_property MARK_DEBUG true [get_nets threshold_detected]
set_property MARK_DEBUG true [get_nets tx_finished]
set_property MARK_DEBUG true [get_nets uart_tx_done]
set_property MARK_DEBUG true [get_nets uart_tx_start]
set_property MARK_DEBUG true [get_nets {xcorr_ram_addrb[12]}]
set_property MARK_DEBUG true [get_nets {xcorr_ram_addrb[11]}]
set_property MARK_DEBUG true [get_nets {xcorr_ram_addrb[10]}]
set_property MARK_DEBUG true [get_nets {xcorr_ram_addrb[9]}]
set_property MARK_DEBUG true [get_nets {xcorr_ram_addrb[8]}]
set_property MARK_DEBUG true [get_nets {xcorr_ram_addrb[7]}]
set_property MARK_DEBUG true [get_nets {xcorr_ram_addrb[6]}]
set_property MARK_DEBUG true [get_nets {xcorr_ram_addrb[5]}]
set_property MARK_DEBUG true [get_nets {xcorr_ram_addrb[4]}]
set_property MARK_DEBUG true [get_nets {xcorr_ram_addrb[3]}]
set_property MARK_DEBUG true [get_nets {xcorr_ram_addrb[2]}]
set_property MARK_DEBUG true [get_nets {xcorr_ram_addrb[1]}]
set_property MARK_DEBUG true [get_nets {xcorr_ram_addrb[0]}]
set_property MARK_DEBUG true [get_nets {xcorr_ram_addra[6]}]
set_property MARK_DEBUG true [get_nets {xcorr_ram_addra[12]}]
set_property MARK_DEBUG true [get_nets {xcorr_ram_addra[11]}]
set_property MARK_DEBUG true [get_nets {xcorr_ram_addra[10]}]
set_property MARK_DEBUG true [get_nets {xcorr_ram_addra[9]}]
set_property MARK_DEBUG true [get_nets {xcorr_ram_addra[8]}]
set_property MARK_DEBUG true [get_nets {xcorr_ram_addra[7]}]
set_property MARK_DEBUG true [get_nets {xcorr_ram_addra[0]}]
set_property MARK_DEBUG true [get_nets {xcorr_ram_addra[1]}]
set_property MARK_DEBUG true [get_nets {xcorr_ram_addra[2]}]
set_property MARK_DEBUG true [get_nets {xcorr_ram_addra[3]}]
set_property MARK_DEBUG true [get_nets {xcorr_ram_addra[4]}]
set_property MARK_DEBUG true [get_nets {xcorr_ram_addra[5]}]
set_property MARK_DEBUG true [get_nets s_axis_data_tvalid_r]
set_property MARK_DEBUG true [get_nets s_axis_data_tready_r]
set_property MARK_DEBUG true [get_nets s_axis_data_tvalid_f]
set_property MARK_DEBUG true [get_nets s_axis_data_tlast_f]
set_property MARK_DEBUG true [get_nets s_axis_config_tvalid_r]
set_property MARK_DEBUG true [get_nets s_axis_data_tready_f]
set_property MARK_DEBUG true [get_nets m_axis_data_tlast_r]
set_property MARK_DEBUG true [get_nets s_axis_data_tlast_r]
set_property MARK_DEBUG true [get_nets m_axis_data_tlast_f]
set_property MARK_DEBUG true [get_nets m_axis_data_tready_r]
set_property MARK_DEBUG true [get_nets rxbyte_ready]
set_property MARK_DEBUG true [get_nets m_axis_data_tready_f]
set_property MARK_DEBUG true [get_nets m_axis_data_tvalid_r]
set_property MARK_DEBUG true [get_nets s_axis_config_tready_r]
set_property MARK_DEBUG true [get_nets m_axis_data_tvalid_f]
set_property MARK_DEBUG true [get_nets s_axis_config_tready_f]
set_property MARK_DEBUG true [get_nets tx_ready]
set_property MARK_DEBUG true [get_nets {control/state_config_fft[0]}]
set_property MARK_DEBUG true [get_nets {control/state_xcorr[1]}]
set_property MARK_DEBUG true [get_nets {control/state_xcorr[0]}]
set_property MARK_DEBUG true [get_nets {control/state_adc[1]}]
set_property MARK_DEBUG true [get_nets {control/state_cmd_decode[1]}]
set_property MARK_DEBUG true [get_nets {control/state_loop[2]}]
set_property MARK_DEBUG true [get_nets {control/state_loop[1]}]
set_property MARK_DEBUG true [get_nets {control/state_loop[0]}]
set_property MARK_DEBUG true [get_nets {control/state_cmd_decode[0]}]
set_property MARK_DEBUG true [get_nets {control/state_adc[0]}]
set_property MARK_DEBUG true [get_nets {control/state_fwd_fft[2]}]
set_property MARK_DEBUG true [get_nets {control/state_fwd_fft[1]}]
set_property MARK_DEBUG true [get_nets {control/state_fwd_fft[0]}]
set_property MARK_DEBUG true [get_nets {control/state_adc[2]}]
set_property MARK_DEBUG true [get_nets {control/state_config_fft[2]}]
set_property MARK_DEBUG true [get_nets {control/state_config_fft[1]}]
set_property MARK_DEBUG true [get_nets {control/samp_ram_addrb_s[10]}]
set_property MARK_DEBUG true [get_nets {control/samp_ram_addrb_s[9]}]
set_property MARK_DEBUG true [get_nets {control/samp_ram_addrb_s[2]}]
set_property MARK_DEBUG true [get_nets {control/samp_ram_addrb_s[6]}]
set_property MARK_DEBUG true [get_nets {control/samp_ram_addrb_s[11]}]
set_property MARK_DEBUG true [get_nets {control/samp_ram_addrb_s[3]}]
set_property MARK_DEBUG true [get_nets {control/samp_ram_addrb_s[8]}]
set_property MARK_DEBUG true [get_nets {control/samp_ram_addrb_s[4]}]
set_property MARK_DEBUG true [get_nets {control/samp_ram_addrb_s[5]}]
set_property MARK_DEBUG true [get_nets {control/samp_ram_addrb_s[12]}]
set_property MARK_DEBUG true [get_nets {control/samp_ram_addrb_s[1]}]
set_property MARK_DEBUG true [get_nets {control/samp_ram_addrb_s[7]}]
set_property MARK_DEBUG true [get_nets control/run]
set_property MARK_DEBUG true [get_nets control/threshold_flag]
set_property MARK_DEBUG true [get_nets control/samp_ram_flag]
set_property MARK_DEBUG true [get_nets control/zp]

set_property MARK_DEBUG true [get_nets {fp_ram_addrb[0]}]
set_property MARK_DEBUG true [get_nets {fp_ram_addrb[1]}]
set_property MARK_DEBUG true [get_nets {fp_ram_addrb[2]}]
set_property MARK_DEBUG true [get_nets {fp_ram_addrb[3]}]
set_property MARK_DEBUG true [get_nets {fp_ram_addrb[4]}]
set_property MARK_DEBUG true [get_nets {fp_ram_addrb[5]}]
set_property MARK_DEBUG true [get_nets {fp_ram_addrb[6]}]
set_property MARK_DEBUG true [get_nets {fp_ram_addrb[7]}]
set_property MARK_DEBUG true [get_nets {fp_ram_addrb[8]}]
set_property MARK_DEBUG true [get_nets {fp_ram_addrb[9]}]
set_property MARK_DEBUG true [get_nets {fp_ram_addrb[10]}]
set_property MARK_DEBUG true [get_nets {fp_ram_addrb[11]}]
set_property MARK_DEBUG true [get_nets {fp_ram_addrb[12]}]
set_property MARK_DEBUG true [get_nets {samp_f_ram_addra[0]}]
set_property MARK_DEBUG true [get_nets {samp_f_ram_addra[1]}]
set_property MARK_DEBUG true [get_nets {samp_f_ram_addra[2]}]
set_property MARK_DEBUG true [get_nets {samp_f_ram_addra[3]}]
set_property MARK_DEBUG true [get_nets {samp_f_ram_addra[4]}]
set_property MARK_DEBUG true [get_nets {samp_f_ram_addra[5]}]
set_property MARK_DEBUG true [get_nets {samp_f_ram_addra[6]}]
set_property MARK_DEBUG true [get_nets {samp_f_ram_addra[7]}]
set_property MARK_DEBUG true [get_nets {samp_f_ram_addra[8]}]
set_property MARK_DEBUG true [get_nets {samp_f_ram_addra[9]}]
set_property MARK_DEBUG true [get_nets {samp_f_ram_addra[10]}]
set_property MARK_DEBUG true [get_nets {samp_f_ram_addra[11]}]
set_property MARK_DEBUG true [get_nets {samp_f_ram_addra[12]}]
set_property MARK_DEBUG true [get_nets {samp_f_ram_addrb[0]}]
set_property MARK_DEBUG true [get_nets {samp_f_ram_addrb[1]}]
set_property MARK_DEBUG true [get_nets {samp_f_ram_addrb[2]}]
set_property MARK_DEBUG true [get_nets {samp_f_ram_addrb[3]}]
set_property MARK_DEBUG true [get_nets {samp_f_ram_addrb[4]}]
set_property MARK_DEBUG true [get_nets {samp_f_ram_addrb[5]}]
set_property MARK_DEBUG true [get_nets {samp_f_ram_addrb[6]}]
set_property MARK_DEBUG true [get_nets {samp_f_ram_addrb[7]}]
set_property MARK_DEBUG true [get_nets {samp_f_ram_addrb[8]}]
set_property MARK_DEBUG true [get_nets {samp_f_ram_addrb[9]}]
set_property MARK_DEBUG true [get_nets {samp_f_ram_addrb[10]}]
set_property MARK_DEBUG true [get_nets {samp_f_ram_addrb[11]}]
set_property MARK_DEBUG true [get_nets {samp_f_ram_addrb[12]}]
set_property MARK_DEBUG true [get_nets {samp_ram_addra[0]}]
set_property MARK_DEBUG true [get_nets {samp_ram_addra[1]}]
set_property MARK_DEBUG true [get_nets {samp_ram_addra[2]}]
set_property MARK_DEBUG true [get_nets {samp_ram_addra[3]}]
set_property MARK_DEBUG true [get_nets {samp_ram_addra[4]}]
set_property MARK_DEBUG true [get_nets {samp_ram_addra[5]}]
set_property MARK_DEBUG true [get_nets {samp_ram_addra[6]}]
set_property MARK_DEBUG true [get_nets {samp_ram_addra[7]}]
set_property MARK_DEBUG true [get_nets {samp_ram_addra[8]}]
set_property MARK_DEBUG true [get_nets {samp_ram_addra[9]}]
set_property MARK_DEBUG true [get_nets {samp_ram_addra[10]}]
set_property MARK_DEBUG true [get_nets {samp_ram_addra[11]}]
set_property MARK_DEBUG true [get_nets {samp_ram_addra[12]}]
set_property MARK_DEBUG true [get_nets {samp_ram_addrb[0]}]
set_property MARK_DEBUG true [get_nets {samp_ram_addrb[1]}]
set_property MARK_DEBUG true [get_nets {samp_ram_addrb[2]}]
set_property MARK_DEBUG true [get_nets {samp_ram_addrb[3]}]
set_property MARK_DEBUG true [get_nets {samp_ram_addrb[4]}]
set_property MARK_DEBUG true [get_nets {samp_ram_addrb[5]}]
set_property MARK_DEBUG true [get_nets {samp_ram_addrb[6]}]
set_property MARK_DEBUG true [get_nets {samp_ram_addrb[7]}]
set_property MARK_DEBUG true [get_nets {samp_ram_addrb[8]}]
set_property MARK_DEBUG true [get_nets {samp_ram_addrb[9]}]
set_property MARK_DEBUG true [get_nets {samp_ram_addrb[10]}]
set_property MARK_DEBUG true [get_nets {samp_ram_addrb[11]}]
set_property MARK_DEBUG true [get_nets {samp_ram_addrb[12]}]
create_debug_core u_ila_0_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0_0]
set_property C_DATA_DEPTH 8192 [get_debug_cores u_ila_0_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0_0]
set_property port_width 1 [get_debug_ports u_ila_0_0/clk]
connect_debug_port u_ila_0_0/clk [get_nets [list xlnx_opt_]]
set_property port_width 3 [get_debug_ports u_ila_0_0/probe0]
connect_debug_port u_ila_0_0/probe0 [get_nets [list {control/state_adc[0]} {control/state_adc[1]} {control/state_adc[2]}]]
create_debug_port u_ila_0_0 probe
set_property port_width 2 [get_debug_ports u_ila_0_0/probe1]
connect_debug_port u_ila_0_0/probe1 [get_nets [list {control/state_cmd_decode[0]} {control/state_cmd_decode[1]}]]
create_debug_port u_ila_0_0 probe
set_property port_width 3 [get_debug_ports u_ila_0_0/probe2]
connect_debug_port u_ila_0_0/probe2 [get_nets [list {control/state_config_fft[0]} {control/state_config_fft[1]} {control/state_config_fft[2]}]]
create_debug_port u_ila_0_0 probe
set_property port_width 3 [get_debug_ports u_ila_0_0/probe3]
connect_debug_port u_ila_0_0/probe3 [get_nets [list {control/state_fwd_fft[0]} {control/state_fwd_fft[1]} {control/state_fwd_fft[2]}]]
create_debug_port u_ila_0_0 probe
set_property port_width 3 [get_debug_ports u_ila_0_0/probe4]
connect_debug_port u_ila_0_0/probe4 [get_nets [list {control/state_loop[0]} {control/state_loop[1]} {control/state_loop[2]}]]
create_debug_port u_ila_0_0 probe
set_property port_width 2 [get_debug_ports u_ila_0_0/probe5]
connect_debug_port u_ila_0_0/probe5 [get_nets [list {control/state_xcorr[0]} {control/state_xcorr[1]}]]
create_debug_port u_ila_0_0 probe
set_property port_width 13 [get_debug_ports u_ila_0_0/probe6]
connect_debug_port u_ila_0_0/probe6 [get_nets [list {fp_ram_addrb[0]} {fp_ram_addrb[1]} {fp_ram_addrb[2]} {fp_ram_addrb[3]} {fp_ram_addrb[4]} {fp_ram_addrb[5]} {fp_ram_addrb[6]} {fp_ram_addrb[7]} {fp_ram_addrb[8]} {fp_ram_addrb[9]} {fp_ram_addrb[10]} {fp_ram_addrb[11]} {fp_ram_addrb[12]}]]
create_debug_port u_ila_0_0 probe
set_property port_width 13 [get_debug_ports u_ila_0_0/probe7]
connect_debug_port u_ila_0_0/probe7 [get_nets [list {samp_f_ram_addra[0]} {samp_f_ram_addra[1]} {samp_f_ram_addra[2]} {samp_f_ram_addra[3]} {samp_f_ram_addra[4]} {samp_f_ram_addra[5]} {samp_f_ram_addra[6]} {samp_f_ram_addra[7]} {samp_f_ram_addra[8]} {samp_f_ram_addra[9]} {samp_f_ram_addra[10]} {samp_f_ram_addra[11]} {samp_f_ram_addra[12]}]]
create_debug_port u_ila_0_0 probe
set_property port_width 13 [get_debug_ports u_ila_0_0/probe8]
connect_debug_port u_ila_0_0/probe8 [get_nets [list {samp_f_ram_addrb[0]} {samp_f_ram_addrb[1]} {samp_f_ram_addrb[2]} {samp_f_ram_addrb[3]} {samp_f_ram_addrb[4]} {samp_f_ram_addrb[5]} {samp_f_ram_addrb[6]} {samp_f_ram_addrb[7]} {samp_f_ram_addrb[8]} {samp_f_ram_addrb[9]} {samp_f_ram_addrb[10]} {samp_f_ram_addrb[11]} {samp_f_ram_addrb[12]}]]
create_debug_port u_ila_0_0 probe
set_property port_width 13 [get_debug_ports u_ila_0_0/probe9]
connect_debug_port u_ila_0_0/probe9 [get_nets [list {samp_ram_addra[0]} {samp_ram_addra[1]} {samp_ram_addra[2]} {samp_ram_addra[3]} {samp_ram_addra[4]} {samp_ram_addra[5]} {samp_ram_addra[6]} {samp_ram_addra[7]} {samp_ram_addra[8]} {samp_ram_addra[9]} {samp_ram_addra[10]} {samp_ram_addra[11]} {samp_ram_addra[12]}]]
create_debug_port u_ila_0_0 probe
set_property port_width 13 [get_debug_ports u_ila_0_0/probe10]
connect_debug_port u_ila_0_0/probe10 [get_nets [list {samp_ram_addrb[0]} {samp_ram_addrb[1]} {samp_ram_addrb[2]} {samp_ram_addrb[3]} {samp_ram_addrb[4]} {samp_ram_addrb[5]} {samp_ram_addrb[6]} {samp_ram_addrb[7]} {samp_ram_addrb[8]} {samp_ram_addrb[9]} {samp_ram_addrb[10]} {samp_ram_addrb[11]} {samp_ram_addrb[12]}]]
create_debug_port u_ila_0_0 probe
set_property port_width 14 [get_debug_ports u_ila_0_0/probe11]
connect_debug_port u_ila_0_0/probe11 [get_nets [list {scaling_sch[0]} {scaling_sch[1]} {scaling_sch[2]} {scaling_sch[3]} {scaling_sch[4]} {scaling_sch[5]} {scaling_sch[6]} {scaling_sch[7]} {scaling_sch[8]} {scaling_sch[9]} {scaling_sch[10]} {scaling_sch[11]} {scaling_sch[12]} {scaling_sch[13]}]]
create_debug_port u_ila_0_0 probe
set_property port_width 13 [get_debug_ports u_ila_0_0/probe12]
connect_debug_port u_ila_0_0/probe12 [get_nets [list {xcorr_ram_addra[0]} {xcorr_ram_addra[1]} {xcorr_ram_addra[2]} {xcorr_ram_addra[3]} {xcorr_ram_addra[4]} {xcorr_ram_addra[5]} {xcorr_ram_addra[6]} {xcorr_ram_addra[7]} {xcorr_ram_addra[8]} {xcorr_ram_addra[9]} {xcorr_ram_addra[10]} {xcorr_ram_addra[11]} {xcorr_ram_addra[12]}]]
create_debug_port u_ila_0_0 probe
set_property port_width 13 [get_debug_ports u_ila_0_0/probe13]
connect_debug_port u_ila_0_0/probe13 [get_nets [list {xcorr_ram_addrb[0]} {xcorr_ram_addrb[1]} {xcorr_ram_addrb[2]} {xcorr_ram_addrb[3]} {xcorr_ram_addrb[4]} {xcorr_ram_addrb[5]} {xcorr_ram_addrb[6]} {xcorr_ram_addrb[7]} {xcorr_ram_addrb[8]} {xcorr_ram_addrb[9]} {xcorr_ram_addrb[10]} {xcorr_ram_addrb[11]} {xcorr_ram_addrb[12]}]]
create_debug_port u_ila_0_0 probe
set_property port_width 1 [get_debug_ports u_ila_0_0/probe14]
connect_debug_port u_ila_0_0/probe14 [get_nets [list event_data_in_channel_halt_f]]
create_debug_port u_ila_0_0 probe
set_property port_width 1 [get_debug_ports u_ila_0_0/probe15]
connect_debug_port u_ila_0_0/probe15 [get_nets [list event_data_in_channel_halt_r]]
create_debug_port u_ila_0_0 probe
set_property port_width 1 [get_debug_ports u_ila_0_0/probe16]
connect_debug_port u_ila_0_0/probe16 [get_nets [list event_data_out_channel_halt_f]]
create_debug_port u_ila_0_0 probe
set_property port_width 1 [get_debug_ports u_ila_0_0/probe17]
connect_debug_port u_ila_0_0/probe17 [get_nets [list event_data_out_channel_halt_r]]
create_debug_port u_ila_0_0 probe
set_property port_width 1 [get_debug_ports u_ila_0_0/probe18]
connect_debug_port u_ila_0_0/probe18 [get_nets [list event_frame_started_f]]
create_debug_port u_ila_0_0 probe
set_property port_width 1 [get_debug_ports u_ila_0_0/probe19]
connect_debug_port u_ila_0_0/probe19 [get_nets [list event_frame_started_r]]
create_debug_port u_ila_0_0 probe
set_property port_width 1 [get_debug_ports u_ila_0_0/probe20]
connect_debug_port u_ila_0_0/probe20 [get_nets [list event_status_channel_halt_f]]
create_debug_port u_ila_0_0 probe
set_property port_width 1 [get_debug_ports u_ila_0_0/probe21]
connect_debug_port u_ila_0_0/probe21 [get_nets [list event_status_channel_halt_r]]
create_debug_port u_ila_0_0 probe
set_property port_width 1 [get_debug_ports u_ila_0_0/probe22]
connect_debug_port u_ila_0_0/probe22 [get_nets [list event_tlast_missing_f]]
create_debug_port u_ila_0_0 probe
set_property port_width 1 [get_debug_ports u_ila_0_0/probe23]
connect_debug_port u_ila_0_0/probe23 [get_nets [list event_tlast_missing_r]]
create_debug_port u_ila_0_0 probe
set_property port_width 1 [get_debug_ports u_ila_0_0/probe24]
connect_debug_port u_ila_0_0/probe24 [get_nets [list event_tlast_unexpected_f]]
create_debug_port u_ila_0_0 probe
set_property port_width 1 [get_debug_ports u_ila_0_0/probe25]
connect_debug_port u_ila_0_0/probe25 [get_nets [list event_tlast_unexpected_r]]
create_debug_port u_ila_0_0 probe
set_property port_width 1 [get_debug_ports u_ila_0_0/probe26]
connect_debug_port u_ila_0_0/probe26 [get_nets [list fft_rst]]
create_debug_port u_ila_0_0 probe
set_property port_width 1 [get_debug_ports u_ila_0_0/probe27]
connect_debug_port u_ila_0_0/probe27 [get_nets [list led_s]]
create_debug_port u_ila_0_0 probe
set_property port_width 1 [get_debug_ports u_ila_0_0/probe28]
connect_debug_port u_ila_0_0/probe28 [get_nets [list m_axis_data_tlast_f]]
create_debug_port u_ila_0_0 probe
set_property port_width 1 [get_debug_ports u_ila_0_0/probe29]
connect_debug_port u_ila_0_0/probe29 [get_nets [list m_axis_data_tlast_r]]
create_debug_port u_ila_0_0 probe
set_property port_width 1 [get_debug_ports u_ila_0_0/probe30]
connect_debug_port u_ila_0_0/probe30 [get_nets [list m_axis_data_tready_f]]
create_debug_port u_ila_0_0 probe
set_property port_width 1 [get_debug_ports u_ila_0_0/probe31]
connect_debug_port u_ila_0_0/probe31 [get_nets [list m_axis_data_tready_r]]
create_debug_port u_ila_0_0 probe
set_property port_width 1 [get_debug_ports u_ila_0_0/probe32]
connect_debug_port u_ila_0_0/probe32 [get_nets [list m_axis_data_tvalid_f]]
create_debug_port u_ila_0_0 probe
set_property port_width 1 [get_debug_ports u_ila_0_0/probe33]
connect_debug_port u_ila_0_0/probe33 [get_nets [list m_axis_data_tvalid_r]]
create_debug_port u_ila_0_0 probe
set_property port_width 1 [get_debug_ports u_ila_0_0/probe34]
connect_debug_port u_ila_0_0/probe34 [get_nets [list mult_a_tlast]]
create_debug_port u_ila_0_0 probe
set_property port_width 1 [get_debug_ports u_ila_0_0/probe35]
connect_debug_port u_ila_0_0/probe35 [get_nets [list mult_b_tvalid]]
create_debug_port u_ila_0_0 probe
set_property port_width 1 [get_debug_ports u_ila_0_0/probe36]
connect_debug_port u_ila_0_0/probe36 [get_nets [list mult_tready]]
create_debug_port u_ila_0_0 probe
set_property port_width 1 [get_debug_ports u_ila_0_0/probe37]
connect_debug_port u_ila_0_0/probe37 [get_nets [list rst]]
create_debug_port u_ila_0_0 probe
set_property port_width 1 [get_debug_ports u_ila_0_0/probe38]
connect_debug_port u_ila_0_0/probe38 [get_nets [list control/run]]
create_debug_port u_ila_0_0 probe
set_property port_width 1 [get_debug_ports u_ila_0_0/probe39]
connect_debug_port u_ila_0_0/probe39 [get_nets [list rxbyte_ready]]
create_debug_port u_ila_0_0 probe
set_property port_width 1 [get_debug_ports u_ila_0_0/probe40]
connect_debug_port u_ila_0_0/probe40 [get_nets [list s_axis_config_tready_f]]
create_debug_port u_ila_0_0 probe
set_property port_width 1 [get_debug_ports u_ila_0_0/probe41]
connect_debug_port u_ila_0_0/probe41 [get_nets [list s_axis_config_tready_r]]
create_debug_port u_ila_0_0 probe
set_property port_width 1 [get_debug_ports u_ila_0_0/probe42]
connect_debug_port u_ila_0_0/probe42 [get_nets [list s_axis_config_tvalid_r]]
create_debug_port u_ila_0_0 probe
set_property port_width 1 [get_debug_ports u_ila_0_0/probe43]
connect_debug_port u_ila_0_0/probe43 [get_nets [list s_axis_data_tlast_f]]
create_debug_port u_ila_0_0 probe
set_property port_width 1 [get_debug_ports u_ila_0_0/probe44]
connect_debug_port u_ila_0_0/probe44 [get_nets [list s_axis_data_tlast_r]]
create_debug_port u_ila_0_0 probe
set_property port_width 1 [get_debug_ports u_ila_0_0/probe45]
connect_debug_port u_ila_0_0/probe45 [get_nets [list s_axis_data_tready_f]]
create_debug_port u_ila_0_0 probe
set_property port_width 1 [get_debug_ports u_ila_0_0/probe46]
connect_debug_port u_ila_0_0/probe46 [get_nets [list s_axis_data_tready_r]]
create_debug_port u_ila_0_0 probe
set_property port_width 1 [get_debug_ports u_ila_0_0/probe47]
connect_debug_port u_ila_0_0/probe47 [get_nets [list s_axis_data_tvalid_f]]
create_debug_port u_ila_0_0 probe
set_property port_width 1 [get_debug_ports u_ila_0_0/probe48]
connect_debug_port u_ila_0_0/probe48 [get_nets [list s_axis_data_tvalid_r]]
create_debug_port u_ila_0_0 probe
set_property port_width 1 [get_debug_ports u_ila_0_0/probe49]
connect_debug_port u_ila_0_0/probe49 [get_nets [list samp_f_ram_wea]]
create_debug_port u_ila_0_0 probe
set_property port_width 1 [get_debug_ports u_ila_0_0/probe50]
connect_debug_port u_ila_0_0/probe50 [get_nets [list control/samp_ram_flag]]
create_debug_port u_ila_0_0 probe
set_property port_width 1 [get_debug_ports u_ila_0_0/probe51]
connect_debug_port u_ila_0_0/probe51 [get_nets [list samp_ram_wea]]
create_debug_port u_ila_0_0 probe
set_property port_width 1 [get_debug_ports u_ila_0_0/probe52]
connect_debug_port u_ila_0_0/probe52 [get_nets [list threshold_check]]
create_debug_port u_ila_0_0 probe
set_property port_width 1 [get_debug_ports u_ila_0_0/probe53]
connect_debug_port u_ila_0_0/probe53 [get_nets [list threshold_detected]]
create_debug_port u_ila_0_0 probe
set_property port_width 1 [get_debug_ports u_ila_0_0/probe54]
connect_debug_port u_ila_0_0/probe54 [get_nets [list control/threshold_flag]]
create_debug_port u_ila_0_0 probe
set_property port_width 1 [get_debug_ports u_ila_0_0/probe55]
connect_debug_port u_ila_0_0/probe55 [get_nets [list tx_finished]]
create_debug_port u_ila_0_0 probe
set_property port_width 1 [get_debug_ports u_ila_0_0/probe56]
connect_debug_port u_ila_0_0/probe56 [get_nets [list tx_ready]]
create_debug_port u_ila_0_0 probe
set_property port_width 1 [get_debug_ports u_ila_0_0/probe57]
connect_debug_port u_ila_0_0/probe57 [get_nets [list uart_tx_done]]
create_debug_port u_ila_0_0 probe
set_property port_width 1 [get_debug_ports u_ila_0_0/probe58]
connect_debug_port u_ila_0_0/probe58 [get_nets [list uart_tx_start]]
create_debug_port u_ila_0_0 probe
set_property port_width 1 [get_debug_ports u_ila_0_0/probe59]
connect_debug_port u_ila_0_0/probe59 [get_nets [list control/zp]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets xlnx_opt_]
