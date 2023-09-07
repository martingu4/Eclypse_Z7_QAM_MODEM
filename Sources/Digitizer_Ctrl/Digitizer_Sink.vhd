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
    -- Active-low, asynchronous reset
    aresetn     : in  std_logic;

    -- Input data stream from the ADC
    sink_valid  : in  std_logic;
    sink_ready  : out std_logic;
    sink_data   : in  std_logic_vector(31 downto 0)
);
end Digitizer_Sink;

architecture Behavioral of Digitizer_Sink is

    -- Temporary output signals
    signal sink_ready_tmp   : std_logic := '0';

    -- Integrated Logic analyzer for debug
    component Digitizer_Data_ILA is
    port(
        clk     : in std_logic;
        probe0  : in std_logic_vector(31 downto 0);
        probe1  : in std_logic_vector(0 downto 0);
        probe2  : in std_logic_vector(0 downto 0)
    );
    end component Digitizer_Data_ILA;
    
    signal probe2   : std_logic_vector(0 downto 0);

begin

    -- Manage ready output
    --process(clk)
    --begin
    --    if(aresetn = '0') then
    --        sink_ready_tmp <= '0';
    --
    --    elsif(rising_edge(clk)) then
    --        sink_ready_tmp <= '1';
    --
    --    end if;
    --end process;

    -- Instantiate ILA
    Digitizer_Data_ILA_inst : Digitizer_Data_ILA
    port map(
        clk         => clk,
        probe0      => sink_data,
        probe1(0)   => sink_valid,
        probe2(0)   => sink_ready_tmp
    );

    -- Assign outputs
    --sink_ready <= sink_ready_tmp;
    sink_ready <= '1';

end Behavioral;
