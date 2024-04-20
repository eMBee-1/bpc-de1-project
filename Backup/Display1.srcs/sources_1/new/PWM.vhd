-- PWM Controller in VHDL
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity PWM is
    Port (
        clk : in STD_LOGIC;  
        rst : in STD_LOGIC;  
        pwm_out : out STD_LOGIC;  
        duty_cycle : in STD_LOGIC_VECTOR(3 downto 0)
       -- per : in STD_LOGIC_VECTOR(7 downto 0) 
    );
end entity PWM;

architecture Behavioral of PWM is
    signal counter : integer := 0;
    --signal period : integer := 10_000;  -- Set PWM period (adjust as needed)
    signal period : integer := 10;  -- Set PWM period (adjust as needed)
begin
    
    process (clk, rst)
    begin
        if rst = '1' then
            counter <= 0;
            pwm_out <= '0';
        elsif rising_edge(clk) then
            counter <= counter + 1;
            
            if counter = period then
                counter <= 0;
            end if;            
            
            if counter < unsigned(duty_cycle) then
                pwm_out <= '1';  -- PWM ON
            else
                pwm_out <= '0';  -- PWM OFF
            end if;
        end if;
    end process;
end architecture Behavioral;

