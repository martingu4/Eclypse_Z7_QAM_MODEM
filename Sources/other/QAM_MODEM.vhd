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

library UNISIM;
use UNISIM.vcomponents.all;

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
        --CG_InputClk_n : out std_logic; -- Unused for this
        --CG_InputClk_p : out std_logic; -- IP customization
        aCG_PLL_Lock    : in    std_logic;
        aREFSEL         : out   std_logic;
        aHW_SW_CTRL     : out   std_logic;
        aZmodSync       : out   std_logic;
        sPDNout_n       : out   std_logic;
        sZmodADC_SDIO   : inout std_logic;
        sZmodADC_CS     : out   std_logic;
        sZmodADC_Sclk   : out   std_logic;
        CDCE_SDA        : inout std_logic;
        CDCE_SCL        : inout std_logic
    );
end QAM_MODEM;

architecture Behavioral of QAM_MODEM is

    -- Debug attribute
    attribute MARK_DEBUG : string;

    -------------------------------------------------------
    -- Clocks and resets generation
    component Clocks_Resets is
    port(
        sys_clk             : in  std_logic;
        SampleClk           : in  std_logic;
        ext_reset_in        : in  std_logic;
        locked              : out std_logic;
        SysClk100           : out std_logic;
        SampleClk_shift     : out std_logic;
        SysResetn           : out std_logic;
        SampleResetn        : out std_logic
    );
    end component Clocks_Resets;

    -- Clocks
    signal locked           : std_logic;
    signal SysClk100        : std_logic;
    signal SampleClk        : std_logic;
    signal SampleClk_shift  : std_logic;

    -- Resets
    signal SysResetn        : std_logic := '0';
    signal SampleResetn     : std_logic := '0';
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

    signal sInitDoneDAC     : std_logic;
    signal sConfigErrorDAC  : std_logic;
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
        sZmodADC_SDIO       : inout std_logic;
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

    signal sInitDoneClockGen    : std_logic := '0';
    signal sPLL_LockClockGen    : std_logic := '0';
    signal ADCEn                : std_logic := '0';
    signal sZmodDcoPLL_Lock     : std_logic := '0';
    signal sInitDoneADC         : std_logic := '0';
    signal sConfigErrorADC      : std_logic := '1';
    signal s_sda_i              : std_logic;
    signal s_sda_o              : std_logic;
    signal s_sda_t              : std_logic;
    signal s_scl_i              : std_logic;
    signal s_scl_o              : std_logic;
    signal s_scl_t              : std_logic;

    -- Signal that combines all status flags of the digitizer
    signal ZmodDcoClkOut_resetn : std_logic := '0';

    -- AXI-stream interface for ADC data
    signal ADCdata_d            : std_logic_vector(31 downto 0);
    signal ADCdata_v            : std_logic;
    signal ADCdata_r            : std_logic;

    component Digitizer_Sink is
    port(
        clk         : in  std_logic;
        aresetn     : in  std_logic;
        sym_ce_hold : in  std_logic;
        sink_valid  : in  std_logic;
        sink_ready  : out std_logic;
        sink_data   : in  std_logic_vector(31 downto 0)
    );
    end component Digitizer_Sink;
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

    -------------------------------------------------------
    -- DEBUG
    signal channel1_data    : std_logic_vector(15 downto 0) := (others => '0');
    attribute MARK_DEBUG of channel1_data   : signal is "true";
    attribute MARK_DEBUG of mod_sig         : signal is "true";
    attribute MARK_DEBUG of sym_ce_hold     : signal is "true";
    -------------------------------------------------------

begin

    -------------------------------------------------------
    -- Clocks and resets generation
    Clocks_Resets_inst : Clocks_Resets
    port map(
        sys_clk             => sys_clock,
        SampleClk           => SampleClk,
        ext_reset_in        => btn1,
        locked              => locked,
        SysClk100           => SysClk100,
        SampleClk_shift     => SampleClk_shift,
        SysResetn           => SysResetn,
        SampleResetn        => SampleResetn
    );

    -------------------------------------------------------
    -- Modulator
    Modulator_inst : Modulator
    generic map(
        PRESCALE_FACTOR => 12000
    )
    port map(
        clk             => SampleClk,
        resetn          => SampleResetn,
        m_sig_tdata     => mod_sig,
        sym_ce_hold     => sym_ce_hold
    );

    -------------------------------------------------------
    -- AWG IP and control modules
    ZmodAWGCtrl_inst : ZmodAWGCtrl
    port map(
        SysClk100       => SysClk100,
        DAC_InIO_Clk    => SampleClk,
        DAC_Clk         => SampleClk_shift,
        aRst_n          => SampleResetn,
        sTestMode       => '0', -- TODO : instantiate a VIO to toggle testmode
        sInitDoneDAC    => sInitDoneDAC,
        sConfigError    => sConfigErrorDAC,
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

    sDAC_EnIn <= '1' when (sInitDoneDAC = '1' and sConfigErrorDAC = '0') else '0';

    --AWG_En_inst : AWG_En
    --port map(
    --    clk             => SysClk100,
    --    resetn          => SysResetn,
    --    btn             => btn0,
    --    sDAC_EnIn       => sDAC_EnIn,
    --    led             => led0_h
    --);

    AWG_Data_Feeder_inst : AWG_Data_Feeder
    port map(
        clk             => SampleClk,
        resetn          => SampleResetn,
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
        SysClk100           => SysClk100,
        ClockGenPriRefClk   => '0',
        sInitDoneClockGen   => sInitDoneClockGen,
        sPLL_LockClockGen   => sPLL_LockClockGen,
        ZmodDcoClkOut       => SampleClk,
        sZmodDcoPLL_Lock    => sZmodDcoPLL_Lock,
        aRst_n              => SysResetn,
        sInitDoneADC        => sInitDoneADC,
        sConfigError        => sConfigErrorADC,
        sEnableAcquisition  => ADCEn,
        doDataAxisTvalid    => ADCdata_v,
        doDataAxisTready    => ADCdata_r,
        doDataAxisTdata     => ADCdata_d,
        sTestMode           => '0', -- TODO : instantiate a VIO to toggle testmode
        aZmodSync           => aZmodSync,
        DcoClkIn            => DcoClkIn,
        diZmodADC_Data      => diZmodADC_Data,
        sZmodADC_SDIO       => sZmodADC_SDIO,
        sZmodADC_CS         => sZmodADC_CS,
        sZmodADC_Sclk       => sZmodADC_Sclk,
        CG_InputClk_p       => open,
        CG_InputClk_n       => open,
        aCG_PLL_Lock        => aCG_PLL_Lock,
        aREFSEL             => aREFSEL,
        aHW_SW_CTRL         => aHW_SW_CTRL,
        sPDNout_n           => sPDNout_n,
        s_scl_i             => s_scl_i,
        s_scl_o             => s_scl_o,
        s_scl_t             => s_scl_t,
        s_sda_i             => s_sda_i,
        s_sda_o             => s_sda_o,
        s_sda_t             => s_sda_t
    );

    -- No module sinks DAC data for now. Always ready for debug
    ADCdata_r <= '1';
    channel1_data <= ADCdata_d(31 downto 16);

    -- Whenever the sink is ready, enable the ADC
        -- The IP's reference manual states this signal
        -- should never be de-asserted after so hold it
    process(SysClk100)
    begin
        if(rising_edge(SysClk100)) then
            if(ADCdata_r = '1') then
                ADCEn <= '1';
            else
                ADCEn <= ADCEn;
            end if;
        end if;
    end process;

    -- Instantiate OBUFTs for CDCE IIC interface
    sda_IOBUF_inst : IOBUF
    generic map (
        DRIVE => 12,
        IOSTANDARD => "LVCMOS18",
        SLEW => "SLOW"
    )
    port map (
        O   => s_sda_i,
        IO  => CDCE_SDA,
        I   => s_sda_o,
        T   => s_sda_t
    );

    scl_IOBUF_inst : IOBUF
    generic map (
        DRIVE => 12,
        IOSTANDARD => "LVCMOS18",
        SLEW => "SLOW"
    )
    port map (
        O   => s_scl_i,
        IO  => CDCE_SCL,
        I   => s_scl_o,
        T   => s_scl_t
    );

    ZmodDcoClkOut_resetn <= '0' when (sPLL_LockClockGen = '0' or sInitDoneClockGen = '0' or sZmodDcoPLL_Lock = '0' or sInitDoneADC = '0' or sConfigErrorADC = '1') else '1';

    -------------------------------------------------------
    -- LED dimmer
    LED_dimmer_inst : LED_dimmer
    port map(
        clk         => SysClk100,
        resetn      => SysResetn,
        led0_in     => led0_h,
        led1_in     => led1_h,
        led0_out    => led0,
        led1_out    => led1
    );

    led1_h  <= sInitDoneDAC & locked & sConfigErrorDAC;
    
end Behavioral;
