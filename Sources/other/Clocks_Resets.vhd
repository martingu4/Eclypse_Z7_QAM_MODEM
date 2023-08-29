----------------------------------------------------------------------------------
-- Company: N/A
-- Engineer: Martin G.
-- 
-- Create Date: 29.08.2023 18:51:11
-- Design Name: 
-- Module Name: Clocks_Resets - Behavioral
-- Project Name: Eclypse Z7 QAM MODEM
-- Target Devices: Eclypse Z7
-- Tool Versions: 2021.2
-- Description: Clocks and resets generation module
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

entity Clocks_Resets is
    port(
        -- 125 MHz system clock input
        sys_clk         : in  std_logic;
        -- External reset input
        ext_reset_in    : in  std_logic;

        -- DCM locked output
        locked          : out std_logic;
        -- 100 MHz clock output
        clk100          : out std_logic;
        -- 120 MHz clock output
        clk120          : out std_logic;
        -- 120 MHz with 90 degree phase shift clock output
        clk120_shift    : out std_logic;

        -- Active-low reset synchronous to clk100 output
        clk100_resetn   : out std_logic;
        -- Active-low reset synchronous to clk120 output
        clk120_resetn   : out std_logic
    );
end Clocks_Resets;

architecture Behavioral of Clocks_Resets is

    -------------------------------------------------------
    -- Components definition
    -------------------------------------------------------
    -- Clocking wizard
    component clk_wiz_top is
    port(
        sys_clk                 : in  std_logic;
        clk_100                 : out std_logic;
        clk_120                 : out std_logic;
        clk_120_shift           : out std_logic;
        locked                  : out std_logic
    );
    end component clk_wiz_top;

    signal clk100_tmp           : std_logic;
    signal clk120_tmp           : std_logic;
    signal locked_tmp           : std_logic;

    -- Processor system reset
    component reset_gen is
    port(
        slowest_sync_clk        : in  std_logic;
        ext_reset_in            : in  std_logic;
        aux_reset_in            : in  std_logic;
        mb_debug_sys_rst        : in  std_logic;
        dcm_locked              : in  std_logic;
        mb_reset                : out std_logic;
        bus_struct_reset        : out std_logic_vector(0 DOWNTO 0);
        peripheral_reset        : out std_logic_vector(0 DOWNTO 0);
        interconnect_aresetn    : out std_logic_vector(0 DOWNTO 0);
        peripheral_aresetn      : out std_logic_vector(0 DOWNTO 0)
    );
    end component reset_gen;
    
    signal clk100_resetn_tmp    : std_logic_vector(0 downto 0);
    signal clk120_resetn_tmp    : std_logic_vector(0 downto 0);

begin

    -------------------------------------------------------
    -- Components instantiation
    -------------------------------------------------------
    -- Clocking wizard
    clk_wiz_top_inst : clk_wiz_top
    port map(
        sys_clk                 => sys_clk,
        clk_100                 => clk100_tmp,
        clk_120                 => clk120_tmp,
        clk_120_shift           => clk120_shift,
        locked                  => locked_tmp
    );

    -- Clk100 synchronous reset
    clk100_reset_gen_inst : reset_gen
    port map(
        slowest_sync_clk        => clk100_tmp,
        ext_reset_in            => ext_reset_in,
        aux_reset_in            => '0',
        mb_debug_sys_rst        => '0',
        dcm_locked              => locked_tmp,
        mb_reset                => open,
        bus_struct_reset        => open,
        peripheral_reset        => open,
        interconnect_aresetn    => open,
        peripheral_aresetn      => clk100_resetn_tmp
    );

    -- Clk120 synchronous reset
    clk120_reset_gen_inst : reset_gen
    port map(
        slowest_sync_clk        => clk120_tmp,
        ext_reset_in            => ext_reset_in,
        aux_reset_in            => '0',
        mb_debug_sys_rst        => '0',
        dcm_locked              => locked_tmp,
        mb_reset                => open,
        bus_struct_reset        => open,
        peripheral_reset        => open,
        interconnect_aresetn    => open,
        peripheral_aresetn      => clk120_resetn_tmp
    );

    -- Assign outputs
    locked          <= locked_tmp;
    clk100          <= clk100_tmp;
    clk120          <= clk120_tmp;
    clk100_resetn   <= clk100_resetn_tmp(0);
    clk120_resetn   <= clk120_resetn_tmp(0);

end Behavioral;
