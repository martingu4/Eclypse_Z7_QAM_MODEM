----------------------------------------------------------------------------------
-- Company: N/A
-- Engineer: Martin G.
-- 
-- Create Date: 25.08.2023 19:23:15
-- Design Name: 
-- Module Name: AWG_En - Behavioral
-- Project Name: 
-- Target Devices: Eclypse Z7
-- Tool Versions: 2021.2
-- Description: AWG Module enable management
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

entity AWG_En is
    Port(
        -- Clock input
        clk     : in std_logic;
        -- Synchronous, active-low reset input
        resetn  : in std_logic;
        
        -- Button input to toggle enable signal
        btn     : in std_logic;

        -- AWG module enable output
        AWG_En  : out std_logic;
        -- RGB LED output
        led     : out std_logic_vector(2 downto 0)
    );
end AWG_En;

architecture Behavioral of AWG_En is
    
    -- Temporary output signals
    signal AWG_en_tmp   : std_logic := '0';
    signal led_tmp      : std_logic_vector(2 downto 0) := "000";

begin

    process(clk)
    begin
        if(rising_edge(clk)) then
            -- Synchronous, active-low reset
            if(resetn = '0') then
                AWG_en_tmp  <= '0';
                led_tmp     <= "000";

            else
                -- Check if button is pressed and timer reached 50.000.000
                    -- (50.000.000 count at 100MHz is half a second)
                if(countVal = x"2FAF080" and btn = '1') then
                    -- Toggle enable output and LED
                    if(AWG_en_tmp = '1') then
                        AWG_en_tmp  <= '0';
                        led_tmp     <= "100"; -- Red LED
                    else
                        AWG_en_tmp  <= '1';
                        led_tmp     <= "010"; -- Green LED
                    end if;
                else
                    AWG_en_tmp      <= AWG_en_tmp;
                    led_tmp         <= led_tmp;
                end if;
            end if;
        end if;
    end process;

end Behavioral;
