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
    generic(
        PRESCALE_FACTOR : integer
    );
    port(
        clk             : in std_logic;
        resetn          : in std_logic;
        m_sig_tdata     : out std_logic_vector(15 downto 0)
    );
    end component Modulator;

    component AWG_Data_Feeder is
    port(
        clk         : in  std_logic;
        resetn      : in  std_logic;
        data_1      : in  std_logic_vector(15 downto 0);
        data_2      : in  std_logic_vector(15 downto 0);
        feed_valid  : out std_logic;
        feed_ready  : in  std_logic;
        feed_data   : out std_logic_vector(31 downto 0)
    );
    end component AWG_Data_Feeder;

    component AWG_En is
    port(
        clk         : in std_logic;
        resetn      : in std_logic;
        btn         : in std_logic;
        sDAC_EnIn   : out std_logic;
        led         : out std_logic_vector(2 downto 0)
    );
    end component AWG_En;

    signal mod_sig      : std_logic_vector(15 downto 0);
    signal AWG_feed_d   : std_logic_vector(31 downto 0);
    signal AWG_feed_v   : std_logic;
    signal btnIn        : std_logic := '0';
    signal sDAC_EnIn    : std_logic;
    signal led          : std_logic_vector(2 downto 0);

begin

    -- Clock and reset generation
    clk <= not clk after HALF_PERIOD;
    resetn <= '0', '1' after 10*PERIOD;

    -- DUT instantiation
    Modulator_inst : Modulator
    generic map(
        PRESCALE_FACTOR => 12000
    )
    port map(
        clk             => clk,
        resetn          => resetn,
        m_sig_tdata     => mod_sig
    );

    AWG_Data_Feeder_inst : AWG_Data_Feeder
    port map(
        clk             => clk,
        resetn          => resetn,
        data_1          => mod_sig,
        data_2          => (others => '0'),
        feed_valid      => AWG_feed_v,
        feed_ready      => '1',
        feed_data       => AWG_feed_d
    );

    -- Bounced button input
    process
    begin

        btnIn   <= '0';
        wait for 12*PERIOD;
        btnIn   <= '1';
        wait for 1*PERIOD;
        btnIn   <= '1';
        wait for 2*PERIOD;
        btnIn   <= '0';
        wait for 1*PERIOD;
        btnIn   <= '1';
        wait for 1*PERIOD;
        btnIn   <= '0';
        wait for 3*PERIOD;
        btnIn   <= '1';
        wait for 1*PERIOD;
        btnIn   <= '0';
        wait for 2*PERIOD;
        btnIn   <= '1';
        wait for 5*PERIOD;
        btnIn   <= '0';
        wait for 100*PERIOD;

    end process;

    AWG_En_inst : AWG_En
    port map(
        clk             => clk,
        resetn          => resetn,
        btn             => btnIn,
        sDAC_EnIn       => sDAC_EnIn,
        led             => led
    );

end Behavioral;
