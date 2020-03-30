----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.03.2020 22:04:11
-- Design Name: 
-- Module Name: Counter - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ClockCounter is
    Port ( CLK : in STD_LOGIC;
           DOUT : out STD_LOGIC_VECTOR(15 downto 0));
end ClockCounter;

architecture Behavioral of ClockCounter is
    signal count: STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
begin
    count_clock: process(CLK)
    begin
        if rising_edge(CLK) then
            count <= count + 1;
        end if;
    end process;

    DOUT <= count;
end Behavioral;
