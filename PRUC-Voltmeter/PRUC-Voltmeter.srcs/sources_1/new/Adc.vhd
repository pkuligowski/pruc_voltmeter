----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.05.2020 01:01:42
-- Design Name: 
-- Module Name: Adc - Behavioral
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

entity Adc is
    Port ( RESET : in STD_LOGIC;
           CLK : in STD_LOGIC;
           xa_n, xa_p : in STD_LOGIC;
           DOUT : out STD_LOGIC_VECTOR(15 downto 0));
end Adc;

architecture Behavioral of Adc is
    type state_type is (init_read, read_waitdrdy,
                    write_waitdrdy,
                    read_reg00,
                    reg00_waitdrdy);

    component xadc_wiz_0 is
    Port ( daddr_in        : in  STD_LOGIC_VECTOR (6 downto 0);     -- Address bus for the dynamic reconfiguration port
           den_in          : in  STD_LOGIC;                         -- Enable Signal for the dynamic reconfiguration port
           di_in           : in  STD_LOGIC_VECTOR (15 downto 0);    -- Input data bus for the dynamic reconfiguration port
           dwe_in          : in  STD_LOGIC;                         -- Write Enable for the dynamic reconfiguration port
           do_out          : out  STD_LOGIC_VECTOR (15 downto 0);   -- Output data bus for dynamic reconfiguration port
           drdy_out        : out  STD_LOGIC;                        -- Data ready signal for the dynamic reconfiguration port
           dclk_in         : in  STD_LOGIC;                         -- Clock input for the dynamic reconfiguration port
           reset_in        : in  STD_LOGIC;                         -- Reset signal for the System Monitor control logic
           vauxp4          : in  STD_LOGIC;                         -- Auxiliary Channel 4
           vauxn4          : in  STD_LOGIC;
           busy_out        : out  STD_LOGIC;                        -- ADC Busy signal
           channel_out     : out  STD_LOGIC_VECTOR (4 downto 0);    -- Channel Selection Outputs
           eoc_out         : out  STD_LOGIC;                        -- End of Conversion Signal
           eos_out         : out  STD_LOGIC;                        -- End of Sequence Signal
           alarm_out       : out STD_LOGIC;                         -- OR'ed output of all the Alarms
           vp_in           : in  STD_LOGIC;                         -- Dedicated Analog Input Pair
           vn_in           : in  STD_LOGIC);
    end component;
    
    signal adc_eos, adc_drdy, adc_busy : STD_LOGIC;
    signal adc_do, adc_di, MEASUREMENT : STD_LOGIC_VECTOR(15 downto 0);
    signal adc_daddr : STD_LOGIC_VECTOR(6 downto 0);
    signal den_reg, dwe_reg: STD_LOGIC_VECTOR (1 downto 0);

    signal state, next_state : state_type;
begin
    xadc: xadc_wiz_0
        port map(daddr_in => adc_daddr,
           den_in => den_reg(0),
           di_in => adc_di,
           dwe_in => dwe_reg(0),
           do_out => adc_do,
           drdy_out => adc_drdy,
           dclk_in => CLK,
           reset_in => RESET,
           vauxp4 => xa_p,
           vauxn4 => xa_n,
           busy_out => adc_busy,
           channel_out => open,
           eoc_out => open,
           eos_out => adc_eos,
           alarm_out => open,
           vp_in => '0',
           vn_in => '0');

    NEXT_STATE_DECODE: process (CLK, RESET)
	begin
        if (RESET = '1') then
		    state <= init_read;	
        elsif (CLK'event and CLK = '1') then
			 case (state) is
				 when init_read =>
					 adc_daddr       <= "1000000";
					 den_reg     <= "10";
					 dwe_reg     <= "00"; -- performing read
					 state <= read_waitdrdy;
				 when read_waitdrdy =>
					 if adc_drdy = '1' then
						 state <= write_waitdrdy;
						 adc_di  <= adc_do;--  AND "0000001111111111"; --Clearing AVG bits for Configreg0
						 adc_daddr   <= "1000000";
						 den_reg <= "10";
						 dwe_reg <= "10"; -- performing write
					 else
						 state <= read_waitdrdy;
						 den_reg <= "0" & den_reg(1) ;
						 dwe_reg <= "0" & dwe_reg(1) ;
					 end if;
				 when write_waitdrdy =>
					 if adc_drdy = '1' then
						 state <= read_reg00;
						 den_reg <= den_reg;
						 dwe_reg <= dwe_reg; --performing write
					 else
						 den_reg <= "0" & den_reg(1) ;
						 dwe_reg <= "0" & dwe_reg(1) ;
						 state <= write_waitdrdy;
					 end if;
				 when read_reg00 =>
						 adc_daddr       <= "0010100";
						 den_reg     <= "10";
						 state <= reg00_waitdrdy;
				 when reg00_waitdrdy =>
					if adc_drdy = '1' then
						 DOUT <= adc_do;
						 den_reg <= den_reg;
						 dwe_reg <= dwe_reg;
						 state <= init_read;
					else
						 den_reg <= "0" & den_reg(1) ;
						 dwe_reg <= "0" & dwe_reg(1) ;
						 state <= reg00_waitdrdy;
					end if;
				 when others =>
					 state <= init_read ;
			 end case;      
		end if;
	end process;

end Behavioral;
