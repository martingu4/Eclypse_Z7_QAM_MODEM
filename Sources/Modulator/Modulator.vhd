----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.07.2023 21:25:49
-- Design Name: 
-- Module Name: Modulator - Behavioral
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

begin


end Behavioral;

















-- EOF
