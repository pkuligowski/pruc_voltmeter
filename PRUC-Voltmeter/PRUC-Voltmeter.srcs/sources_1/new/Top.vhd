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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

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

    component FsmUart is
    Port ( START : in STD_LOGIC;
           TRIGGER_1 : out STD_LOGIC;
           BUSY : in STD_LOGIC;
           TRIGGER_2 : out STD_LOGIC;
           RST : in STD_LOGIC;
           CLK : in STD_LOGIC );
    end component;

    signal clock_input, clock_serial_tx, clock_trigger, clock_buffers : STD_LOGIC;
    signal counter_overflow : STD_LOGIC;
    signal counter_data : STD_LOGIC_VECTOR(15 downto 0);
    signal uart_buffer_bus : STD_LOGIC_VECTOR(7 downto 0);
    signal fsm_sr_clk_0, fsm_sr_rst_0, fsm_sr_start_0, fsm_sr_trig_0 : STD_LOGIC;
    signal fsm_sr_clk_1, fsm_sr_rst_1, fsm_sr_start_1, fsm_sr_trig_1 : STD_LOGIC;
    signal serial_output, global_reset, fsm_sr_busy : STD_LOGIC;
    
    signal global_reset_counter : integer := 0;
begin
    prescaler_serial_tx: ClockPrescaler                                    
        generic map(prescaler => "000000000000001001110001") -- 9600*2 Hz    
        port map(CLK_IN => clock_input, CLK_OUT => clock_serial_tx);

    prescaler_trigger: ClockPrescaler 
        generic map(prescaler => "000000000010010110000000") -- 1 Hz  
        port map(CLK_IN => clock_serial_tx, CLK_OUT => clock_trigger);
    
    counter: ClockCounter
        port map(CLK => clock_trigger, DOUT => counter_data);
        
    uart_shift_register: ShiftRegisterP2S
        generic map(NUMBER_OF_BITS => 8)
        port map(CLK => clock_serial_tx, START => fsm_sr_start_0, OUTPUT => serial_output, DIN => uart_buffer_bus, RST => global_reset, BUSY => fsm_sr_busy);

    DEBUG <= serial_output;
    SERIAL_OUT <= serial_output;
    
    fsm_uart: FsmUart
        port map(START => clock_trigger, TRIGGER_1 => fsm_sr_trig_0, BUSY => fsm_sr_busy, TRIGGER_2 => fsm_sr_trig_1, RST => global_reset, CLK => clock_serial_tx);

    uart_fsm_send_0: FsmUartSend
        port map(TRIGGER => fsm_sr_trig_0, SR_RST => fsm_sr_rst_0, SR_CLK => fsm_sr_clk_0, RST => global_reset, CLK => clock_serial_tx, SR_START => fsm_sr_start_0, SR_BUSY => fsm_sr_busy);

    uart_fsm_send_1: FsmUartSend
        port map(TRIGGER => fsm_sr_trig_1, SR_RST => fsm_sr_rst_1, SR_CLK => fsm_sr_clk_1, RST => global_reset, CLK => clock_serial_tx, SR_START => fsm_sr_start_1, SR_BUSY => fsm_sr_busy);

    uart_buffer_0: ShiftRegisterP2P      
        generic map(NUMBER_OF_BITS => 8)                    
        port map(CLK => fsm_sr_clk_0, DIN => "11001100", RST => fsm_sr_rst_0, DOUT => uart_buffer_bus);

    uart_buffer_1: ShiftRegisterP2P      
        generic map(NUMBER_OF_BITS => 8)                    
        port map(CLK => fsm_sr_clk_1, DIN => "00110010", RST => fsm_sr_rst_1, DOUT => uart_buffer_bus);
    
    clock_input <= CLK_GLOBAL;

    LED <= clock_trigger;

    global_reset <= '0';
end Behavioral;
