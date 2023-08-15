----------------------------------------------------------------------------------
-- Company: N/A
-- Engineer: Martin G.
-- 
-- Create Date: 15.08.2023 13:24:06
-- Design Name: 
-- Module Name: Mapper - Behavioral
-- Project Name: Eclypse Z7 QAM MODEM
-- Target Devices: Eclypse Z7
-- Tool Versions: 2021.2
-- Description: Mapper module for symbol => I/Q conversion before modulation
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

entity Mapper is
    port (
        -- Input clock signal
        clk     : in std_logic;
        -- Input synchronous active-low reset
        resetn  : in std_logic;

        -- Symbol input
        symbol  : in std_logic_vector(1 downto 0);
        
        -- I/Q values output in signed fixed point (14-bits decimal)
        I       : out std_logic_vector(15 downto 0);
        Q       : out std_logic_vector(15 downto 0)
    );
end Mapper;

architecture Behavioral of Mapper is

    -- Temporary output signals
    signal I_tmp    : std_logic_vector(15 downto 0) := (others => '0');
    signal Q_tmp    : std_logic_vector(15 downto 0) := (others => '0');

begin

    -- Mapping process
    process(clk)
    begin
        if(rising_edge(clk)) then
            -- Synchronous, active-low reset
            if(resetn = '0') then
                I_tmp <= (others => '0');
                Q_tmp <= (others => '0');

            else

                -- Map the four symbols of 4-QAM
                case symbol is
                    when "00" =>
                        I_tmp <= x"4000";
                        Q_tmp <= x"4000";

                    when "01" =>
                        I_tmp <= x"4000";
                        Q_tmp <= x"C000";

                    when "10" =>
                        I_tmp <= x"C000";
                        Q_tmp <= x"C000";

                    when others =>
                        I_tmp <= x"C000";
                        Q_tmp <= x"4000";

                end case;

            end if;
        end if;
    end process;

    -- Assign outputs
    I <= I_tmp;
    Q <= Q_tmp;

end Behavioral;
