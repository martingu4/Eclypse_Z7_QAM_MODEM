----------------------------------------------------------------------------------
-- Company: N/A
-- Engineer: Martin G.
-- 
-- Create Date: 19.08.2023 10:08:55
-- Design Name: 
-- Module Name: AWG_Data_Feeder - Behavioral
-- Project Name: 
-- Target Devices: Eclypse Z7
-- Tool Versions: 2021.2
-- Description: AWG Controller data feeder
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

entity AWG_Data_Feeder is
    port(
        -- Clock input
        clk         : in  std_logic;
        -- Synchronous, active-low reset input
        resetn      : in  std_logic;
        
        -- TODO : it would be better to have AXI-Stream inputs
        -- Data input for module 1
        data_1      : in  std_logic_vector(15 downto 0);
        -- Data input for module 2
        data_2      : in  std_logic_vector(15 downto 0);
        
        -- Output AWG IP feed bus (AXI-Stream)
        feed_valid  : out std_logic;
        feed_ready  : in  std_logic;
        feed_data   : out std_logic_vector(31 downto 0)
    );
end AWG_Data_Feeder;

architecture Behavioral of AWG_Data_Feeder is

    -- Output modulated signal master AXI Stream interface
    ATTRIBUTE X_INTERFACE_INFO : STRING;
    ATTRIBUTE X_INTERFACE_INFO of feed_data: SIGNAL is "xilinx.com:interface:axis:1.0 m_feed TDATA";
    ATTRIBUTE X_INTERFACE_INFO of feed_valid: SIGNAL is "xilinx.com:interface:axis:1.0 m_feed TVALID";
    ATTRIBUTE X_INTERFACE_INFO of feed_ready: SIGNAL is "xilinx.com:interface:axis:1.0 m_feed TREADY";
    
    -- Temporary output signals
    signal feed_valid_tmp   : std_logic := '0';
    signal feed_data_tmp    : std_logic_vector(31 downto 0) := (others => '0');

begin

    -- Output feed data management
    process(clk)
    begin
        if(rising_edge(clk)) then
            -- Synchronous, active-low reset
            if(resetn = '0') then
                feed_valid_tmp  <= '0';
                feed_data_tmp   <= (others => '0');
                
            else
                -- Always validate output when ready because
                -- input is not AXI-Stream for now
                feed_valid_tmp <= feed_ready;
            
                if(feed_ready = '1') then
                    feed_data_tmp <= data_1 & data_2;
                else
                    feed_data_tmp <= (others => '0');
                end if;
            end if;
        end if;
    end process;

    -- Assign outputs
    feed_valid  <= feed_valid_tmp;
    feed_data   <= feed_data_tmp;

end Behavioral;









-- EOF