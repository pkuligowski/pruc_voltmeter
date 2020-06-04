----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.04.2020 17:57:48
-- Design Name: 
-- Module Name: ClockPrescaler_tb - Behavioral
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

entity ClockPrescaler_tb is
--  Port ( );
end ClockPrescaler_tb;

architecture Behavioral of ClockPrescaler_tb is
    component ClockPrescaler is
        Generic (prescaler: STD_LOGIC_VECTOR(23 downto 0));
        Port ( CLK_IN : in STD_LOGIC;
               CLK_OUT : out STD_LOGIC);
    end component;
    
    signal clock_input, clock_output: STD_LOGIC;
begin
    prescaler: ClockPrescaler                                    
        generic map(prescaler => "000000000000000000000011")
        port map(CLK_IN => clock_input, CLK_OUT => clock_output);
    
    process
    begin
        clock_input <= '0';
        wait for 41666 ps;
        clock_input <= '1';
        wait for 41666 ps;
    end process;
end Behavioral;
