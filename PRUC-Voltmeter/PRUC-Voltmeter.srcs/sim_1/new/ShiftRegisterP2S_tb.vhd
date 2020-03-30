----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.03.2020 11:21:58
-- Design Name: 
-- Module Name: ShiftRegisterP2S_tb - Behavioral
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

entity ShiftRegisterP2S_tb is
--  Port ( );
end ShiftRegisterP2S_tb;

architecture Behavioral of ShiftRegisterP2S_tb is
    component ShiftRegisterP2S is
        Generic (NUMBER_OF_BITS : integer);
        Port ( DIN : in STD_LOGIC_VECTOR (NUMBER_OF_BITS-1 downto 0);
               CLK : in STD_LOGIC;
               START : in STD_LOGIC;
               RST : in STD_LOGIC;
               BUSY: out STD_LOGIC;
               OUTPUT : out STD_LOGIC;
               b_counter : out integer);
    end component;
    
    signal sr_clk, sr_start, sr_output, sr_rst, sr_busy : STD_LOGIC;
    signal sr_din : STD_LOGIC_VECTOR(7 downto 0);
    signal sr_b_counter : integer;
    
    signal step_counter : STD_LOGIC_VECTOR(6 downto 0) := (others => '0');
begin
     uart_shift_register: ShiftRegisterP2S
        generic map(NUMBER_OF_BITS => 8)
        port map(CLK => sr_clk, START => sr_start, OUTPUT => sr_output, DIN => sr_din, RST => sr_rst, BUSY => sr_busy, b_counter => sr_b_counter);

    sr_din <= "01010101";
    
    process
    begin
        sr_clk <= '0';
        if step_counter > 1 then
            sr_rst <= '0';
        else
            sr_rst <= '1';
        end if;
        
        if step_counter > 3 then
            sr_start <= '1';
        else
            sr_start <= '0';
        end if;
        wait for 5 us;
        
        sr_clk <= '1';
        wait for 5 us;
        
        step_counter <= step_counter + 1;
    end process;

end Behavioral;
