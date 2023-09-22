----------------------------------------------------------------------------------
-- Company: N/A
-- Engineer: Martin G.
-- 
-- Create Date: 22.09.2023 20:08:14
-- Design Name: 
-- Module Name: IQ_Splitter - Behavioral
-- Project Name: Eclypse Z7 QAM MODEM
-- Target Devices: Eclypse Z7
-- Tool Versions: 2021.2
-- Description: IQ splitter module (multiply modulated signal with recovered
-- carriers signals, I-Q will be recovered by a LPF after)
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

entity IQ_Splitter is
port(
    -- Input clock signal
    clk         : in  std_logic;

    -- Input synchronous, active-low reset
    resetn      : in  std_logic;

    -- Modulated signal input
    mod_sig     : in  std_logic_vector(15 downto 0);

    -- Carriers input
    carriers_v  : in  std_logic;
    carriers_d  : in  std_logic_vector(31 downto 0);

    -- I/Q (with double-frequency carriers images) outputs
    IQhf        : out std_logic_vector(31 downto 0)
);
end IQ_Splitter;

architecture Behavioral of IQ_Splitter is

    -- Splitter DSP component
    component Splitter_DSP is
    port(
        clk : in  std_logic;
        A   : in  std_logic_vector(15 downto 0);
        B   : in  std_logic_vector(15 downto 0);
        P   : out std_logic_vector(15 downto 0)
    );
    end component Splitter_DSP;

    -- DSPs outputs
    signal Ihf      : std_logic_vector(15 downto 0) := (others => '0');
    signal Qhf      : std_logic_vector(15 downto 0) := (others => '0');

begin

    -- First DSP : P = sin * mod_sig
    Splitter_DSP1_inst : Splitter_DSP
    port map(
        clk => clk,
        A   => mod_sig,
        B   => carriers_d(31 downto 16),
        P   => Ihf
    );

    -- Second DSP : P = cos * mod_sig
    Splitter_DSP2_inst : Splitter_DSP
    port map(
        clk => clk,
        A   => mod_sig,
        B   => carriers_d(15 downto 0),
        P   => Qhf
    );

    -- Assign outputs
    IQhf <= Ihf & Qhf;

end Behavioral;
