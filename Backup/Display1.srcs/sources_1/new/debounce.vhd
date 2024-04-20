----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/20/2024 11:14:50 AM
-- Design Name: 
-- Module Name: debounce - Behavioral
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

entity debounce is
    Port ( clk      : in STD_LOGIC;
           rst      : in STD_LOGIC;
           en       : in STD_LOGIC;
           bouncey  : in STD_LOGIC;
           clean    : out STD_LOGIC);
end debounce;

architecture Behavioral of debounce is
    
    type state_type is (
            RELEASED,
            PRESSED,
            PRE_RELEASED,
            PRE_PRESSED
            );
    signal state : state_type;
    
    constant DEB_COUNT  : integer := 4;
    signal sig_count    : integer range 0 to DEB_COUNT; 
    signal sig_clean    : STD_LOGIC; 
    signal sig_delayed  : STD_LOGIC;

begin

    -- Process implementing a finite state machine (FSM) for
    -- button debouncing. Handles transitions between different
    -- states based on clock signal and bouncey button input.
    p_fsm : process (clk) is
    begin

        if rising_edge(clk) then
            -- Active-high reset
            if (rst = '1') then
                state <= RELEASED;
            -- Clock enable
            elsif (en = '1') then
                -- Define transitions between states
                case state is

                    when RELEASED =>
                        -- If bouncey button = 1 then clear counter and change to PRE_PRESSED;
                        if (bouncey = '1') then 
                            sig_count <= 0;
                            state <= PRE_PRESSED;
                        end if; 
                        
                    when PRE_PRESSED =>
                        -- If button = 1 increment counter
                        if (bouncey = '1') then
                            sig_count <= sig_count + 1;
                            -- if counter = DEB_COUNT-1 change to PRESSED
                            if (sig_count = DEB_COUNT - 1) then 
                                state <= PRESSED;
                            else 
                                state <= PRE_PRESSED;
                            end if;
                        
                        -- else change to RELEASED
                        else
                            state <= RELEASED;
                        end if;
                        
                    when PRESSED =>
                        -- If button = 0 then clear counter and change to PRE_RELEASED;
                        if (bouncey = '0') then
                            sig_count <= 0;
                            state <= PRE_RELEASED;
                        end if;
                                    
                    when PRE_RELEASED =>
                        -- If button = 0 then increment counter
                        if (bouncey = '0') then
                            sig_count <= sig_count + 1;
                               
                            -- if counter = DEB_COUNT-1 change to RELEASED;
                            if (sig_count = DEB_COUNT - 1) then
                                state <= RELEASED;
                            end if;
                        -- else clear counter and change to PRESSED;
                        else
                            state <= PRESSED;
                        end if;
                    -- Prevent unhandled cases
                    when others =>
                        null;
                end case;
            end if;
        end if;

    end process p_fsm;

    -- Set clean signal value = 1 when states PRESSED or PRE_RELEASED
    
    sig_clean <= '1' when (state = PRESSED) or (state = PRE_RELEASED) else '0';

    -- Assign output debounced signal
    clean <= sig_clean;
    
    
    
    
end architecture behavioral;



