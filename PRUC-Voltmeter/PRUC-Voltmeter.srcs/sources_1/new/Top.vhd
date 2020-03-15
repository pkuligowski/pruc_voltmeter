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

    signal clock_internal, clock_internal_i : std_logic;
    signal prescaler_input, prescaler_output : std_logic;
begin
    clock_internal <= CLK_GLOBAL;
    
    prescaler_uart: ClockPrescaler 
        generic map (prescaler => "000101101110001101100000") -- 4 Hz  
        port map(CLK_IN => prescaler_input, CLK_OUT => prescaler_output);

    prescaler_input <= clock_internal;
    
    LED <= prescaler_output;
    SERIAL_OUT <= prescaler_output;

end Behavioral;
