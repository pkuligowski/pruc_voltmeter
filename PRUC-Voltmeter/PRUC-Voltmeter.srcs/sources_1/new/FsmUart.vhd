----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.03.2020 01:05:49
-- Design Name: 
-- Module Name: FsmUart - Behavioral
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

entity FsmUart is
    Port ( START : in STD_LOGIC;
           TRIGGER_1 : out STD_LOGIC;
           BUSY : in STD_LOGIC;
           TRIGGER_2 : out STD_LOGIC;
           RST : in STD_LOGIC;
           CLK : in STD_LOGIC );
end FsmUart;

architecture arch of FsmUart is
    type state_type is (IDLE, WAIT_1, TRIG_1, WAIT_2, TRIG_2);
    signal state_reg, state_next: state_type;
    
    signal start_detected, busy_detected : STD_LOGIC;
begin
    process(CLK, RST)
	begin
 	  	if RST = '1' then
 	  	    state_reg <= IDLE;
	   	elsif rising_edge(CLK) then
	   	    state_reg <= state_next;
        end if;
    end process;


    process(state_reg, START, CLK, BUSY)
    begin
        if rising_edge(START) then
            start_detected <= '1';
        end if;
        
        if falling_edge(BUSY) then
            busy_detected <= '1';
        end if;

        if falling_edge(CLK) then
            case state_reg is
                when IDLE =>
                    if start_detected='1' then
                        TRIGGER_1 <= '1';
                        state_next <= WAIT_1;
                    else
                        TRIGGER_1 <= '0';
                        TRIGGER_2 <= '0';
                        state_next <= IDLE;
                    end if;
                when WAIT_1 =>
                    state_next <= TRIG_1;
                when TRIG_1 =>
                    if busy_detected='1' then
                        TRIGGER_2 <= '1';
                        state_next <= WAIT_2;
                        busy_detected <= '0';
                    end if;
                when WAIT_2 =>
                     state_next <= TRIG_2;
                when TRIG_2 =>
                    if busy_detected='1' then
                        state_next <= IDLE;
                        busy_detected <= '0';
                    end if;
            end case;
        end if;
    end process;

end arch;
