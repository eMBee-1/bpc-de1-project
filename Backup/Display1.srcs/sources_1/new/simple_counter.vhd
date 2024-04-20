library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all; 

-------------------------------------------------

entity simple_counter is
    generic (
        NBIT : integer := 3 
    );
    port (
        clk   : in    std_logic; 
        rst   : in    std_logic; 
        en    : in    std_logic;  
        count : out   std_logic_vector(NBIT - 1 downto 0) 
    );
end entity simple_counter;

-------------------------------------------------

architecture behavioral of simple_counter is
    signal sig_count : integer range 0 to (2 ** NBIT - 1);
begin

    p_simple_counter : process (clk) is
    begin

        if (rising_edge(clk)) then
            if (rst = '1') then
                sig_count <= 0;

            elsif (en = '1') then
                if (sig_count < (2 ** NBIT - 1)) then
                    sig_count <= sig_count + 1;
                else
                    sig_count <= 0;
                end if;

            end if;
        end if;

    end process p_simple_counter;

    
    count <= std_logic_vector(to_unsigned(sig_count, NBIT));

end architecture behavioral;