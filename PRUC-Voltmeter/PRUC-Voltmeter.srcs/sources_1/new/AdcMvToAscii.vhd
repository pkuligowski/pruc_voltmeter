----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.05.2020 22:14:44
-- Design Name: 
-- Module Name: AdcMvToAscii - Behavioral
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

entity AdcMvToAscii is
    Port ( RESET : in STD_LOGIC;
           CLK : in STD_LOGIC;
           DIN : in STD_LOGIC_VECTOR(15 downto 0);
           ASCIIOUT : out STD_LOGIC_VECTOR(31 downto 0));
end AdcMvToAscii;

architecture Behavioral of AdcMvToAscii is
    type state_type is (DIN_READ, CALC, CALC2, CALC3, CALC4, CALC5, CALC6, CALC7, CALC8, DOUT_WRITE);
    signal state_reg, state_next: state_type;

    signal reg_din_mv : STD_LOGIC_VECTOR(15 downto 0);
    signal ascii_0, ascii_1, ascii_2, ascii_3: integer range 0 to 255;
    signal value, value_0, value_1, value_2, value_3: integer range 0 to 4000;
begin
    process(CLK, RESET)
	begin
 	  	if RESET = '1' then
 	  	    state_reg <= DIN_READ;
	   	elsif rising_edge(CLK) then
	   	    state_reg <= state_next;
        end if;
    end process;

    process(CLK)
    begin
        if rising_edge(CLK) then
            reg_din_mv <= DIN;
        end if;

        if falling_edge(CLK) then
            case state_reg is
                when DIN_READ =>
	   	            value <= to_integer(unsigned(reg_din_mv));
	   	            state_next <= CALC;
                when CALC =>
                    value_3 <= value / 1000;
                    state_next <= CALC2;
                when CALC2 =>
                    value <= value - (value_3 * 1000);
                    state_next <= CALC3;
                when CALC3 =>
                    value_2 <= value / 100;
                    state_next <= CALC4;
                when CALC4 =>
                    value <= value - (value_2 * 100);
                    state_next <= CALC5;
                when CALC5 =>
                    value_1 <= value / 10;
                    state_next <= CALC6;
                when CALC6 =>
                    value <= value - (value_1 * 10);
                    state_next <= CALC7;
                when CALC7 =>
                    value_0 <= value;
                    state_next <= CALC8;
                when CALC8 =>
                    ascii_0 <= value_0 + 48;
                    ascii_1 <= value_1 + 48;
                    ascii_2 <= value_2 + 48;
                    ascii_3 <= value_3 + 48;
                    state_next <= DOUT_WRITE;
                when DOUT_WRITE =>
                    ASCIIOUT(7 downto 0) <= std_logic_vector(to_unsigned(ascii_0, 8));
                    ASCIIOUT(15 downto 8) <= std_logic_vector(to_unsigned(ascii_1, 8));
                    ASCIIOUT(23 downto 16) <= std_logic_vector(to_unsigned(ascii_2, 8));
                    ASCIIOUT(31 downto 24) <= std_logic_vector(to_unsigned(ascii_3, 8));
                    state_next <= DIN_READ;
            end case;
        end if;
    end process;

end Behavioral;
