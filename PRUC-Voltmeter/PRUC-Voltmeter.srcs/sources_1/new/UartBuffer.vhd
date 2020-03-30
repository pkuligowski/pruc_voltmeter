----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.03.2020 02:53:21
-- Design Name: 
-- Module Name: UartBuffer - Behavioral
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

entity UartBuffer is
    Port ( CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           BUSY : in STD_LOGIC;
           TRIGGER: in STD_LOGIC;
           DIN_0 : in STD_LOGIC_VECTOR (7 downto 0);
           DIN_1 : in STD_LOGIC_VECTOR (7 downto 0);
           START : out STD_LOGIC;
           DOUT : out STD_LOGIC_VECTOR (7 downto 0));
end UartBuffer;

architecture Behavioral of UartBuffer is
    type state_type is (IDLE, SEND_0, SEND_1);
    signal state_reg, state_next: state_type;
    signal count: STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal trigger_detected, busy_detected : STD_LOGIC;
    
    signal data_0, data_1 : STD_LOGIC_VECTOR (7 downto 0);
begin
    process(CLK, RST)
	begin
 	  	if RST = '1' then
 	  	    state_reg <= IDLE;
	   	elsif rising_edge(CLK) then
	   	    state_reg <= state_next;
        end if;
    end process;


    process(state_reg, TRIGGER, CLK, BUSY)
    begin
        if falling_edge(CLK) or falling_edge(BUSY) or rising_edge(TRIGGER) then
            case state_reg is
                when IDLE =>
                    START <= '0';
                    DOUT <= "11111111";
                    state_next <= IDLE;

                    if rising_edge(TRIGGER) then
                        data_0 <= DIN_0;
                        data_1 <= DIN_1;
                        state_next <= SEND_0;
                        trigger_detected <= '1';
                    end if;
                when SEND_0 =>
                    START <= '1';
                    DOUT <= data_0;

                    if falling_edge(BUSY) then
                        START <= '0';
                        state_next <= SEND_1;
                    end if;
                when SEND_1 =>
                    START <= '1';
                    DOUT <= data_1;
                        
                    if falling_edge(BUSY) then
                        START <= '0';
                        state_next <= IDLE;
                    end if;
            end case;
        end if;
    end process;
end Behavioral;
