----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.03.2020 22:33:23
-- Design Name: 
-- Module Name: FsmUartSend_ShiftRegisterP2S_tb - Behavioral
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

entity FsmUartSend_ShiftRegisterP2S_tb is
--  Port ( );
end FsmUartSend_ShiftRegisterP2S_tb;

architecture Behavioral of FsmUartSend_ShiftRegisterP2S_tb is
    component ShiftRegisterP2S is
        Generic (NUMBER_OF_BITS : integer);
        Port ( DIN : in STD_LOGIC_VECTOR (NUMBER_OF_BITS-1 downto 0);
               CLK : in STD_LOGIC;
               START : in STD_LOGIC;
               RST : in STD_LOGIC;
               BUSY: out STD_LOGIC;
               OUTPUT : out STD_LOGIC);
    end component;
    
    component ShiftRegisterP2P is
    Generic (NUMBER_OF_BITS : integer);
    Port ( DIN : in STD_LOGIC_VECTOR (NUMBER_OF_BITS-1 downto 0);
           CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           DOUT : out STD_LOGIC_VECTOR (NUMBER_OF_BITS-1 downto 0));
    end component;

    component FsmUartSend is
    Port ( TRIGGER : in STD_LOGIC;
           SR_RST : out STD_LOGIC;
           SR_CLK : out STD_LOGIC;
           RST : in STD_LOGIC;
           CLK : in STD_LOGIC;
           SR_START : out STD_LOGIC;
           SR_BUSY : in STD_LOGIC);
    end component;
    
    signal clock_serial_tx, clock_trigger : STD_LOGIC;
    signal uart_buffer_bus : STD_LOGIC_VECTOR(7 downto 0);
    signal fsm_sr_clk_0, fsm_sr_rst_0, fsm_sr_start_0, fsm_sr_busy_0 : STD_LOGIC;
    signal serial_output : STD_LOGIC;

    signal step_counter : STD_LOGIC_VECTOR(6 downto 0) := (others => '0');
    
    signal global_reset : STD_LOGIC;
begin
    uart_shift_register: ShiftRegisterP2S
        generic map(NUMBER_OF_BITS => 8)
        port map(CLK => clock_serial_tx, START => fsm_sr_start_0, OUTPUT => serial_output, DIN => uart_buffer_bus, RST => global_reset, BUSY => fsm_sr_busy_0);
    
    uart_fsm_send_0: FsmUartSend
        port map(TRIGGER => clock_trigger, SR_RST => fsm_sr_rst_0, SR_CLK => fsm_sr_clk_0, RST => global_reset, CLK => clock_serial_tx, SR_START => fsm_sr_start_0, SR_BUSY => fsm_sr_busy_0);

    uart_buffer_0: ShiftRegisterP2P      
        generic map(NUMBER_OF_BITS => 8)                    
        port map(CLK => fsm_sr_clk_0, DIN => "01010101", RST => fsm_sr_rst_0, DOUT => uart_buffer_bus);

    process
    begin
        clock_serial_tx <= '0';
        if step_counter > 8 then
            if step_counter > 9 then
                clock_trigger <= '0';
            else
                clock_trigger <= '1';
            end if;
        else
            clock_trigger <= '0';
        end if;
        
        if step_counter > 1 then
            global_reset <= '0';
        else
            global_reset <= '1';
        end if;
        
        wait for 50 us;
        
        clock_serial_tx <= '1';
        wait for 50 us;
        
        step_counter <= step_counter + 1;
    end process;

end Behavioral;
