----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.03.2020 23:46:07
-- Design Name: 
-- Module Name: ClockPrescaler - Behavioral
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

entity ClockPrescaler is
    Generic ( PRESCALER: STD_LOGIC_VECTOR(23 downto 0));
    Port ( CLK_IN : in STD_LOGIC;
           CLK_OUT : out STD_LOGIC);
end ClockPrescaler;

architecture Behavioral of ClockPrescaler is
    signal prescaler_counter: STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
    signal state_current, state_next: STD_LOGIC := '0';

begin
    process(CLK_IN)
    begin
        if rising_edge(CLK_IN) then
            if prescaler_counter = PRESCALER then
                state_next <= not state_next;
            end if;
        end if;
        
        if falling_edge(CLK_IN) then
            state_current <= state_next;
            prescaler_counter <= prescaler_counter + 1;
            if prescaler_counter = PRESCALER then
                prescaler_counter <= (others => '0');
            end if;
        end if;
    end process;

    CLK_OUT <= state_current;
end Behavioral;
