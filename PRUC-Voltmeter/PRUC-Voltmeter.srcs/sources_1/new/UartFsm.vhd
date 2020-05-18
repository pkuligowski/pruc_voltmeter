----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.03.2020 02:53:21
-- Design Name: 
-- Module Name: UartFsm - Behavioral
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

entity UartFsm is
    Port ( CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           BUSY : in STD_LOGIC;
           TRIGGER: in STD_LOGIC;
           DIN_0 : in STD_LOGIC_VECTOR (7 downto 0);
           DIN_1 : in STD_LOGIC_VECTOR (7 downto 0);
           DIN_2 : in STD_LOGIC_VECTOR (7 downto 0);
           DIN_3 : in STD_LOGIC_VECTOR (7 downto 0);
           DIN_4 : in STD_LOGIC_VECTOR (7 downto 0);
           DIN_5 : in STD_LOGIC_VECTOR (7 downto 0);
           DIN_6 : in STD_LOGIC_VECTOR (7 downto 0);
           START : out STD_LOGIC;
           DOUT : out STD_LOGIC_VECTOR (7 downto 0));
end UartFsm;

architecture RTL of UartFsm is
    type state_type is (IDLE,
                        SEND_0, NOP_0, WAIT_0,
                        SEND_1, NOP_1, WAIT_1,
                        SEND_2, NOP_2, WAIT_2,
                        SEND_3, NOP_3, WAIT_3,
                        SEND_4, NOP_4, WAIT_4,
                        SEND_5, NOP_5, WAIT_5,
                        SEND_6, NOP_6, WAIT_6,
                        WAIT_TRIGGER);
    signal state, state_next: state_type;
    
    signal start_out: STD_LOGIC;
    signal dout_out: STD_LOGIC_VECTOR (7 downto 0);
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

    update_state_next : process(state, TRIGGER, BUSY, DIN_0, DIN_1, DIN_2, DIN_3, DIN_4, DIN_5, DIN_6)
    begin
            case state is
                when IDLE =>
                    dout_out <= "11111111";
                    start_out <= '0';

                    if TRIGGER = '1' then
                        state_next <= SEND_0;
                    else
                        state_next <= IDLE;
                    end if;
                    
                when SEND_0 =>
                    start_out <= '1';
                    dout_out <= DIN_0;
                    state_next <= NOP_0;
                when NOP_0 =>
                    start_out <= '1';
                    dout_out <= DIN_0;
                    if BUSY='1' then
                        state_next <= WAIT_0;
                    else
                        state_next <= NOP_0;
                    end if;
                when WAIT_0 => 
                    start_out <= '0';
                    dout_out <= DIN_0;
                    if BUSY='0' then
                        state_next <= SEND_1;
                    else
                        state_next <= WAIT_0;
                    end if;
                    
                when SEND_1 =>
                    start_out <= '1';
                    dout_out <= DIN_1;
                    state_next <= NOP_1;
                when NOP_1 =>
                    start_out <= '1';
                    dout_out <= DIN_1;
                    if BUSY='1' then
                        state_next <= WAIT_1;
                    else
                        state_next <= NOP_1;
                    end if;
                when WAIT_1 =>
                    start_out <= '0';
                    dout_out <= DIN_1;
                    if BUSY='0' then
                        state_next <= SEND_2; 
                    else
                        state_next <= WAIT_1;
                    end if;
                    
                when SEND_2 =>
                    start_out <= '1';
                    dout_out <= DIN_2;
                    state_next <= NOP_2;
                when NOP_2 =>
                    start_out <= '1';
                    dout_out <= DIN_2;
                    if BUSY='1' then
                        state_next <= WAIT_2;
                    else
                        state_next <= NOP_2;
                    end if;
                when WAIT_2 =>
                    start_out <= '0';
                    dout_out <= DIN_2;
                    if BUSY='0' then
                        state_next <= SEND_3; 
                    else
                        state_next <= WAIT_2;
                    end if;
                    
                when SEND_3 =>
                    start_out <= '1';
                    dout_out <= DIN_3;
                    state_next <= NOP_3;
                when NOP_3 =>
                    start_out <= '1';
                    dout_out <= DIN_3;
                    if BUSY='1' then
                        state_next <= WAIT_3;
                    else
                        state_next <= NOP_3;
                    end if;
                when WAIT_3 =>
                    start_out <= '0';
                    dout_out <= DIN_3;
                    if BUSY='0' then
                        state_next <= SEND_4; 
                    else
                        state_next <= WAIT_3;
                    end if;
                
                when SEND_4 =>
                    start_out <= '1';
                    dout_out <= DIN_4;
                    state_next <= NOP_4;
                when NOP_4 =>
                    start_out <= '1';
                    dout_out <= DIN_4;
                    if BUSY='1' then
                        state_next <= WAIT_4;
                    else
                        state_next <= NOP_4;
                    end if;
                when WAIT_4 =>
                    start_out <= '0';
                    dout_out <= DIN_4;
                    if BUSY='0' then
                        state_next <= SEND_5; 
                    else
                        state_next <= WAIT_4;
                    end if;
                    
                when SEND_5 =>
                    start_out <= '1';
                    dout_out <= DIN_5;
                    state_next <= NOP_5;
                when NOP_5 =>
                    start_out <= '1';
                    dout_out <= DIN_5;
                    if BUSY='1' then
                        state_next <= WAIT_5;
                    else
                        state_next <= NOP_5;
                    end if;
                when WAIT_5 =>
                    start_out <= '0';
                    dout_out <= DIN_5;
                    if BUSY='0' then
                        state_next <= SEND_6; 
                    else
                        state_next <= WAIT_5;
                    end if;
                
                when SEND_6 =>
                    start_out <= '1';
                    dout_out <= DIN_6;
                    state_next <= NOP_6;
                when NOP_6 =>
                    start_out <= '1';
                    dout_out <= DIN_6;
                    if BUSY='1' then
                        state_next <= WAIT_6;
                    else
                        state_next <= NOP_6;
                    end if;
                when WAIT_6 =>
                    start_out <= '0';
                    dout_out <= DIN_6;
                    if BUSY='0' then
                        state_next <= WAIT_TRIGGER; 
                    else
                        state_next <= WAIT_6;
                    end if;
                
                when WAIT_TRIGGER =>
                    start_out <= '0';
                    dout_out <= "11111111";
                    if TRIGGER='0' then
                        state_next <= IDLE;
                    else
                        state_next <= WAIT_TRIGGER;
                    end if;
                when others =>
                    state_next <= IDLE;
            end case;
    end process;
    
    update_outputs : process(CLK, start_out, dout_out)
    begin
        if falling_edge(CLK) then
            START <= start_out;
            DOUT <= dout_out;
        end if;
    end process;
end RTL;
