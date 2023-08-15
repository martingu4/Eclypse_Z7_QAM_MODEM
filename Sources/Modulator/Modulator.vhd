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
    -- Symbol rate generator (CE generator for the RNG module)
    component SymRateGen is
    generic(
        PRESCALE_FACTOR : integer := 12000
    );
    port(
        clk         : in  std_logic;
        resetn      : in  std_logic;
        sym_ce      : out std_logic
    );
    end component SymRateGen;

    -- Random number generator (symbols generation)
    component RNG is
    port (
        clk         : in std_logic;
        resetn      : in std_logic;
        sym_ce      : in std_logic;
        rand_data   : out std_logic_vector(1 downto 0)
        );
    end component RNG;

    -- Mapper (symbols => I/Q)
    component Mapper is
    port (
        clk         : in std_logic;
        resetn      : in std_logic;
        symbol      : in std_logic_vector(1 downto 0);
        I           : out std_logic_vector(15 downto 0);
        Q           : out std_logic_vector(15 downto 0)
    );
    end component Mapper;
    
    
    
    ----------------------------------------------------------------------
    -- Signals declaration
    ----------------------------------------------------------------------
    signal sym_ce           : std_logic := '0';
    signal symbols  : std_logic_vector(1 downto 0) := "00";
    signal I                : std_logic_vector(15 downto 0);
    signal Q                : std_logic_vector(15 downto 0);
    
begin

    -- Symbol rate generator module instantiation
    SymRateGen_inst : SymRateGen
    generic map(
        PRESCALE_FACTOR => 10
    )
    port map(
        clk         => clk,
        resetn      => resetn,
        sym_ce      => sym_ce
    );

    -- RNG module instantiation
    RNG_inst : RNG
    port map(
        clk         => clk,
        resetn      => resetn,
        sym_ce      => sym_ce,
        rand_data   => rand_data
    );

    -- Mapper module instantiation
    Mapper_inst : Mapper
    port map(
        clk         => clk,
        resetn      => resetn,
        symbol      => rand_data,
        I           => I,
        Q           => Q
    );

end Behavioral;

















-- EOF
