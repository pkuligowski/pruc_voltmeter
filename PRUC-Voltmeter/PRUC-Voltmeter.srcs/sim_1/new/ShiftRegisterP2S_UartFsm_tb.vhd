----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.03.2020 22:33:23
-- Design Name: 
-- Module Name: ShiftRegisterP2S_UartFsm_tb - Behavioral
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

entity ShiftRegisterP2S_UartFsm_tb is
--  Port ( );
end ShiftRegisterP2S_UartFsm_tb;

architecture Behavioral of ShiftRegisterP2S_UartFsm_tb is
    component ShiftRegisterP2S is
        Port ( DIN : in STD_LOGIC_VECTOR (7 downto 0);
               CLK : in STD_LOGIC;
               START : in STD_LOGIC;
               RST : in STD_LOGIC;
               BUSY: out STD_LOGIC;
               OUTPUT : out STD_LOGIC);
    end component;
    
    component UartFsm is
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
    end component;

    signal clock_serial_tx, clock_trigger : STD_LOGIC;
    signal uart_bus : STD_LOGIC_VECTOR(7 downto 0);
    signal serial_output, serial_start, serial_busy : STD_LOGIC;

    signal step_counter, reset_counter : STD_LOGIC_VECTOR(6 downto 0) := (others => '0');
    
    signal global_reset : STD_LOGIC;
begin
    uart_shift_register: ShiftRegisterP2S
        port map(CLK => clock_serial_tx, START => serial_start, OUTPUT => serial_output, DIN => uart_bus, RST => global_reset, BUSY => serial_busy);
    
    uart_buffer: UartFsm
        port map(CLK => clock_serial_tx,
                 RST => global_reset,
                 BUSY => serial_busy,
                 TRIGGER => clock_trigger,
                 DIN_0 => "10101010",
                 DIN_1 => "01010101",
                 DIN_2 => "10101010",
                 DIN_3 => "01010101",
                 DIN_4 => "10101010",
                 DIN_5 => "01010101",
                 DIN_6 => "10101010",
                 START => serial_start,
                 DOUT => uart_bus);
    
    process
    begin
        clock_serial_tx <= '0';
        if step_counter > 32 then
            if step_counter > 96 then
                clock_trigger <= '0';
            else
                clock_trigger <= '1';
            end if;
        else
            clock_trigger <= '0';
        end if;
        
        wait for 50 us;
        
        clock_serial_tx <= '1';
        wait for 50 us;
        
        step_counter <= step_counter + 1;
        
        if reset_counter < 10 then
            global_reset <= '1';
            reset_counter <= reset_counter + 1;
        else
            global_reset <= '0';
        end if;
    end process;

end Behavioral;
