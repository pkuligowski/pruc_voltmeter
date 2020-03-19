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
    Generic ( OVERFLOW: STD_LOGIC_VECTOR(23 downto 0) := "111111111111111111111111");
    Port ( CLK : in STD_LOGIC;
           LOAD : in STD_LOGIC;
           BUSY : out STD_LOGIC;
           DOUT : out STD_LOGIC_VECTOR(23 downto 0));
end ClockCounter;

architecture Behavioral of ClockCounter is
    signal count: STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
    signal is_counting : std_logic :='0';
begin
    count_clock: process(CLK, LOAD)
    begin
        if rising_edge(LOAD) then
            is_counting <= '1';
        end if;
 
        if rising_edge(CLK) and (is_counting='1') then
            count <= count + 1;
            if(count > OVERFLOW) then
                count <= (others => '0');
                is_counting <= '0';
            end if;
        end if;
    end process;

    BUSY <= is_counting;
    DOUT <= count;
end Behavioral;
