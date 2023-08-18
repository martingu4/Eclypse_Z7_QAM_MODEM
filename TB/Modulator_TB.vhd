----------------------------------------------------------------------------------
-- Company: N/A
-- Engineer: Martin G.
-- 
-- Create Date: 15.08.2023 11:39:34
-- Design Name: 
-- Module Name: Modulator_TB - Behavioral
-- Project Name: Eclypse Z7 QAM MODEM
-- Target Devices: Eclypse Z7
-- Tool Versions: 2021.2
-- Description: Testbench for 4-QAM modulator
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

entity Modulator_TB is
--  Port ( );
end Modulator_TB;

architecture Behavioral of Modulator_TB is

    -- Clock and reset signals
    signal clk              : std_logic := '1';
    signal resetn           : std_logic := '0';
    constant HALF_PERIOD    : time := 4.166666667ns; -- 120 MHz
    constant PERIOD         : time := 2*HALF_PERIOD;

    -- DUT component(s)
    component Modulator is
    Port (
        clk             : in std_logic;
        resetn          : in std_logic;
        m_sig_tdata     : out std_logic_vector(13 downto 0);
        m_sig_tvalid    : out std_logic;
        m_sig_tready    : in std_logic
    );
    end component Modulator;

    signal mod_sig : std_logic_vector(13 downto 0);

begin

    -- Clock and reset generation
    clk <= not clk after HALF_PERIOD;
    resetn <= '0', '1' after 10*PERIOD;

    -- DUT instantiation
    Modulator_inst : Modulator
    port map(
        clk             => clk,
        resetn          => resetn,
        m_sig_tdata     => mod_sig,
        m_sig_tvalid    => open,
        m_sig_tready    => '0'
    );

end Behavioral;
