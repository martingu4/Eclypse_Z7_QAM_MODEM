----------------------------------------------------------------------------------
-- Company:  N/A
-- Engineer: Martin G.
-- 
-- Create Date: 14.09.2023 20:33:52
-- Design Name: 
-- Module Name: Demodulator - Behavioral
-- Project Name: Eclypse Z7 QAM MODEM
-- Target Devices: Eclypse Z7
-- Tool Versions: 2021.2
-- Description: 4-QAM demodulator top-level file.
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

entity Demodulator is
port(
    -- Input clock signal
    clk : in std_logic;

    -- Active-low, synchronous reset input
    resetn : in std_logic;
    mod_sig : out std_logic_vector(15 downto 0);
    data : out std_logic_vector(1 downto 0)
);
end Demodulator;

architecture Behavioral of Demodulator is

begin


end Behavioral;
