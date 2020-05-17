----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.05.2020 18:44:01
-- Design Name: 
-- Module Name: AdcRawToMv_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
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

entity AdcRawToMv_tb is
--  Port ( );
end AdcRawToMv_tb;

architecture Behavioral of AdcRawToMv_tb is
    component AdcRawToMv is
        Port ( RESET : in STD_LOGIC;
               CLK : in STD_LOGIC;
               DIN : in STD_LOGIC_VECTOR(15 downto 0);
               DOUT : out STD_LOGIC_VECTOR(15 downto 0));
    end component;
    
    signal clock : STD_LOGIC;
begin
    adc_raw_to_mv: AdcRawToMv
        port map(RESET => '0', CLK => clock, DIN => "0100110110011101", DOUT => open); -- test value for 1000mV

    process
    begin
        clock <= '0';
        wait for 41666 ps;
        clock <= '1';
        wait for 41666 ps;
    end process;
end Behavioral;
