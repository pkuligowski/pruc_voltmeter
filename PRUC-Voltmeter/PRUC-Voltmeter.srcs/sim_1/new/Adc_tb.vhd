----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.05.2020 01:02:08
-- Design Name: 
-- Module Name: Adc_tb - Behavioral
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

entity Adc_tb is
--  Port ( );
end Adc_tb;

architecture Behavioral of Adc_tb is
    component Adc is
    Port ( RESET : in STD_LOGIC;
           CLK : in STD_LOGIC;
           xa_n, xa_p : in STD_LOGIC);
    end component;
    
    signal clock : STD_LOGIC;
begin
    aadc: Adc                           
        port map(RESET => '0', CLK => clock, xa_n => '0', xa_p => '0');

    process
    begin
        clock <= '0';
        wait for 41666 ps;
        clock <= '1';
        wait for 41666 ps;
    end process;
end Behavioral;
