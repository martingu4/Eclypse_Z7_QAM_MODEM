----------------------------------------------------------------------------------
-- Company: N/A
-- Engineer: Martin G.
-- 
-- Create Date: 22.09.2023 22:49:46
-- Design Name: 
-- Module Name: Demodulator_TB - Behavioral
-- Project Name: Eclypse Z7 QAM MODEM
-- Target Devices: Eclypse Z7
-- Tool Versions: Vivado 2021.2
-- Description: Demodulator testbench
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

entity Demodulator_TB is
--  Port ( );
end Demodulator_TB;

architecture Behavioral of Demodulator_TB is

    -- Clock and reset signals
    signal clk              : std_logic := '1';
    signal resetn           : std_logic := '0';
    constant HALF_PERIOD    : time := 4.166666667ns; -- 120 MHz
    constant PERIOD         : time := 2*HALF_PERIOD;

    -- DUT component(s)
    component Modulator is
    generic(
        PRESCALE_FACTOR : integer
    );
    port(
        clk             : in std_logic;
        resetn          : in std_logic;
        m_sig_tdata     : out std_logic_vector(15 downto 0);
        sym_ce_hold     : out std_logic
    );
    end component Modulator;

    component Demodulator is
    port(
        clk             : in std_logic;
        resetn          : in std_logic;
        ph_offset_valid : in  std_logic;
        ph_offset_data  : in  std_logic_vector(15 downto 0);
        mod_sig         : in  std_logic_vector(15 downto 0);
        data            : out std_logic_vector(1 downto 0)
    );
    end component Demodulator;

    signal ph_offset_data   : std_logic_vector(15 downto 0);
    signal ph_offset_valid  : std_logic;
    signal mod_sig          : std_logic_vector(15 downto 0);
    signal AWG_feed_d       : std_logic_vector(31 downto 0);
    signal AWG_feed_v       : std_logic;
    signal btnIn            : std_logic := '0';
    signal sDAC_EnIn        : std_logic;
    signal led              : std_logic_vector(2 downto 0);

begin

    -- Clock and reset generation
    clk <= not clk after HALF_PERIOD;
    resetn <= '0', '1' after 10*PERIOD;

    -- Phase offset configuration
    process
    begin
--        -- Initial offset : 0
--        ph_offset_data  <= (others => '0');
--        ph_offset_valid <= '1';
--        wait for PERIOD;
--        ph_offset_valid <= '0';

--        wait for 20us;

--        -- Offset : 90 deg
--        ph_offset_data  <= x"4000";
--        ph_offset_valid <= '1';
--        wait for PERIOD;
--        ph_offset_valid <= '0';

--        wait for 20us;

--        -- Offset : 180 deg
--        ph_offset_data  <= x"8000";
--        ph_offset_valid <= '1';
--        wait for PERIOD;
--        ph_offset_valid <= '0';

--        wait for 20us;

        -- Offset : 270 deg
        ph_offset_data  <= x"C000";
        ph_offset_valid <= '1';
        wait for PERIOD;
        ph_offset_valid <= '0';

        wait;

    end process;

    -- DUT instantiation
    Modulator_inst : Modulator
    generic map(
        PRESCALE_FACTOR => 100
    )
    port map(
        clk         => clk,
        resetn      => resetn,
        m_sig_tdata => mod_sig,
        sym_ce_hold => open
    );

    Demodulator_inst : Demodulator
    port map(
        clk             => clk,
        resetn          => resetn,
        ph_offset_data  => ph_offset_data,
        ph_offset_valid => ph_offset_valid,
        mod_sig         => mod_sig,
        data            => open
    );

end Behavioral;

