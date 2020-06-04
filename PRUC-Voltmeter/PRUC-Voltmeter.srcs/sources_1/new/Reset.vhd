----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.04.2020 18:36:45
-- Design Name: 
-- Module Name: Reset - Behavioral
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

entity Reset is
    Port ( CLK : in STD_LOGIC;
           RST : out STD_LOGIC);
end Reset;

architecture Behavioral of Reset is
    signal reset_counter: STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
begin
    process(CLK)
    begin
        if falling_edge(CLK) then
            RST <= '0';

            if reset_counter < 10 then
                reset_counter <= reset_counter + 1;
                RST <= '1';
            end if;
        end if;
    end process;

end Behavioral;
