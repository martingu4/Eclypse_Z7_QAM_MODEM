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

    component RNG is
    port (
        clk         : in std_logic;
        resetn      : in std_logic;
        sym_ce      : in std_logic;
        rand_data   : out std_logic_vector(1 downto 0)
        );
    end component RNG;

    component Mapper is
    port (
        clk         : in std_logic;
        resetn      : in std_logic;
        symbol      : in std_logic_vector(1 downto 0);
        I           : out std_logic_vector(15 downto 0);
        Q           : out std_logic_vector(15 downto 0)
    );
    end component Mapper;

    -- Signals for modules connectivity
    signal sym_ce           : std_logic := '0';
    signal rand_data        : std_logic_vector(1 downto 0);
    signal I                : std_logic_vector(15 downto 0);
    signal Q                : std_logic_vector(15 downto 0);

begin

    -- Clock and reset generation
    clk <= not clk after HALF_PERIOD;
    resetn <= '0', '1' after 10*PERIOD, '0' after 100*PERIOD, '1' after 101*PERIOD;

    -- DUT instantiation
    SymRateGen_inst : SymRateGen
    generic map(
        PRESCALE_FACTOR => 10
    )
    port map(
        clk         => clk,
        resetn      => resetn,
        sym_ce      => sym_ce
    );

    RNG_inst : RNG
    port map(
        clk         => clk,
        resetn      => resetn,
        sym_ce      => sym_ce,
        rand_data   => rand_data
    );

    Mapper_inst : Mapper
    port map(
        clk         => clk,
        resetn      => resetn,
        symbol      => rand_data,
        I           => I,
        Q           => Q
    );

end Behavioral;
