----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.04.2020 01:07:33
-- Design Name: 
-- Module Name: AdcInterface - Behavioral
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

entity AdcInterface is
    Port ( CLK : in STD_LOGIC);
end AdcInterface;

architecture Behavioral of AdcInterface is
    component xadc_wiz_0 is
    Port (  daddr_in : in STD_LOGIC_VECTOR ( 6 downto 0 );
            den_in : in STD_LOGIC;
            di_in : in STD_LOGIC_VECTOR ( 15 downto 0 );
            dwe_in : in STD_LOGIC;
            do_out : out STD_LOGIC_VECTOR ( 15 downto 0 );
            drdy_out : out STD_LOGIC;
            dclk_in : in STD_LOGIC;
            reset_in : in STD_LOGIC;
            vauxp4 : in STD_LOGIC;
            vauxn4 : in STD_LOGIC;
            busy_out : out STD_LOGIC;
            channel_out : out STD_LOGIC_VECTOR ( 4 downto 0 );
            eoc_out : out STD_LOGIC;
            eos_out : out STD_LOGIC;
            alarm_out : out STD_LOGIC;
            muxaddr_out : out STD_LOGIC_VECTOR ( 4 downto 0 );
            vp_in : in STD_LOGIC;
            vn_in : in STD_LOGIC);
    end component;

begin


end Behavioral;
