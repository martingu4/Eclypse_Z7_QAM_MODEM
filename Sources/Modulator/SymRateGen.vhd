----------------------------------------------------------------------------------
-- Company: N/A
-- Engineer: Martin G.
-- 
-- Create Date: 15.08.2023 17:32:13
-- Design Name: 
-- Module Name: SymRateGen - Behavioral
-- Project Name: Eclypse Z7 QAM MODEM
-- Target Devices: Eclypse Z7
-- Tool Versions: 2021.2
-- Description: Symbol clock enable generator for modulator feeding
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

entity SymRateGen is
generic(
    -- Prescaler factor for CE generation
        -- (120MHz clock with prescaler of 12000 gives 10ksps)
    PRESCALE_FACTOR : integer := 12000
);
port(
    -- Input clock signal
    clk         : in  std_logic;

    -- Input synchronous, active-low reset
    resetn      : in  std_logic;

    -- Output clock enable for symbols generation
    sym_ce      : out std_logic
);
end SymRateGen;

architecture Behavioral of SymRateGen is

    -- Counter for prescaling
    signal presc_cnt    : integer range 0 to PRESCALE_FACTOR := 0;
    
    -- Temporary output signal
    signal sym_ce_tmp   : std_logic := '0';

begin

    -- Random number generation process
    process(clk)
    begin
        if(rising_edge(clk)) then
            -- Synchronous, active-low reset
            if(resetn = '0') then
                sym_ce_tmp <= '0';
                presc_cnt <= 0;

            else
                -- Symbol clock enable generator
                if(presc_cnt = PRESCALE_FACTOR-1) then
                    presc_cnt <= 1;
                    sym_ce_tmp <= '1';
                else
                    presc_cnt <= presc_cnt + 1;
                    sym_ce_tmp <= '0';
                end if;
            end if;
        end if;
    end process;

    -- Assign output
    sym_ce <= sym_ce_tmp;

end Behavioral;
