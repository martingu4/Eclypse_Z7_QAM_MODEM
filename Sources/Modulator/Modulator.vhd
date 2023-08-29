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
    generic (
        PRESCALE_FACTOR : integer := 12000
    );
    port (
        -- Input clock and reset signals
        clk             : in std_logic;
        resetn          : in std_logic;
        
        -- Output modulated signal
        m_sig_tdata     : out std_logic_vector(15 downto 0);
        -- TODO : implement the valid and ready logic if needed
--        m_sig_tvalid    : out std_logic;
--        m_sig_tready    : in std_logic

        -- Signal that toggles each time a new symbol is output
        sym_ce_hold     : out std_logic
    );
end Modulator;

architecture Behavioral of Modulator is

    -- Output modulated signal master AXI Stream interface
--    ATTRIBUTE X_INTERFACE_INFO : STRING;
--    ATTRIBUTE X_INTERFACE_INFO of m_sig_tdata: SIGNAL is "xilinx.com:interface:axis:1.0 m_mod_sig TDATA";
--    ATTRIBUTE X_INTERFACE_INFO of m_sig_tvalid: SIGNAL is "xilinx.com:interface:axis:1.0 m_mod_sig TVALID";
--    ATTRIBUTE X_INTERFACE_INFO of m_sig_tready: SIGNAL is "xilinx.com:interface:axis:1.0 m_mod_sig TREADY";

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
    port(
        clk         : in std_logic;
        resetn      : in std_logic;
        sym_ce      : in std_logic;
        rand_data   : out std_logic_vector(1 downto 0)
        );
    end component RNG;

    -- Mapper (symbols => I/Q)
    component Mapper is
    port(
        clk         : in std_logic;
        resetn      : in std_logic;
        symbol      : in std_logic_vector(1 downto 0);
        I           : out std_logic_vector(15 downto 0);
        Q           : out std_logic_vector(15 downto 0)
    );
    end component Mapper;

    -- Direct digital synthesizer
    component dds_compiler_0 is
    port(
        aclk                : in std_logic;
        aresetn             : in std_logic;
        m_axis_data_tvalid  : out std_logic;
        m_axis_data_tdata   : out std_logic_vector(31 downto 0)
    );
    end component dds_compiler_0;
    
    -- I/Q mixer
    component IQ_Mixer is
    port(
        clk         : in  std_logic;
        resetn      : in  std_logic;
        I           : in  std_logic_vector(15 downto 0);
        Q           : in  std_logic_vector(15 downto 0);
        carriers_v  : in  std_logic;
        carriers_d  : in  std_logic_vector(31 downto 0);
        mod_sig     : out std_logic_vector(15 downto 0)
    );
    end component IQ_Mixer;
    
    ----------------------------------------------------------------------
    -- Signals declaration
    ----------------------------------------------------------------------
    signal sym_ce           : std_logic                     := '0';
    signal symbols          : std_logic_vector(1 downto 0)  := "00";
    signal I                : std_logic_vector(15 downto 0) := (others => '0');
    signal Q                : std_logic_vector(15 downto 0) := (others => '0');
    signal carriers_valid   : std_logic                     := '0';
    signal carriers_data    : std_logic_vector(31 downto 0) := (others => '0');
    signal mod_sig          : std_logic_vector(15 downto 0) := (others => '0');
    signal sym_ce_hold_tmp  : std_logic                     := '0';
    
begin

    -- Symbol rate generator module instantiation
    SymRateGen_inst : SymRateGen
    generic map(
        PRESCALE_FACTOR => PRESCALE_FACTOR
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
        rand_data   => symbols
    );

    -- Mapper module instantiation
    Mapper_inst : Mapper
    port map(
        clk         => clk,
        resetn      => resetn,
        symbol      => symbols,
        I           => I,
        Q           => Q
    );

    -- Direct digital synthesizer module
    DDS_inst : dds_compiler_0
    port map(
        aclk                => clk,
        aresetn             => resetn,
        m_axis_data_tvalid  => carriers_valid,
        m_axis_data_tdata   => carriers_data
    );

    -- I/Q Mixer module instantiation
    IQ_Mixer_inst : IQ_Mixer
    port map(
        clk         => clk,
        resetn      => resetn,
        I           => I,
        Q           => Q,
        carriers_v  => carriers_valid,
        carriers_d  => carriers_data,
        mod_sig     => mod_sig
    );

    m_sig_tdata <= mod_sig(15 downto 0);


    -- This process generates a signal that toggles each
    -- time a new symbol must be output
    -- (it will be a few clock cycles before the symbol
    -- changes on the modulated signal because of the
    -- mixer's latency)
    process(clk)
    begin
        if(rising_edge(clk)) then
            -- Synchronous, active-low reset
            if(resetn = '0') then
                sym_ce_hold_tmp         <= '0';

            else
                if(sym_ce = '1') then
                    if(sym_ce_hold_tmp = '1') then
                        sym_ce_hold_tmp <= '0';
                    else
                        sym_ce_hold_tmp <= '1';
                    end if;
                end if;
            end if;
        end if;
    end process;

    sym_ce_hold <= sym_ce_hold_tmp;

end Behavioral;

















-- EOF
