----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.03.2020 18:53:09
-- Design Name: 
-- Module Name: FsmUartSend_tb - Behavioral
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

entity FsmUartSend_tb is

end FsmUartSend_tb;

architecture Behavioral of FsmUartSend_tb is
    component FsmUartSend is
    Port ( TRIGGER : in STD_LOGIC;
           SR_RST : out STD_LOGIC;
           SR_CLK : out STD_LOGIC;
           RST : in STD_LOGIC;
           CLK : in STD_LOGIC;
           SR_START : out STD_LOGIC;
           SR_BUSY : in STD_LOGIC);
    end component;

    signal fsm_trigger, fsm_sr_rst, fsm_sr_clk, fsm_rst, fsm_clk, fsm_sr_start, fsm_sr_busy : STD_LOGIC;
    signal step_counter : STD_LOGIC_VECTOR(6 downto 0) := (others => '0');
begin
    fsm_uart_send: FsmUartSend
        port map(TRIGGER => fsm_trigger, SR_RST => fsm_sr_rst, SR_CLK => fsm_sr_clk, RST => fsm_rst, CLK => fsm_clk, SR_START => fsm_sr_start, SR_BUSY => fsm_sr_busy);

    process
    begin
        fsm_clk <= '0';
        if step_counter > 1 then
            fsm_rst <= '0';
        else
            fsm_rst <= '1';
        end if;
        
        if step_counter > 3 then
            fsm_trigger <= '1';
        else
            fsm_trigger <= '0';
        end if;
        
        if step_counter > 8 then
            if step_counter > 17 then
                fsm_sr_busy <= '0';
            else
                fsm_sr_busy <= '1';
            end if;
        else
            fsm_sr_busy <= '0';
        end if;
        
        wait for 5 us;
        
        fsm_clk <= '1';
        wait for 5 us;
        
        step_counter <= step_counter + 1;
    end process;

end Behavioral;
