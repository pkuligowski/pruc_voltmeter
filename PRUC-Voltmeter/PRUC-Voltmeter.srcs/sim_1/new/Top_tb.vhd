----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.03.2020 21:47:07
-- Design Name: 
-- Module Name: Top_tb - Behavioral
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

entity Top_tb is
    Port ( CLK_GLOBAL : in STD_LOGIC;
           SERIAL_OUT : out STD_LOGIC;
           LED : out STD_LOGIC);
end Top_tb;

architecture Behavioral of Top_tb is
    component Top is
        Port ( CLK_GLOBAL : in STD_LOGIC;
            SERIAL_OUT, LED : out STD_LOGIC);
    end component;

    signal clock, serial_o, led_o : std_logic;
    signal data : std_logic_vector(23 downto 0);
    signal busy : std_logic;
begin
    control_logic: Top                           
        port map(CLK_GLOBAL => clock, SERIAL_OUT => serial_o, LED => led_o);
    
    process
    begin
        clock <= '0';
        wait for 41666 ps;
        clock <= '1';
        wait for 41666 ps;
    end process;

end Behavioral;
