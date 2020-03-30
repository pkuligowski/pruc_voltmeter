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
    Generic (NUMBER_OF_BITS : integer);
    Port ( DIN : in STD_LOGIC_VECTOR (NUMBER_OF_BITS-1 downto 0);
           CLK : in STD_LOGIC;
           START : in STD_LOGIC;
           RST : in STD_LOGIC;
           BUSY: out STD_LOGIC;
           OUTPUT : out STD_LOGIC;
           b_counter : out integer);
end ShiftRegisterP2S;

architecture arch of ShiftRegisterP2S is
    type state_type is (IDLE, SEND_DATA);
    signal state_reg, state_next: state_type;

    signal bits_counter : integer;
    signal start_detected : STD_LOGIC;
begin
    process(CLK, RST)
	begin
 	  	if RST = '1' then
 	  	    state_reg <= IDLE;
	   	elsif rising_edge(CLK) then
	   	    state_reg <= state_next;
        end if;
    end process;
    
    b_counter <= bits_counter;

    process(state_reg, CLK, START)
    begin
        if rising_edge(START) then
            start_detected <= '1';
        end if;
    
        if falling_edge(CLK) then
            case state_reg is
                when IDLE =>
                    if start_detected='1' then
                        BUSY <= '1';
                        OUTPUT <= '0';
                        state_next <= SEND_DATA;
                    else
                        state_next <= IDLE;
                        BUSY <= '0';
                        bits_counter <= 0;
                        OUTPUT <= '1';
                    end if; 
                when SEND_DATA =>
                    start_detected <= '0';
                    if bits_counter < NUMBER_OF_BITS then
                        OUTPUT <= DIN(bits_counter);
                        bits_counter <= bits_counter + 1;
                        state_next <= SEND_DATA;
                    else
                        state_next <= IDLE;
                        bits_counter <= 0;
                        OUTPUT <= '1';
                    end if;
            end case;
        end if;
    end process;

end arch;
