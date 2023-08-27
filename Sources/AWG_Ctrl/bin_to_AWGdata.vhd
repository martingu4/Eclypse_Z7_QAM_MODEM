----------------------------------------------------------------------------------
-- Company: N/A
-- Engineer: Martin G.
-- 
-- Create Date: 27.08.2023 17:00:09
-- Design Name: 
-- Module Name: bin_to_AWGdata - Behavioral
-- Project Name: 
-- Target Devices: Eclypse Z7
-- Tool Versions: 2021.2
-- Description: Tiny module that converts a binary input to a signed 16-bits
-- signal that can be fed into the AWG_Data_Feeder module. The purpose of this
-- process is to be able to output a binary signal with the AWG module (to 
-- trigger the oscilloscope for example)
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

entity bin_to_AWGdata is
port(
    clk     : in  std_logic;
    resetn  : in  std_logic;
    binIn   : in  std_logic;
    AWGdata : out std_logic_vector(15 downto 0)
);
end bin_to_AWGdata;

architecture Behavioral of bin_to_AWGdata is

    -- Temporary output signal
    signal AWGdata_tmp  : std_logic_vector(15 downto 0) := (others => '0');

begin

    process(clk)
    begin
        if(rising_edge(clk)) then
            -- Active-low, synchronous reset
            if(resetn = '0') then
                AWGdata_tmp <= (others => '0');
            
            else
                if(binIn = '1') then
                    AWGdata_tmp <= "0111111111111111";
                else
                    AWGdata_tmp <= (others => '0');
                end if;
            end if;
        end if;
    end process;
    
    AWGdata <= AWGdata_tmp;

end Behavioral;
