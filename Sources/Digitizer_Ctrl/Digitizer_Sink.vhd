----------------------------------------------------------------------------------
-- Company: N/A
-- Engineer: Martin G.
-- 
-- Create Date: 30.08.2023 07:56:13
-- Design Name: 
-- Module Name: Digitizer_Sink - Behavioral
-- Project Name: 
-- Target Devices: Eclypse Z7
-- Tool Versions: 2021.2
-- Description: This module sinks data coming from the ADC
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

entity Digitizer_Sink is
port(
    -- Clock input
    clk         : in  std_logic;
    -- Active-low, synchronous reset
    resetn      : in  std_logic;

    -- Input data stream from the ADC
    sink_valid  : in  std_logic;
    sink_ready  : out std_logic;
    sink_data   : in  std_logic_vector(31 downto 0)
);
end Digitizer_Sink;

architecture Behavioral of Digitizer_Sink is

    -- Temporary output signals
    signal sink_ready_tmp   : std_logic := '0';

begin

    process(clk)
    begin
        if(rising_edge(clk)) then
            if(resetn = '0') then
                sink_ready_tmp <= '0';

            else
                sink_ready_tmp <= '1';
            
            end if;
        end if;
    end process;

    -- Assign outputs
    sink_ready <= sink_ready_tmp;

end Behavioral;
