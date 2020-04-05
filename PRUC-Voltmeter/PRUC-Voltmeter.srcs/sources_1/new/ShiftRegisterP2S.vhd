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
    Port ( DIN : in STD_LOGIC_VECTOR (7 downto 0);
           CLK : in STD_LOGIC;
           START : in STD_LOGIC;
           RST : in STD_LOGIC;
           BUSY: out STD_LOGIC;
           OUTPUT : out STD_LOGIC);
end ShiftRegisterP2S;

architecture RTL of ShiftRegisterP2S is
    type state_type is (IDLE, BIT_START, BIT_0, BIT_1, BIT_2, BIT_3, BIT_4, BIT_5, BIT_6, BIT_7, BIT_STOP, WAIT_STOP);
    signal state, state_next: state_type;
    signal busy_out, output_out: STD_LOGIC;
begin
    update_state : process(CLK)
    begin
        if rising_edge(CLK) then
            if (RST='1') then
                state <= IDLE;
            else
                state <= state_next;
            end if;
        end if;
    end process;

    update_state_next : process(state, START, DIN)
    begin
            case state is
                when IDLE =>
                    busy_out <= '0';
                    output_out <= '1';

                    if START='1' then
                        state_next <= BIT_START;
                    else
                        state_next <= IDLE;
                    end if;
                when BIT_START =>
                    busy_out <= '1';
                    output_out <= '0';
                    state_next <= BIT_0;
                when BIT_0 =>
                    busy_out <= '1';
                    output_out <= DIN(0);
                    state_next <= BIT_1;
                when BIT_1 =>
                    busy_out <= '1';
                    output_out <= DIN(1);
                    state_next <= BIT_2;
                when BIT_2 =>
                    busy_out <= '1';
                    output_out <= DIN(2);
                    state_next <= BIT_3;
                when BIT_3 =>
                    busy_out <= '1';
                    output_out <= DIN(3);
                    state_next <= BIT_4;
                when BIT_4 =>
                    busy_out <= '1';
                    output_out <= DIN(4);
                    state_next <= BIT_5;
                when BIT_5 =>
                    busy_out <= '1';
                    output_out <= DIN(5);
                    state_next <= BIT_6;
                when BIT_6 =>
                    busy_out <= '1';
                    output_out <= DIN(6);
                    state_next <= BIT_7;
                when BIT_7 =>
                    busy_out <= '1';
                    output_out <= DIN(7);
                    state_next <= BIT_STOP;
                when BIT_STOP =>
                    busy_out <= '1';
                    output_out <= '1';
                    state_next <= WAIT_STOP;
                when WAIT_STOP =>
                    busy_out <= '0';
                    output_out <= '1';
                    if START='0' then
                        state_next <= IDLE;
                    else
                        state_next <= WAIT_STOP;
                    end if;
                when others =>
                    state_next <= IDLE;
            end case;
    end process;
    
    update_outputs : process(CLK, busy_out, output_out)
    begin
        if falling_edge(CLK) then
            BUSY <= busy_out;
            OUTPUT <= output_out;
        end if;
    end process;
end RTL;
