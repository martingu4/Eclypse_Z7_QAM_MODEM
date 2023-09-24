----------------------------------------------------------------------------------
-- Company: N/A
-- Engineer: Martin G.
-- 
-- Create Date: 23.09.2023 23:47:46
-- Design Name: 
-- Module Name: Demapper - Behavioral
-- Project Name: Eclypse Z7 QAM MODEM
-- Target Devices: Eclypse Z7
-- Tool Versions: Vivado 2021.2
-- Description: Demapper module that converts recovered I-Q values back to symbols
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity Demapper is
    port(
        -- Input clock signal
        clk     : in std_logic;
        -- Active-low, synchronous reset input
        resetn  : in std_logic;

        -- I-Q input
        IQ      : in std_logic_vector(31 downto 0);
        IQ_v    : in std_logic;
        
        -- Symbols data output
        data    : out std_logic_vector(1 downto 0);
        data_v  : out std_logic
    );
end Demapper;

architecture Behavioral of Demapper is

    -- Temporary output signal
    signal data_tmp : std_logic_vector(1 downto 0) := (others => '0');

begin

    -- For 4-QAM, the demapper is based only on sign bit
    process(clk)
    begin
        if(rising_edge(clk)) then
            -- Synchronous, active-low reset
            if(resetn = '0') then
                data_tmp    <= (others => '0');

            else

                if(IQ_v = '1') then
                    if(IQ(31) = '1' and IQ(15) = '1') then
                        data_tmp <= "10";
                    elsif(IQ(31) = '1' and IQ(15) = '0') then
                        data_tmp <= "11";
                    elsif(IQ(31) = '0' and IQ(15) = '0') then
                        data_tmp <= "00";
                    else
                        data_tmp <= "01";
                    end if;
                else
                    data_tmp <= data_tmp;
                end if;

                -- Propagate valid signal
                data_v  <= IQ_v;

            end if;
        end if;
    end process;

    -- Assign output
    data <= data_tmp;

end Behavioral;
