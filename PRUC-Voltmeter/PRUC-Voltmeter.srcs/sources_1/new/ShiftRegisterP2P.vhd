----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.03.2020 00:27:51
-- Design Name: 
-- Module Name: ShiftRegisterP2P - Behavioral
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
use IEEE.NUMERIC_STD.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ShiftRegisterP2P is
    Generic (NUMBER_OF_BITS : integer);
    Port ( DIN : in STD_LOGIC_VECTOR (NUMBER_OF_BITS-1 downto 0);
           CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           DOUT : out STD_LOGIC_VECTOR (NUMBER_OF_BITS-1 downto 0));
end ShiftRegisterP2P;

architecture Behavioral of ShiftRegisterP2P is

begin
    process (CLK, RST)
    begin
        if (RST = '1') then
            DOUT <= (others => 'Z');
        elsif rising_edge(CLK) then
            DOUT(NUMBER_OF_BITS-1 downto 0) <= DIN(NUMBER_OF_BITS-1 downto 0);
        end if;
    end process;
end Behavioral;
