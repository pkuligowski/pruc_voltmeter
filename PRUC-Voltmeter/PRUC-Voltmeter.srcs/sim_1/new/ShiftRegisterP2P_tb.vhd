----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.03.2020 18:09:53
-- Design Name: 
-- Module Name: ShiftRegisterP2P_tb - Behavioral
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

entity ShiftRegisterP2P_tb is
    Port ( DIN : in STD_LOGIC_VECTOR (7 downto 0);
           CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           DOUT : out STD_LOGIC_VECTOR (7 downto 0));
end ShiftRegisterP2P_tb;

architecture Behavioral of ShiftRegisterP2P_tb is
    component ShiftRegisterP2P is
    Generic (NUMBER_OF_BITS : integer);
    Port ( DIN : in STD_LOGIC_VECTOR (7 downto 0);
           CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           DOUT : out STD_LOGIC_VECTOR (7 downto 0));
    end component;
    
    signal clock, reset : STD_LOGIC;
    signal test_din : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
begin
    shift_register_p2p: ShiftRegisterP2P      
        generic map(NUMBER_OF_BITS => 8)                    
        port map(CLK => clock, DIN => test_din, RST => reset, DOUT => DOUT);

    process
    begin
        clock <= '0';
        wait for 100 us;
        clock <= '1';
        wait for 100 us;
        test_din <= test_din + 1;
    end process;
    
    process
    begin
        reset <= '0';
        wait for 1000 us;
        reset <= '1';
        wait for 1000 us;
    end process;

end Behavioral;
