----------------------------------------------------------------------------------
-- Company:  N/A
-- Engineer: Martin G.
-- 
-- Create Date: 30.07.2023 21:25:49
-- Design Name: 
-- Module Name: Modulator - Behavioral
-- Project Name: Eclypse Z7 QAM MODEM
-- Target Devices: Eclypse Z7
-- Tool Versions: 2021.2
-- Description: Top file for 4-QAM modulator
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

entity Modulator is
    Port (
        -- Input clock and reset signals
        clk             : in std_logic;
        resetn          : in std_logic;
        
        -- Output modulated signal
        m_sig_tdata     : out std_logic_vector(13 downto 0);
        m_sig_tvalid    : out std_logic;
        m_sig_tready    : in std_logic
    );
end Modulator;

architecture Behavioral of Modulator is

    -- Output modulated signal master AXI Stream interface
    ATTRIBUTE X_INTERFACE_INFO : STRING;
    ATTRIBUTE X_INTERFACE_INFO of m_sig_tdata: SIGNAL is "xilinx.com:interface:axis:1.0 m_mod_sig TDATA";
    ATTRIBUTE X_INTERFACE_INFO of m_sig_tvalid: SIGNAL is "xilinx.com:interface:axis:1.0 m_mod_sig TVALID";
    ATTRIBUTE X_INTERFACE_INFO of m_sig_tready: SIGNAL is "xilinx.com:interface:axis:1.0 m_mod_sig TREADY";

    ----------------------------------------------------------------------
    -- Components declaration
    ----------------------------------------------------------------------
    -- RNG module
    component RNG is
    port (
        clk         : in std_logic;
        resetn      : in std_logic;
        rand_data   : out std_logic_vector(1 downto 0)
        );
    end component RNG;
    
    
    
    ----------------------------------------------------------------------
    -- Signals declaration
    ----------------------------------------------------------------------
    signal symbols  : std_logic_vector(1 downto 0) := "00";
    
begin

    -- RNG module instantiation
    RNG_inst : RNG
    port map(
        clk         => clk,
        resetn      => resetn,
        rand_data   => symbols
    );

end Behavioral;

















-- EOF
