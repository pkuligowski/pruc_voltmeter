----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.03.2020 21:03:05
-- Design Name: 
-- Module Name: Top - Behavioral
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

entity Top is
    Port ( CLK_GLOBAL : in STD_LOGIC;
           SERIAL_OUT : out STD_LOGIC;
           LED : out STD_LOGIC;
           DEBUG : out STD_LOGIC);
end Top;

architecture Behavioral of Top is
    component ClockPrescaler is
        Generic (prescaler: STD_LOGIC_VECTOR(23 downto 0));
        Port ( CLK_IN : in STD_LOGIC;
               CLK_OUT : out STD_LOGIC);
    end component;
    
    component ClockCounter is
    Port ( CLK : in STD_LOGIC;
           DOUT : out STD_LOGIC_VECTOR(15 downto 0));
    end component;
    
    component ShiftRegisterP2S is
    Generic (NUMBER_OF_BITS : integer);
    Port ( DIN : in STD_LOGIC_VECTOR (NUMBER_OF_BITS-1 downto 0);
               CLK : in STD_LOGIC;
               START : in STD_LOGIC;
               RST : in STD_LOGIC;
               BUSY: out STD_LOGIC;
               OUTPUT : out STD_LOGIC);
    end component;

    component UartBuffer is
    Port ( CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           BUSY : in STD_LOGIC;
           TRIGGER: in STD_LOGIC;
           DIN_0 : in STD_LOGIC_VECTOR (7 downto 0);
           DIN_1 : in STD_LOGIC_VECTOR (7 downto 0);
           START : out STD_LOGIC;
           DOUT : out STD_LOGIC_VECTOR (7 downto 0));
    end component;
    
    component Reset is
    Port ( CLK : in STD_LOGIC;
           RST : out STD_LOGIC);
    end component;

    signal clock_input, clock_serial_tx, clock_trigger, clock_buffers : STD_LOGIC;
    signal counter_overflow : STD_LOGIC;
    signal counter_data : STD_LOGIC_VECTOR(15 downto 0);
    signal uart_bus : STD_LOGIC_VECTOR(7 downto 0);
    signal serial_output, global_reset, serial_busy, serial_start : STD_LOGIC;
    
begin
    prescaler_serial_tx: ClockPrescaler                                    
        generic map(prescaler => "000000000000001001110001") -- 9600*2 Hz    
        port map(CLK_IN => clock_input, CLK_OUT => clock_serial_tx);

    prescaler_trigger: ClockPrescaler 
        ---generic map(prescaler => "000000000010010110000000") -- 1 Hz
        generic map(prescaler => "000000000000000000110100") -- 100 Hz  
        port map(CLK_IN => clock_serial_tx, CLK_OUT => clock_trigger);
    
    counter: ClockCounter
        port map(CLK => clock_trigger, DOUT => counter_data);
        
    uart_shift_register: ShiftRegisterP2S
        generic map(NUMBER_OF_BITS => 8)
        port map(CLK => clock_serial_tx, START => serial_start, OUTPUT => serial_output, DIN => uart_bus, RST => global_reset, BUSY => serial_busy);

    uart_buffer: UartBuffer
        --port map(CLK => clock_serial_tx, RST => global_reset, BUSY => serial_busy, TRIGGER => clock_trigger, DIN_0 => "10101010", DIN_1 => "01010101", START => serial_start, DOUT => uart_bus);
        port map(CLK => clock_serial_tx, RST => global_reset, BUSY => serial_busy, TRIGGER => clock_trigger, DIN_0 => counter_data(7 downto 0), DIN_1 => counter_data(15 downto 8), START => serial_start, DOUT => uart_bus);

    reset_generator: Reset
        port map(CLK => clock_serial_tx, RST => global_reset);

    DEBUG <= serial_output;
    SERIAL_OUT <= serial_output;

    clock_input <= CLK_GLOBAL;

    LED <= clock_trigger;
end Behavioral;
