#########################################################
# Buttons
#########################################################
set_property -dict {PACKAGE_PIN C17 IOSTANDARD LVCMOS33} [get_ports btn0]
set_property -dict {PACKAGE_PIN C18 IOSTANDARD LVCMOS33} [get_ports btn1]

#########################################################
# RGB LEDs
#########################################################
set_property -dict {PACKAGE_PIN B17 IOSTANDARD LVCMOS33} [get_ports {led0[2]}]
set_property -dict {PACKAGE_PIN B16 IOSTANDARD LVCMOS33} [get_ports {led0[1]}]
set_property -dict {PACKAGE_PIN A17 IOSTANDARD LVCMOS33} [get_ports {led0[0]}]
set_property -dict {PACKAGE_PIN A19 IOSTANDARD LVCMOS33} [get_ports {led1[2]}]
set_property -dict {PACKAGE_PIN A18 IOSTANDARD LVCMOS33} [get_ports {led1[1]}]
set_property -dict {PACKAGE_PIN A16 IOSTANDARD LVCMOS33} [get_ports {led1[0]}]

#########################################################
# Syzygy Port A (ZMOD AWG module)
#########################################################
# AWG Clocks
set_property -dict {PACKAGE_PIN N19 IOSTANDARD LVCMOS18} [get_ports ZmodDAC_ClkIn]
set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVCMOS18} [get_ports ZmodDAC_ClkIO]

# AWG Data
set_property -dict {PACKAGE_PIN K19 IOSTANDARD LVCMOS18} [get_ports {dZmodDAC_Data[0]}]
set_property -dict {PACKAGE_PIN L18 IOSTANDARD LVCMOS18} [get_ports {dZmodDAC_Data[1]}]
set_property -dict {PACKAGE_PIN K18 IOSTANDARD LVCMOS18} [get_ports {dZmodDAC_Data[2]}]
set_property -dict {PACKAGE_PIN L22 IOSTANDARD LVCMOS18} [get_ports {dZmodDAC_Data[3]}]
set_property -dict {PACKAGE_PIN L19 IOSTANDARD LVCMOS18} [get_ports {dZmodDAC_Data[4]}]
set_property -dict {PACKAGE_PIN K20 IOSTANDARD LVCMOS18} [get_ports {dZmodDAC_Data[5]}]
set_property -dict {PACKAGE_PIN K21 IOSTANDARD LVCMOS18} [get_ports {dZmodDAC_Data[6]}]
set_property -dict {PACKAGE_PIN J20 IOSTANDARD LVCMOS18} [get_ports {dZmodDAC_Data[7]}]
set_property -dict {PACKAGE_PIN P15 IOSTANDARD LVCMOS18} [get_ports {dZmodDAC_Data[8]}]
set_property -dict {PACKAGE_PIN N15 IOSTANDARD LVCMOS18} [get_ports {dZmodDAC_Data[9]}]
set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVCMOS18} [get_ports {dZmodDAC_Data[10]}]
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS18} [get_ports {dZmodDAC_Data[11]}]
set_property -dict {PACKAGE_PIN T19 IOSTANDARD LVCMOS18} [get_ports {dZmodDAC_Data[12]}]
set_property -dict {PACKAGE_PIN R19 IOSTANDARD LVCMOS18} [get_ports {dZmodDAC_Data[13]}]

# AWG control signals
set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVCMOS18} [get_ports sZmodDAC_EnOut]
set_property -dict {PACKAGE_PIN T16 IOSTANDARD LVCMOS18} [get_ports sZmodDAC_SetFS1]
set_property -dict {PACKAGE_PIN T17 IOSTANDARD LVCMOS18} [get_ports sZmodDAC_SetFS2]
set_property -dict {PACKAGE_PIN R18 IOSTANDARD LVCMOS18} [get_ports sZmodDAC_Reset]

# AWG SPI bus
set_property -dict {PACKAGE_PIN R16 IOSTANDARD LVCMOS18} [get_ports sZmodDAC_CS]
set_property -dict {PACKAGE_PIN T18 IOSTANDARD LVCMOS18} [get_ports sZmodDAC_SCLK]
set_property -dict {PACKAGE_PIN P16 IOSTANDARD LVCMOS18} [get_ports sZmodDAC_SDIO]


#########################################################
# Syzygy Port B (ZMOD Digitizer module)
#########################################################
# Digitizer Clocks
set_property -dict {PACKAGE_PIN W17 IOSTANDARD LVCMOS18} [get_ports DcoClkIn]
create_clock -period 8.333 -name DcoClkIn [get_ports DcoClkIn]

# Digitizer Data
set_property -dict {PACKAGE_PIN U16 IOSTANDARD LVCMOS18} [get_ports {diZmodADC_Data[0]}]
set_property -dict {PACKAGE_PIN AB19 IOSTANDARD LVCMOS18} [get_ports {diZmodADC_Data[1]}]
set_property -dict {PACKAGE_PIN AA14 IOSTANDARD LVCMOS18} [get_ports {diZmodADC_Data[2]}]
set_property -dict {PACKAGE_PIN AA22 IOSTANDARD LVCMOS18} [get_ports {diZmodADC_Data[3]}]
set_property -dict {PACKAGE_PIN AB22 IOSTANDARD LVCMOS18} [get_ports {diZmodADC_Data[4]}]
set_property -dict {PACKAGE_PIN AA18 IOSTANDARD LVCMOS18} [get_ports {diZmodADC_Data[5]}]
set_property -dict {PACKAGE_PIN Y18 IOSTANDARD LVCMOS18} [get_ports {diZmodADC_Data[6]}]
set_property -dict {PACKAGE_PIN AB20 IOSTANDARD LVCMOS18} [get_ports {diZmodADC_Data[7]}]
set_property -dict {PACKAGE_PIN AA19 IOSTANDARD LVCMOS18} [get_ports {diZmodADC_Data[8]}]
set_property -dict {PACKAGE_PIN Y14 IOSTANDARD LVCMOS18} [get_ports {diZmodADC_Data[9]}]
set_property -dict {PACKAGE_PIN Y19 IOSTANDARD LVCMOS18} [get_ports {diZmodADC_Data[10]}]
set_property -dict {PACKAGE_PIN AB21 IOSTANDARD LVCMOS18} [get_ports {diZmodADC_Data[11]}]
set_property -dict {PACKAGE_PIN AA21 IOSTANDARD LVCMOS18} [get_ports {diZmodADC_Data[12]}]
set_property -dict {PACKAGE_PIN U15 IOSTANDARD LVCMOS18} [get_ports {diZmodADC_Data[13]}]

# Digitizer control/status signals
set_property -dict {PACKAGE_PIN W15 IOSTANDARD LVCMOS18} [get_ports aCG_PLL_Lock]
set_property -dict {PACKAGE_PIN AB15 IOSTANDARD LVCMOS18} [get_ports aREFSEL]
set_property -dict {PACKAGE_PIN V14 IOSTANDARD LVCMOS18} [get_ports aHW_SW_CTRL]
set_property -dict {PACKAGE_PIN U17 IOSTANDARD LVCMOS18} [get_ports aZmodSync]
set_property -dict {PACKAGE_PIN AB14 IOSTANDARD LVCMOS18} [get_ports sPDNout_n]

# Digitizer SPI interface
set_property -dict {PACKAGE_PIN Y13 IOSTANDARD LVCMOS18} [get_ports sZmodADC_SDIO]
set_property -dict {PACKAGE_PIN V17 IOSTANDARD LVCMOS18} [get_ports sZmodADC_CS]
set_property -dict {PACKAGE_PIN AA13 IOSTANDARD LVCMOS18} [get_ports sZmodADC_Sclk]

# Digitizer I2C interface
set_property -dict {PACKAGE_PIN V13 IOSTANDARD LVCMOS18} [get_ports CDCE_SDA]
set_property -dict {PACKAGE_PIN Y15 IOSTANDARD LVCMOS18} [get_ports CDCE_SCL]

#########################################################
# Pmod Header JA
#########################################################
#set_property -dict { PACKAGE_PIN B15   IOSTANDARD LVCMOS33 } [get_ports { ja[0] }]; #IO_0 Sch=ja1_fpga
#set_property -dict { PACKAGE_PIN C15   IOSTANDARD LVCMOS33 } [get_ports { ja[1] }]; #IO_25 Sch=ja2_fpga
#set_property -dict { PACKAGE_PIN D15   IOSTANDARD LVCMOS33 } [get_ports { ja[2] }]; #IO_L1N_T0_AD0N Sch=ja3_fpga
#set_property -dict { PACKAGE_PIN E16   IOSTANDARD LVCMOS33 } [get_ports { ja[3] }]; #IO_L1P_T0_AD0P Sch=ja4_fpga
#set_property -dict { PACKAGE_PIN E15   IOSTANDARD LVCMOS33 } [get_ports { ja[4] }]; #IO_L2N_T0_AD8N Sch=ja7_fpga
#set_property -dict { PACKAGE_PIN F17   IOSTANDARD LVCMOS33 } [get_ports { ja[5] }]; #IO_L2P_T0_AD8P Sch=ja8_fpga
#set_property -dict { PACKAGE_PIN F16   IOSTANDARD LVCMOS33 } [get_ports { ja[6] }]; #IO_L3N_T0_DQS_AD1N Sch=ja9_fpga
#set_property -dict { PACKAGE_PIN G16   IOSTANDARD LVCMOS33 } [get_ports { ja[7] }]; #IO_L3P_T0_DQS_AD1P Sch=ja10_fpga

#########################################################
# Pmod Header JB
#########################################################
#set_property -dict { PACKAGE_PIN G15   IOSTANDARD LVCMOS33 } [get_ports { jb[0] }]; #IO_L4N_T0 Sch=jb1_fpga
#set_property -dict { PACKAGE_PIN D16   IOSTANDARD LVCMOS33 } [get_ports { jb[1] }]; #IO_L4P_T0 Sch=jb2_fpga
#set_property -dict { PACKAGE_PIN D17   IOSTANDARD LVCMOS33 } [get_ports { jb[2] }]; #IO_L5N_T0_AD9N Sch=jb3_fpga
#set_property -dict { PACKAGE_PIN E18   IOSTANDARD LVCMOS33 } [get_ports { jb[3] }]; #IO_L5P_T0_AD9P Sch=jb4_fpga
#set_property -dict { PACKAGE_PIN F18   IOSTANDARD LVCMOS33 } [get_ports { jb[4] }]; #IO_L6N_T0_VREF Sch=jb7_fpga
#set_property -dict { PACKAGE_PIN G17   IOSTANDARD LVCMOS33 } [get_ports { jb[5] }]; #IO_L6P_T0 Sch=jb8_fpga
#set_property -dict { PACKAGE_PIN H18   IOSTANDARD LVCMOS33 } [get_ports { jb[6] }]; #IO_L7N_T1_AD2N Sch=jb9_fpga
#set_property -dict { PACKAGE_PIN H17   IOSTANDARD LVCMOS33 } [get_ports { jb[7] }]; #IO_L7P_T1_AD2P Sch=jb10_fpga

#########################################################
# 125MHz Clock from Ethernet PHY
#########################################################
#set_property -dict { PACKAGE_PIN D18   IOSTANDARD LVCMOS33 } [get_ports { clk }]; #IO_L12P_T1_MRCC Sch=sysclk
#create_clock -add -name sys_clk_pin -period 8.00 -waveform {0 4} [get_ports { clk }];

#########################################################
# Crypto SDA
#########################################################
#set_property -dict { PACKAGE_PIN D22   IOSTANDARD LVCMOS33 } [get_ports { crypto_sda }]; #IO_L16P_T2 Sch=crypto_sda

#########################################################
# Miscellaneous
#########################################################
#set_property -dict { PACKAGE_PIN B22   IOSTANDARD LVCMOS33 } [get_ports { mcu_rsvd[0] }]; #IO_L18N_T2_AD13N Sch=mcu_rsvd[1]
#set_property -dict { PACKAGE_PIN B21   IOSTANDARD LVCMOS33 } [get_ports { mcu_rsvd[1] }]; #IO_L18P_T2_AD13P Sch=mcu_rsvd[2]

