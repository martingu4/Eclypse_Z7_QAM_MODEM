----------------------------------------------------------------------------------
-- Company: N/A
-- Engineer: Martin G.
-- 
-- Create Date: 26.08.2023 19:28:00
-- Design Name: 
-- Module Name: LED_dimmer - Behavioral
-- Project Name: 
-- Target Devices: Eclypse Z7
-- Tool Versions: 2021.2
-- Description: This module decreases LEDs intensity by applying a PWM signal 
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

entity LED_dimmer is
    port(
        -- Input clock signal
        clk         : in  std_logic;
        -- Synchronous, active-low reset input
        resetn      : in  std_logic;

        -- Input LEDs states
        led0_in      : in  std_logic_vector(2 downto 0);
        led1_in      : in  std_logic_vector(2 downto 0);

        -- (if needed, an input can be added to control the
        --  PWM outputs duty cycle to increase/decrease intensity)

        -- Output dimmed LEDs signals
        led0_out    : out std_logic_vector(2 downto 0);
        led1_out    : out std_logic_vector(2 downto 0)
    );
end LED_dimmer;

architecture Behavioral of LED_dimmer is

    -- Binary counter for PWM frequency generation
    component PWM_Gen_count is
    port(
        CLK     : in  std_logic;
        THRESH0 : out std_logic;
        Q       : out std_logic_vector(16 downto 0)
    );
    end component PWM_Gen_count;
    
    signal thresh   : std_logic := '0';
    signal countVal : std_logic_vector(16 downto 0) := (others => '0');

    -- Temporary output signals
    signal led0_tmp : std_logic_vector(2 downto 0) := "000";
    signal led1_tmp : std_logic_vector(2 downto 0) := "000";

begin

    -- Binary counter for PWM frequency generation instantiation
    PWM_Gen_count_inst : PWM_Gen_count
    port map(
        CLK     => clk,
        THRESH0 => thresh,
        Q       => countVal
    );

    -- PWM signal generation
    process(clk)
        variable i : integer range 0 to 2 := 0;
    begin
        if(rising_edge(clk)) then
            -- Active-low, synchronous reset
            if(resetn = '0') then
                led0_tmp    <= "000";
                led1_tmp    <= "000";

            else

                for i in 0 to 2 loop
                    -----------------------------------------------
                    -- LED0
                    -----------------------------------------------
                    -- LED input is ON so apply PWM
                    if(led0_in(i) = '1') then

                        -- At counter reset, set output
                        if(countVal = "00000000000000000") then
                            led0_tmp(i) <= '1';

                        -- At counter threshold, reset output
                        elsif(thresh = '1') then
                            led0_tmp(i) <= '0';

                        -- Wait for timer event
                        else
                            led0_tmp(i) <= led0_tmp(i);
                        end if;

                    -- LED input is OFF so output 0
                    else
                        led0_tmp(i) <= '0';
                    end if;

                    -----------------------------------------------
                    -- LED1
                    -----------------------------------------------
                    if(led1_in(i) = '1') then
                        if(countVal = "00000000000000000") then
                            led1_tmp(i) <= '1';
                        elsif(thresh = '1') then
                            led1_tmp(i) <= '0';
                        else
                            led1_tmp(i) <= led1_tmp(i);
                        end if;
                    else
                        led1_tmp(i) <= '0';
                    end if;

                end loop;
            end if;
        end if;
    end process;


    -- Assign outputs
    led0_out        <= led0_tmp;
    led1_out        <= led1_tmp;

end Behavioral;
