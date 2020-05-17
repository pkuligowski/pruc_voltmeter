----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.04.2020 01:09:38
-- Design Name: 
-- Module Name: AdcInterface_tb - Behavioral
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

entity AdcInterface_tb is
--  Port ( );
end AdcInterface_tb;

architecture Behavioral of AdcInterface_tb is
    component AdcInterface is
        Port ( CLK : in STD_LOGIC);
    end component;

    signal clock : std_logic;
begin
    adc_interface: AdcInterface                           
        port map(CLK => clock);
    
    process
    begin
        clock <= '0';
        wait for 41666 ps;
        clock <= '1';
        wait for 41666 ps;
    end process;
end Behavioral;
