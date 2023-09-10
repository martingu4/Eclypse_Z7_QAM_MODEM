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
        -- Sample clock input
        SampleClk       : in  std_logic;
        -- External reset input
        ext_reset_in    : in  std_logic;

        -- DCM locked output
        locked          : out std_logic;
        -- 100 MHz clock output
        SysClk100       : out std_logic;
        -- Sample clock with 90 degree phase shift
        SampleClk_shift : out std_logic;

        -- Active-low reset synchronous to SysClk output
        SysResetn       : out std_logic;
        -- Active-low reset synchronous to SampleClk output
        SampleResetn    : out std_logic
    );
end Clocks_Resets;

architecture Behavioral of Clocks_Resets is

    -------------------------------------------------------
    -- Components definition
    -------------------------------------------------------
    -- Clocking wizard for SysClk100 generation
    component clk_wiz_top is
    port(
        sys_clk                 : in  std_logic;
        SysClk100               : out std_logic;
        locked                  : out std_logic
    );
    end component clk_wiz_top;

    signal SysClk100_tmp        : std_logic := '0';
    signal sys_locked_tmp       : std_logic := '0';

    -- Clocking wizard for 90 degrees phase shifted sample clock
    component clk_wiz_sample_shift is
    port(
        SampleClk               : in  std_logic;
        SampleClk_shift         : out std_logic;
        locked                  : out std_logic
    );
    end component clk_wiz_sample_shift;

    signal SampleClk_shift_tmp  : std_logic := '0';
    signal sample_locked_tmp    : std_logic := '0';

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

begin

    -------------------------------------------------------
    -- Components instantiation
    -------------------------------------------------------
    -- Clocking wizard
    clk_wiz_top_inst : clk_wiz_top
    port map(
        sys_clk                 => sys_clk,
        SysClk100               => SysClk100_tmp,
        locked                  => sys_locked_tmp
    );

    -- SysClk100 synchronous reset
    SysClk100_reset_gen_inst : reset_gen
    port map(
        slowest_sync_clk        => SysClk100_tmp,
        ext_reset_in            => ext_reset_in,
        aux_reset_in            => '0',
        mb_debug_sys_rst        => '0',
        dcm_locked              => sys_locked_tmp,
        mb_reset                => open,
        bus_struct_reset        => open,
        peripheral_reset        => open,
        interconnect_aresetn    => open,
        peripheral_aresetn(0)   => SysResetn
    );

    -- Sample clock phase shift clocking wizard
    clk_wiz_sample_shift_inst : clk_wiz_sample_shift
    port map(
        SampleClk               => SampleClk,
        SampleClk_shift         => SampleClk_shift_tmp,
        locked                  => sample_locked_tmp
    );

    -- Sample clock synchronous reset
    SampleClk_reset_gen_inst : reset_gen
    port map(
        slowest_sync_clk        => SampleClk,
        ext_reset_in            => ext_reset_in,
        aux_reset_in            => '0',
        mb_debug_sys_rst        => '0',
        dcm_locked              => sample_locked_tmp,
        mb_reset                => open,
        bus_struct_reset        => open,
        peripheral_reset        => open,
        interconnect_aresetn    => open,
        peripheral_aresetn(0)   => SampleResetn
    );

    -- Assign outputs
    locked          <= sys_locked_tmp and sample_locked_tmp;
    SysClk100       <= SysClk100_tmp;
    SampleClk_shift <= SampleClk_shift_tmp;

end Behavioral;
