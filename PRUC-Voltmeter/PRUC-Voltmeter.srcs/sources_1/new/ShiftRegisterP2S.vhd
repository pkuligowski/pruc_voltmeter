----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.03.2020 23:18:28
-- Design Name: 
-- Module Name: ShiftRegister - Behavioral
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
use IEEE.NUMERIC_STD.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ShiftRegisterP2S is
    Generic (NUMBER_OF_BITS : integer := 10);
    Port ( DIN : in STD_LOGIC_VECTOR (NUMBER_OF_BITS-1 downto 0);
           CLK : in STD_LOGIC;
           START : in STD_LOGIC;
           RST : in STD_LOGIC;
           BUSY: out STD_LOGIC;
           OUTPUT : out STD_LOGIC);
end ShiftRegisterP2S;

architecture Behavioral of ShiftRegisterP2S is
    signal shift_register : STD_LOGIC_VECTOR(NUMBER_OF_BITS-1 downto 0) := (others => '1');
    signal bits_counter : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal reg_busy : STD_LOGIC := '0';
begin
    process (CLK, RST, START)
    begin
        if (RST = '1') then
            shift_register <= (others => '1');
        elsif rising_edge(CLK) then
            if START='0' then
                shift_register <= DIN;
                bits_counter <= std_logic_vector(to_unsigned(NUMBER_OF_BITS - 1, bits_counter'length));
                reg_busy <= '1';
            else
                shift_register(NUMBER_OF_BITS-2 downto 0) <= shift_register(NUMBER_OF_BITS-1 downto 1);
                shift_register(NUMBER_OF_BITS-1) <= '1';
                
                if (bits_counter > 0) then
                    bits_counter <= bits_counter - 1;
                else
                    reg_busy <= '0';
                end if;
            end if;
        end if;
    end process;
    
    BUSY <= reg_busy;
    OUTPUT <= shift_register(0);

end Behavioral;
