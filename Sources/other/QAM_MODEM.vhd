----------------------------------------------------------------------------------
-- Company: N/A
-- Engineer: Martin G.
-- 
-- Create Date: 29.08.2023 18:30:56
-- Design Name: 
-- Module Name: QAM_MODEM - Behavioral
-- Project Name: Eclypse Z7 QAM MODEM
-- Target Devices: Eclypse Z7
-- Tool Versions: 2021.2
-- Description: Top level entity for Eclypse Z7 QAM MODEM
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

entity QAM_MODEM is
    port(
        -- 125MHz input clock
        sys_clock       : in    std_logic;

        -- User buttons
        btn0            : in    std_logic;
        btn1            : in    std_logic;

        -- User RGB LEDs
        led0            : out   std_logic_vector(2 downto 0);
        led1            : out   std_logic_vector(2 downto 0);

        -- Zmod AWG module's I/Os
        sZmodDAC_CS     : out   std_logic;
        sZmodDAC_SCLK   : out   std_logic;
        sZmodDAC_SDIO   : inout std_logic;
        sZmodDAC_Reset  : out   std_logic;
        ZmodDAC_ClkIO   : out   std_logic;
        ZmodDAC_ClkIn   : out   std_logic;
        dZmodDAC_Data   : out   std_logic_vector(13 downto 0);
        sZmodDAC_SetFS1 : out   std_logic;
        sZmodDAC_SetFS2 : out   std_logic;
        sZmodDAC_EnOut  : out   std_logic;

        -- Zmod Digitizer module's I/Os
        diZmodADC_Data  : in    std_logic_vector(13 downto 0);
        DcoClkIn        : in    std_logic;

    );
end QAM_MODEM;

architecture Behavioral of QAM_MODEM is

    -------------------------------------------------------
    -- Clocks and resets generation
    component Clocks_Resets is
    port(
        sys_clk         : in  std_logic;
        ext_reset_in    : in  std_logic;
        locked          : out std_logic;
        clk100          : out std_logic;
        clk120          : out std_logic;
        clk120_shift    : out std_logic;
        clk100_resetn   : out std_logic;
        clk120_resetn   : out std_logic
    );
    end component Clocks_Resets;

    -- Clocks
    signal locked           : std_logic;
    signal clk100           : std_logic;
    signal clk120           : std_logic;
    signal clk120_shift     : std_logic;

    -- Resets
    signal clk100_resetn    : std_logic;
    signal clk120_resetn    : std_logic;
    -------------------------------------------------------

    -------------------------------------------------------
    -- Modulator
    component Modulator is
    generic(
        PRESCALE_FACTOR : integer := 12000
    );
    port(
        clk             : in std_logic;
        resetn          : in std_logic;
        m_sig_tdata     : out std_logic_vector(15 downto 0);
        sym_ce_hold     : out std_logic
    );
    end component Modulator;

    signal mod_sig      : std_logic_vector(15 downto 0);
    signal sym_ce_hold  : std_logic;
    -------------------------------------------------------

    -------------------------------------------------------
    -- Zmod AWG IP
    component ZmodAWGCtrl is
    port(
        SysClk100       : in    std_logic;
        DAC_InIO_Clk    : in    std_logic;
        DAC_Clk         : in    std_logic;
        aRst_n          : in    std_logic;
        sTestMode       : in    std_logic;
        sInitDoneDAC    : out   std_logic;
        sConfigError    : out   std_logic;
        cDataAxisTvalid : in    std_logic;
        cDataAxisTready : out   std_logic;
        cDataAxisTdata  : in    std_logic_vector(31 downto 0);
        sDAC_EnIn       : in    std_logic;
        sZmodDAC_CS     : out   std_logic;
        sZmodDAC_SCLK   : out   std_logic;
        sZmodDAC_SDIO   : inout std_logic;
        sZmodDAC_Reset  : out   std_logic;
        ZmodDAC_ClkIO   : out   std_logic;
        ZmodDAC_ClkIn   : out   std_logic;
        dZmodDAC_Data   : out   std_logic_vector(13 downto 0);
        sZmodDAC_SetFS1 : out   std_logic;
        sZmodDAC_SetFS2 : out   std_logic;
        sZmodDAC_EnOut  : out   std_logic
    );
    end component ZmodAWGCtrl;

    signal sInitDoneDAC : std_logic;
    signal sConfigError : std_logic;
    -------------------------------------------------------


    -------------------------------------------------------
    -- Zmod AWG Control
    component AWG_En is
    port(
        clk         : in std_logic;
        resetn      : in std_logic;
        btn         : in std_logic;
        sDAC_EnIn   : out std_logic;
        led         : out std_logic_vector(2 downto 0)
    );
    end component AWG_En;

    signal sDAC_EnIn    : std_logic;
    signal led0_h       : std_logic_vector(2 downto 0);

    component AWG_Data_Feeder is
    port(
        clk         : in  std_logic;
        resetn      : in  std_logic;
        data_1      : in  std_logic_vector(15 downto 0);
        data_2      : in  std_logic_vector(15 downto 0);
        feed_valid  : out std_logic;
        feed_ready  : in  std_logic;
        feed_data   : out std_logic_vector(31 downto 0)
    );
    end component AWG_Data_Feeder;
    
    -- Data bus for AWG channel 2
    signal data_ch2     : std_logic_vector(15 downto 0);

    -- AXI-stream interface to feed the AWG IP
    signal AWGdata_d    : std_logic_vector(31 downto 0);
    signal AWGdata_v    : std_logic;
    signal AWGdata_r    : std_logic;
    -------------------------------------------------------

    -------------------------------------------------------
    -- Zmod Digitizer controller
    component ZmodDigitizerCtrl is
    port(
        SysClk100           : in  std_logic;
        ClockGenPriRefClk   : in  std_logic;
        sInitDoneClockGen   : out std_logic;
        sPLL_LockClockGen   : out std_logic;
        ZmodDcoClkOut       : out std_logic;
        sZmodDcoPLL_Lock    : out std_logic;
        aRst_n              : in  std_logic;
        sInitDoneADC        : out std_logic;
        sConfigError        : out std_logic;
        sEnableAcquisition  : in  std_logic;
        doDataAxisTvalid    : out std_logic;
        doDataAxisTready    : in  std_logic;
        doDataAxisTdata     : out std_logic_vector(31 downto 0);
        sTestMode           : in  std_logic;
        aZmodSync           : out std_logic;
        DcoClkIn            : in  std_logic;
        diZmodADC_Data      : in  std_logic_vector(13 downto 0);
        sZmodADC_SDIO       : in out std_logic;
        sZmodADC_CS         : out std_logic;
        sZmodADC_Sclk       : out std_logic;
        CG_InputClk_p       : out std_logic;
        CG_InputClk_n       : out std_logic;
        aCG_PLL_Lock        : in  std_logic;
        aREFSEL             : out std_logic;
        aHW_SW_CTRL         : out std_logic;
        sPDNout_n           : out std_logic;
        s_scl_i             : in  std_logic;
        s_scl_o             : out std_logic;
        s_scl_t             : out std_logic;
        s_sda_i             : in  std_logic;
        s_sda_o             : out std_logic;
        s_sda_t             : out std_logic
    );
    end component ZmodDigitizerCtrl;

    signal sInitDoneClockGen    : std_logic;
    signal sPLL_LockClockGen    : std_logic;
    signal ADCEn                : std_logic := '0';

    -- AXI-stream interface for ADC data
    signal ADCdata_d    : std_logic_vector(31 downto 0);
    signal ADCdata_v    : std_logic;
    signal ADCdata_r    : std_logic;
    -------------------------------------------------------

    -------------------------------------------------------
    -- Others
    component LED_dimmer is
    port(
        clk         : in  std_logic;
        resetn      : in  std_logic;
        led0_in     : in  std_logic_vector(2 downto 0);
        led1_in     : in  std_logic_vector(2 downto 0);
        led0_out    : out std_logic_vector(2 downto 0);
        led1_out    : out std_logic_vector(2 downto 0)
    );
    end component LED_dimmer;

    signal led1_h   : std_logic_vector(2 downto 0);
    -------------------------------------------------------

begin

    -------------------------------------------------------
    -- Clocks and resets generation
    Clocks_Resets_inst : Clocks_Resets
    port map(
        sys_clk         => sys_clock,
        ext_reset_in    => btn1,
        locked          => locked,
        clk100          => clk100,
        clk120          => clk120,
        clk120_shift    => clk120_shift,
        clk100_resetn   => clk100_resetn,
        clk120_resetn   => clk120_resetn
    );

    -------------------------------------------------------
    -- Modulator
    Modulator_inst : Modulator
    generic map(
        PRESCALE_FACTOR => 12000
    )
    port map(
        clk             => clk120,
        resetn          => clk120_resetn,
        m_sig_tdata     => mod_sig,
        sym_ce_hold     => sym_ce_hold
    );

    -------------------------------------------------------
    -- AWG IP and control modules
    ZmodAWGCtrl_inst : ZmodAWGCtrl
    port map(
        SysClk100       => clk100,
        DAC_InIO_Clk    => clk120,
        DAC_Clk         => clk120_shift,
        aRst_n          => clk100_resetn,
        sTestMode       => '0', -- TODO : instantiate a VIO to toggle testmode
        sInitDoneDAC    => sInitDoneDAC,
        sConfigError    => sConfigError,
        cDataAxisTvalid => AWGdata_v,
        cDataAxisTready => AWGdata_r,
        cDataAxisTdata  => AWGdata_d,
        sDAC_EnIn       => sDAC_EnIn,
        sZmodDAC_CS     => sZmodDAC_CS,
        sZmodDAC_SCLK   => sZmodDAC_SCLK,
        sZmodDAC_SDIO   => sZmodDAC_SDIO,
        sZmodDAC_Reset  => sZmodDAC_Reset,
        ZmodDAC_ClkIO   => ZmodDAC_ClkIO,
        ZmodDAC_ClkIn   => ZmodDAC_ClkIn,
        dZmodDAC_Data   => dZmodDAC_Data,
        sZmodDAC_SetFS1 => sZmodDAC_SetFS1,
        sZmodDAC_SetFS2 => sZmodDAC_SetFS2,
        sZmodDAC_EnOut  => sZmodDAC_EnOut
    );

    AWG_En_inst : AWG_En
    port map(
        clk             => clk100,
        resetn          => clk100_resetn,
        btn             => btn0,
        sDAC_EnIn       => sDAC_EnIn,
        led             => led0_h
    );

    AWG_Data_Feeder_inst : AWG_Data_Feeder
    port map(
        clk             => clk120,
        resetn          => clk120_resetn,
        data_1          => mod_sig,
        data_2          => data_ch2,
        feed_valid      => AWGdata_v,
        feed_ready      => AWGdata_r,
        feed_data       => AWGdata_d
    );

    -- Convert the binary signal from 0-1 to 0-DAC_Full_Scale
    -- so we can visualize a binary signal on oscilloscope
    data_ch2 <= "0111111111111100" when sym_ce_hold = '1' else (others => '0');


    -------------------------------------------------------
    -- Digitizer IP and control
    ZmodDigitizerCtrl_inst : ZmodDigitizerCtrl
    port map(
        SysClk100           => clk100,
        ClockGenPriRefClk   => '0',
        sInitDoneClockGen   => sInitDoneClockGen,
        sPLL_LockClockGen   => sPLL_LockClockGen,
        ZmodDcoClkOut       : out std_logic;
        sZmodDcoPLL_Lock    : out std_logic;
        aRst_n              => clk100_resetn,
        sInitDoneADC        : out std_logic;
        sConfigError        : out std_logic;
        sEnableAcquisition  => ADCEn;
        doDataAxisTvalid    => ADCdata_v,
        doDataAxisTready    => ADCdata_r,
        doDataAxisTdata     => ADCdata_d,
        sTestMode           => '0'; -- TODO : instantiate a VIO to toggle testmode
        aZmodSync           : out std_logic;
        DcoClkIn            => DcoClkIn,
        diZmodADC_Data      => diZmodADC_Data,
        sZmodADC_SDIO       : in out std_logic;
        sZmodADC_CS         : out std_logic;
        sZmodADC_Sclk       : out std_logic;
        CG_InputClk_p       : out std_logic;
        CG_InputClk_n       : out std_logic;
        aCG_PLL_Lock        : in  std_logic;
        aREFSEL             : out std_logic;
        aHW_SW_CTRL         : out std_logic;
        sPDNout_n           : out std_logic;
        s_scl_i             : in  std_logic;
        s_scl_o             : out std_logic;
        s_scl_t             : out std_logic;
        s_sda_i             : in  std_logic;
        s_sda_o             : out std_logic;
        s_sda_t             : out std_logic
    );

    -- Whenever the sink is ready, enable the ADC
        -- The IP's reference manual states this signal
        -- should never be de-asserted after so hold it
    process(clk100)
    begin
        if(rising_edge(clk)) then
            if(ADCdata_r = '1') then
                ADCEn <= '1';
            else
                ADCEn <= ADCEn;
            end if;
        end if;
    end process;

    -------------------------------------------------------
    -- LED dimmer
    LED_dimmer_inst : LED_dimmer
    port map(
        clk         => clk100,
        resetn      => clk100_resetn,
        led0_in     => led0_h,
        led1_in     => led1_h,
        led0_out    => led0,
        led1_out    => led1
    );

    led1_h  <= sInitDoneDAC & locked & sConfigError;
    
end Behavioral;
