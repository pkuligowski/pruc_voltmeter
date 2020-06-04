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
           DEBUG : out STD_LOGIC;
           xa_n, xa_p : in STD_LOGIC);
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
    
    component Reset is
    Port ( CLK : in STD_LOGIC;
           RST : out STD_LOGIC);
    end component;
    
    --component ila_0 is
    --Port ( clk : in STD_LOGIC;
           --probe0 : in STD_LOGIC_VECTOR ( 0 to 0 );
           --probe1 : in STD_LOGIC_VECTOR ( 0 to 0 ));
    --end component;
    
    component Adc is
    Port ( RESET : in STD_LOGIC;
           CLK : in STD_LOGIC;
           xa_n, xa_p : in STD_LOGIC;
           DOUT : out STD_LOGIC_VECTOR(15 downto 0));
    end component;
    
    component AdcRawToMv is
    Port ( RESET : in STD_LOGIC;
           CLK : in STD_LOGIC;
           DIN : in STD_LOGIC_VECTOR(15 downto 0);
           DOUT : out STD_LOGIC_VECTOR(15 downto 0));
    end component;
    
    component AdcMvToAscii is
    Port ( RESET : in STD_LOGIC;
           CLK : in STD_LOGIC;
           DIN : in STD_LOGIC_VECTOR(15 downto 0);
           ASCIIOUT : out STD_LOGIC_VECTOR(31 downto 0));
    end component;

    signal clock_input, clock_serial_tx, clock_trigger, clock_buffers : STD_LOGIC;
    signal counter_overflow : STD_LOGIC;
    signal counter_data, adc_data_raw, adc_data_mv : STD_LOGIC_VECTOR(15 downto 0);
    signal uart_bus : STD_LOGIC_VECTOR(7 downto 0);
    signal adc_ascii : STD_LOGIC_VECTOR(31 downto 0);
    signal serial_output, global_reset, serial_busy, serial_start : STD_LOGIC;
    
begin
    prescaler_serial_tx: ClockPrescaler                                    
        generic map(prescaler => "000000000000001001110001") -- 9600 Hz    
        port map(CLK_IN => clock_input,
                 CLK_OUT => clock_serial_tx);

    prescaler_trigger: ClockPrescaler 
        generic map(prescaler => "000000000001001011000000") -- 1 Hz
        port map(CLK_IN => clock_serial_tx,
                 CLK_OUT => clock_trigger);

    uart_shift_register: ShiftRegisterP2S
        port map(CLK => clock_serial_tx,
                 START => serial_start,
                 OUTPUT => serial_output,
                 DIN => uart_bus,
                 RST => global_reset,
                 BUSY => serial_busy);

    uart_buffer: UartFsm
        port map(CLK => clock_serial_tx,
                 RST => global_reset,
                 BUSY => serial_busy,
                 TRIGGER => clock_trigger,
                 DIN_0 => adc_ascii(31 downto 24),
                 DIN_1 => "00101110", -- .
                 DIN_2 => adc_ascii(23 downto 16),
                 DIN_3 => adc_ascii(15 downto 8),
                 DIN_4 => adc_ascii(7 downto 0),
                 DIN_5 => "00001101", -- \r
                 DIN_6 => "00001010", -- \n
                 START => serial_start,
                 DOUT => uart_bus);

    reset_generator: Reset
        port map(CLK => clock_serial_tx,
                 RST => global_reset);

    --ila: ila_0
        --port map(clk => clock_input,
                 --probe0(0) => global_reset,
                 --probe1(0)=> serial_output);

    aadc: Adc
        port map(RESET => global_reset,
                 CLK => clock_input,
                 xa_n => xa_n,
                 xa_p => xa_p,
                 DOUT => adc_data_raw);

    adc_raw_to_mv: AdcRawToMv
        port map(RESET => global_reset,
                 CLK => clock_input,
                 DIN => adc_data_raw,
                 DOUT => adc_data_mv);

    adc_mv_to_ascii: AdcMvToAscii
        port map(RESET => global_reset,
                 CLK => clock_input,
                 DIN => adc_data_mv,
                 ASCIIOUT => adc_ascii);

    clock_input <= CLK_GLOBAL;

    DEBUG <= serial_output;
    SERIAL_OUT <= serial_output;
    LED <= clock_trigger;
end Behavioral;
