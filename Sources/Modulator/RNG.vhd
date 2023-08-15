----------------------------------------------------------------------------------
-- Company: N/A
-- Engineer: Martin G.
-- 
-- Create Date: 15.08.2023 11:27:49
-- Design Name: 
-- Module Name: RNG - Behavioral
-- Project Name: Eclypse Z7 QAM MODEM
-- Target Devices: Eclypse Z7
-- Tool Versions: 2021.2
-- Description: Random number generator to feed the modulator's input
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

entity RNG is
Port (
    clk         : in std_logic;
    resetn      : in std_logic;
    rand_data   : out std_logic_vector(1 downto 0)
    );
end RNG;

architecture Behavioral of RNG is

    -- Stages of the LFSR
    signal taps : std_logic_vector(15 downto 0) := x"ACE1";

begin

    -- Random number generation process
    process(clk)
        variable i : integer range 15 downto 1;
    begin
        if(rising_edge(clk)) then
            -- Synchronous, active-low reset
            if(resetn = '0') then
                taps <= x"ACE1";
            else
                -- Shift the register
                for i in 0 to 14 loop
                    taps(i) <= taps(i+1);
                end loop;

                -- Tap 0 is a combination of other taps
                taps(15) <= taps(5) xor (taps(3) xor (taps(2) xor taps(0)));
            end if;
        end if;
    end process;

    -- Assign output
    rand_data <= taps(1 downto 0);

end Behavioral;
