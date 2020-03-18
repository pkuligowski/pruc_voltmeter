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
           LED : out STD_LOGIC);
end Top;

architecture Behavioral of Top is
    component ClockPrescaler is
        Generic (prescaler: STD_LOGIC_VECTOR(23 downto 0));
        Port ( CLK_IN : in STD_LOGIC;
               CLK_OUT : out STD_LOGIC);
    end component;
    
    component ClockCounter is
        Generic ( OVERFLOW: STD_LOGIC_VECTOR(23 downto 0));
        Port ( CLK : in STD_LOGIC;
           LOAD : in STD_LOGIC;
           BUSY : out STD_LOGIC;
           DOUT : out STD_LOGIC_VECTOR(23 downto 0));
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

    signal clock_input, clock_serial_tx, clock_trigger : std_logic;
    signal counter_overflow : std_logic;
    signal counter_data : std_logic_vector(23 downto 0);
begin
    prescaler_serial_tx: ClockPrescaler                                    
        generic map(prescaler => "000000000000001001110001") -- 9600*2 Hz    
        port map(CLK_IN => clock_input, CLK_OUT => clock_serial_tx);

    prescaler_trigger: ClockPrescaler 
        generic map(prescaler => "000000000010010110000000") -- 1 Hz  
        port map(CLK_IN => clock_serial_tx, CLK_OUT => clock_trigger);
    
    --counter: ClockCounter
    --    generic map(OVERFLOW => "000000000000000000010010")
    --    port map(CLK => clock_serial_tx, LOAD => clock_trigger, DOUT => counter_data, BUSY => counter_overflow);
        
    uart_shift_register: ShiftRegisterP2S
        generic map(NUMBER_OF_BITS => 10)
        port map(CLK => clock_serial_tx, START => clock_trigger, OUTPUT => SERIAL_OUT, DIN => "1010101011", RST => '0');

    clock_input <= CLK_GLOBAL;

    LED <= clock_trigger;
end Behavioral;
