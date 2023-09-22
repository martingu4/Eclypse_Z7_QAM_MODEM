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
    -------------------------------------------------------------
    component DDS_demod is
    port(
        aclk                    : in  std_logic;
        aresetn                 : in  std_logic;
        s_axis_config_tvalid    : in  std_logic;
        s_axis_config_tdata     : in  std_logic_vector(23 downto 0);
        m_axis_data_tvalid      : out std_logic;
        m_axis_data_tdata       : out std_logic_vector(31 downto 0)
    );
    end component DDS_demod;

    component IQ_Splitter is
    port(
        clk         : in  std_logic;
        resetn      : in  std_logic;
        mod_sig     : in  std_logic_vector(15 downto 0);
        carriers_v  : in  std_logic;
        carriers_d  : in  std_logic_vector(31 downto 0);
        IQhf        : out std_logic_vector(31 downto 0)
    );
    end component IQ_Splitter;

    component LPF_IQ_Recovery is
    port(
        aresetn             : in  std_logic;
        aclk                : in  std_logic;
        s_axis_data_tvalid  : in  std_logic;
        s_axis_data_tready  : out std_logic;
        s_axis_data_tdata   : in  std_logic_vector(31 downto 0);
        m_axis_data_tvalid  : out std_logic;
        m_axis_data_tdata   : out std_logic_vector(47 downto 0)
    );
    end component LPF_IQ_Recovery;

    -------------------------------------------------------------
    -- Signals
    -------------------------------------------------------------
    -- DDS phase offset value
    signal ph_offset_data       : std_logic_vector(23 downto 0) := (others => '0');
    signal ph_offset_valid      : std_logic := '0';
    
    -- Recovered carriers
    signal carriers_data        : std_logic_vector(31 downto 0) := (others => '0');
    signal carriers_valid       : std_logic := '0';

    -- IQ signals with double-frequency carriers images (31:16=I and 15:0=Q)
    signal IQhf                 : std_logic_vector(31 downto 0) := (others => '0');
    signal IQhf_v               : std_logic := '0';

    -- IQ signals after low-pass filter
    signal IQ                   : std_logic_vector(47 downto 0) := (others => '0');
    signal IQ_v                 : std_logic := '0';

begin


    -- Instantiate DDS for carrier generation
    DDS_demod_inst : DDS_demod
    port map(
        aclk                    => clk,
        aresetn                 => resetn,
        s_axis_config_tvalid    => ph_offset_valid,
        s_axis_config_tdata     => ph_offset_data,
        m_axis_data_tvalid      => carriers_valid,
        m_axis_data_tdata       => carriers_data
    );

    -- Instantiate IQ Splitter module
    IQ_Splitter_inst : IQ_Splitter
    port map(
        clk         => clk,
        resetn      => resetn,
        mod_sig     => mod_sig,
        carriers_v  => carriers_valid,
        carriers_d  => carriers_data,
        IQhf        => IQhf
    );

    -- Instantiate the low-pass filter to get rid of the
    -- double-frequency carriers images
    LPF_IQ_Recovery_inst : LPF_IQ_Recovery
    port map(
        aclk                => clk,
        aresetn             => resetn,
        s_axis_data_tdata   => IQhf,
        s_axis_data_tready  => IQhf_v,
        s_axis_data_tvalid  => IQhf_v,
        m_axis_data_tdata   => IQ,
        m_axis_data_tvalid  => IQ_v
    );

end Behavioral;
