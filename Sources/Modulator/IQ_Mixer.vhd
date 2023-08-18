----------------------------------------------------------------------------------
-- Company: N/A
-- Engineer: Martin G.
-- 
-- Create Date: 15.08.2023 18:10:54
-- Design Name: 
-- Module Name: IQ_Mixer - Behavioral
-- Project Name: Eclypse Z7 QAM MODEM
-- Target Devices: Eclypse Z7
-- Tool Versions: 2021.2
-- Description: IQ and carrier mixer module
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity IQ_Mixer is
port(
    -- Input clock signal
    clk         : in  std_logic;

    -- Input synchronous, active-low reset
    resetn      : in  std_logic;

    -- I/Q inputs
    I           : in  std_logic_vector(15 downto 0);
    Q           : in  std_logic_vector(15 downto 0);

    -- Carriers input
    carriers_v  : in std_logic;
    carriers_d  : in std_logic_vector(31 downto 0);

    -- Modulated signal output
    mod_sig     : out std_logic_vector(15 downto 0)
);
end IQ_Mixer;

architecture Behavioral of IQ_Mixer is

    -- First DSP : P = I*sin
    component Mixer_I_sin is
    port(
        clk : in  std_logic;
        A   : in  std_logic_vector(15 downto 0);
        B   : in  std_logic_vector(15 downto 0);
        P   : out std_logic_vector(31 downto 0)
    );
    end component Mixer_I_sin;

    -- Second DSP : P = (I*sin) + (Q*cos) => uses first DSP's output
    component Mixer_Q_cos_add is
    port(
        clk : in  std_logic;
        A   : in  std_logic_vector(15 downto 0);
        B   : in  std_logic_vector(15 downto 0);
        C   : in  std_logic_vector(31 downto 0);
        P   : out std_logic_vector(15 downto 0)
    );
    end component Mixer_Q_cos_add;

    -- DSPs outputs
    signal Isin         : std_logic_vector(31 downto 0) := (others => '0');
    signal Isin_Qcos    : std_logic_vector(15 downto 0) := (others => '0');

    -- Temporary output signal
    signal mod_sig_tmp  : std_logic_vector(15 downto 0) := (others => '0');

begin

    -- First DSP instantiation
    Mixer_I_sin_inst : Mixer_I_sin
    port map(
        clk => clk,
        A   => I,
        B   => carriers_d(31 downto 16),
        P   => Isin
    );

    -- Second DSP instantiation
    Mixer_Q_cos_add_inst : Mixer_Q_cos_add
    port map(
        clk => clk,
        A   => Q,
        B   => carriers_d(15 downto 0),
        C   => Isin,
        P   => Isin_Qcos
    );

    -- TODO : be sure the pipelining between I*sin and Q*cos
    -- is the same when they are added together (check by simulation
    -- will be easier)

    process(clk)
    begin
        if(rising_edge(clk)) then
            -- Synchronous, active-low reset
            if(resetn = '0') then
                mod_sig_tmp <= (others => '0');

            else

                -- Output the result only if the DDS's output is valid
                -- The valid signal should not be used like this for an
                -- AXI-stream slave but for the DDS, the valid is always
                -- set when it outputs something so we can use it like this
                if(carriers_v = '1') then
                    mod_sig_tmp <= Isin_Qcos;
                else
                    mod_sig_tmp <= (others => '0');
                end if;

            end if;
        end if;
    end process;

    -- Assign output
    mod_sig <= mod_sig_tmp;

end Behavioral;
