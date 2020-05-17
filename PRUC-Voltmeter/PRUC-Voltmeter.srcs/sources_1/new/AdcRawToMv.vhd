----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.05.2020 18:43:40
-- Design Name: 
-- Module Name: AdcRawToMv - Behavioral
-- Project Name: PRUC Voltmeter
-- Target Devices: 
-- Tool Versions: 
-- Description: ADC RAW to uint mV converter
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
--use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.all;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
-- library UNISIM;
-- use UNISIM.VComponents.all;

entity AdcRawToMv is
    Port ( RESET : in STD_LOGIC;
           CLK : in STD_LOGIC;
           DIN : in STD_LOGIC_VECTOR(15 downto 0);
           DOUT : out STD_LOGIC_VECTOR(15 downto 0));
end AdcRawToMv;

architecture Behavioral of AdcRawToMv is
    type state_type is (DIN_READ, CALCULATIONS, DOUT_WRITE);
    signal state_reg, state_next: state_type;

    signal reg_din_raw : STD_LOGIC_VECTOR(15 downto 0);
    signal temp_din : STD_LOGIC_VECTOR(21 downto 0) := (others => '0');
    
    signal reg_dout_mv: integer range 0 to 4000000;
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
            reg_din_raw <= DIN;
        end if;

        if falling_edge(CLK) then
            case state_reg is
                when DIN_READ =>
                    temp_din(11 downto 0) <= reg_din_raw(15 downto 4);
	   	            temp_din(21 downto 12) <= (others => '0');
	   	            state_next <= CALCULATIONS;
                when CALCULATIONS =>
                    reg_dout_mv <= (to_integer(unsigned(temp_din)) * 806) / 1000;
                    state_next <= DOUT_WRITE;
                when DOUT_WRITE =>
                    DOUT <= std_logic_vector(to_unsigned(reg_dout_mv, 16));
                    state_next <= DIN_READ;
            end case;
        end if;
    end process;

end Behavioral;
