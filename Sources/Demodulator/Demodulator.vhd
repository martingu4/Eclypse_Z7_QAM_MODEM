----------------------------------------------------------------------------------
-- Company:  N/A
-- Engineer: Martin G.
-- 
-- Create Date: 14.09.2023 20:33:52
-- Design Name: 
-- Module Name: Demodulator - Behavioral
-- Project Name: Eclypse Z7 QAM MODEM
-- Target Devices: Eclypse Z7
-- Tool Versions: 2021.2
-- Description: 4-QAM demodulator top-level file.
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

entity Demodulator is
port(
    -- Input clock signal
    clk         : in std_logic;

    -- Active-low, synchronous reset input
    resetn      : in std_logic;

    -- Modulated signal input
    mod_sig     : in  std_logic_vector(15 downto 0);
    -- TODO : if needed, implement AXI-Stream for modulated signal
    
    -- Demodulated data output
    data        : out std_logic_vector(1 downto 0)
    -- TODO : if needed, implement AXI-Stream for demodulated data
);
end Demodulator;

architecture Behavioral of Demodulator is

    -------------------------------------------------------------
    -- Components
    component DDS_demod is
    port(
        aclk                    : in  std_logic;
        aresetn                 : in  std_logic;
        s_axis_config_tvalid    : in  std_logic;
        s_axis_config_tdata     : in  std_logic_vector(31 DOWNTO 0);
        m_axis_data_tvalid      : out std_logic;
        m_axis_data_tdata       : out std_logic_vector(15 DOWNTO 0)
    );
    end component DDS_demod;

    signal ph_offset_data       : std_logic_vector(28 downto 0) := (others => '0');
    signal ph_offset_valid      : std_logic := '0';
    signal carriers_data        : std_logic_vector(31 downto 0) := (others => '0');
    signal carriers_valid       : std_logic := '0';

begin




    -- Instantiate DDS for carrier generation
    DDS_demod_inst : DDS_demod
    port map(
        -- Clock and reset
        aclk                    => clk,
        aresetn                 => resetn,
        
        -- Phase offset configuration interface
        s_axis_config_tvalid    => ph_offset_valid,
        s_axis_config_tdata     => ph_offset_data,

        -- Carriers
        m_axis_data_tvalid      => carriers_valid,
        m_axis_data_tdata       => carriers_data
    );

end Behavioral;
