library ieee;
    use ieee.std_logic_1164.all;

-------------------------------------------------

entity PWM_clock is
    generic (
        PERIOD : integer := 3 
    );
    port (
        clk   : in    std_logic; 
        rst   : in    std_logic;
        pulse : out   std_logic  
    );
end entity PWM_clock;

-------------------------------------------------

architecture behavioral of PWM_clock is
 
    signal sig_count : integer range 0 to PERIOD - 1;
begin

    p_clk_enable : process (clk) is
    begin

        if (rising_edge(clk)) then                 
            if (rst = '1') then                    
                sig_count <= 0;

            elsif (sig_count < (PERIOD - 1)) then
                sig_count <= sig_count + 1;      

            
            else
                sig_count <= 0;
            end if;                                
        end if;

    end process p_clk_enable;

    pulse <= '1' when (sig_count = PERIOD - 1) else
             '0';

end architecture behavioral;