----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.03.2020 17:44:58
-- Design Name: 
-- Module Name: FsmUartSend - Behavioral
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

entity FsmUartSend is
    Port ( TRIGGER : in STD_LOGIC;
           SR_RST : out STD_LOGIC;
           SR_CLK : out STD_LOGIC;
           RST : in STD_LOGIC;
           CLK : in STD_LOGIC;
           SR_START : out STD_LOGIC;
           SR_BUSY : in STD_LOGIC);
end FsmUartSend;

architecture arch of FsmUartSend is
    type state_type is (CLK_UP, START_UP, WAIT_FOR_BUSY, IDLE);
    signal state_reg, state_next: state_type;
    signal trigger_detected, busy_detected : STD_LOGIC;
begin
    process(CLK, RST)
	begin
 	  	if RST = '1' then
 	  	    state_reg <= IDLE;
	   	elsif rising_edge(CLK) then
	   	    state_reg <= state_next;
        end if;
    end process;


    process(state_reg, TRIGGER, CLK, SR_BUSY)
    begin
        if rising_edge(TRIGGER) then
            trigger_detected <= '1';
        end if;
        
        if falling_edge(SR_BUSY) then
            busy_detected <= '1';
        end if;
    
        if falling_edge(CLK) then
            case state_reg is
                when IDLE =>
                    if trigger_detected='1' then
                        SR_RST <= '0';
                        SR_START <= '0';
                        SR_CLK <= '0';
                        state_next <= CLK_UP;
                    else
                        state_next <= IDLE;
                    end if;
                when CLK_UP =>
                    SR_CLK <= '1';
                    state_next <= START_UP;
                    trigger_detected <= '0';
                when START_UP =>
                    SR_START <= '1';
                    state_next <= WAIT_FOR_BUSY;
                when WAIT_FOR_BUSY =>
                    if busy_detected='1' then
                        state_next <= IDLE;
                        SR_RST <= '1';
                        SR_START <= '0';
                        SR_CLK <= '0';
                        busy_detected <= '0';
                    else
                        state_next <= WAIT_FOR_BUSY;
                    end if;
            end case;
        end if;
    end process;

end arch;
