----------------------------------------------------------------------------------
-- Company: N/A
-- Engineer: Martin G.
-- 
-- Create Date: 26.08.2023 19:52:29
-- Design Name: 
-- Module Name: LED_dimmer_TB - Behavioral
-- Project Name: 
-- Target Devices: Eclypse Z7
-- Tool Versions: 2021.2
-- Description: Testbench for LEDs dimmer module
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

entity LED_dimmer_TB is
--  Port ( );
end LED_dimmer_TB;

architecture Behavioral of LED_dimmer_TB is

    -- Clock and reset signals
    signal clk              : std_logic := '1';
    signal resetn           : std_logic := '0';
    constant HALF_PERIOD    : time := 5ns; -- 100 MHz
    constant PERIOD         : time := 2*HALF_PERIOD;

    -- DUT
    component LED_dimmer is
    port(
        clk         : in  std_logic;
        resetn      : in  std_logic;
        led0        : in  std_logic_vector(2 downto 0);
        led1        : in  std_logic_vector(2 downto 0);
        led0_out    : out std_logic_vector(2 downto 0);
        led1_out    : out std_logic_vector(2 downto 0)
    );
    end component LED_dimmer;

    signal led0 : std_logic_vector(2 downto 0) := "000";
    signal led1 : std_logic_vector(2 downto 0) := "000";

begin

    -- Generate clock and reset
    clk <= not clk after HALF_PERIOD;
    resetn <= '0', '1' after 20*PERIOD;

    -- Generate LEDs input
    process
    begin

        led0 <= "000";
        led1 <= "100";
        wait for 1000*PERIOD;
        led0 <= "110";
        led1 <= "100";
        wait for 1000*PERIOD;
        led0 <= "001";
        led1 <= "000";
        wait for 1000*PERIOD;
        led0 <= "010";
        led1 <= "000";
        wait for 1000*PERIOD;
        led0 <= "111";
        led1 <= "101";
        wait for 1000*PERIOD;
        led0 <= "000";
        led1 <= "000";

    end process;

    -- Instantiate DUT
    LED_dimmer_int : LED_dimmer
    port map(
        clk         => clk,
        resetn      => resetn,
        led0        => led0,
        led1        => led1,
        led0_out    => open,
        led1_out    => open
    );


end Behavioral;
