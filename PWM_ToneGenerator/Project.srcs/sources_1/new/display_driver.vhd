library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

entity display_driver is
    port (
        clk     : in    std_logic;
        rst     : in    std_logic;
        data   : in    std_logic_vector(3 downto 0);
        dp_vect : in    std_logic_vector(3 downto 0);
        dp      : out   std_logic;
        seg     : out   std_logic_vector(6 downto 0);
        dig     : out   std_logic_vector(3 downto 0)
    );
end entity display_driver;

architecture behavioral of display_driver is
    component simple_counter is
        generic (
            NBIT : integer
        );
        port (
            clk   : in    std_logic;
            rst   : in    std_logic;
            en    : in    std_logic;
            count : out   std_logic_vector(NBIT - 1 downto 0)
        );
    end component;

    component clock_enable is
        generic (
            PERIOD : integer
        );
        port (
            clk   : in    std_logic;
            rst   : in    std_logic;
            pulse : out   std_logic
        );
    end component;

    component bin2seg is
        port (
            clear : in    std_logic;
            bin   : in    std_logic_vector(1 downto 0);
            seg   : out   std_logic_vector(6 downto 0)
        );
    end component;

    signal sig_en_4ms : std_logic;

    signal sig_cnt_2bit : std_logic_vector(1 downto 0);

    signal sig_bin : std_logic_vector(1 downto 0);
    
begin

    clk_en0 : component clock_enable
        generic map (
            PERIOD => 400_000
        )
        port map (
            clk   => clk,
            rst   => rst,
            pulse => sig_en_4ms
        );

    bin_cnt0 : component simple_counter
        generic map (
            NBIT => 2
        )
        port map (
            clk   => clk,
            rst   => rst,
            en    => sig_en_4ms,
            count => sig_cnt_2bit
        );

    hex2seg : component bin2seg
        port map (
            clear => rst,
            bin   => sig_bin,
            seg   => seg
        );

    p_mux : process (clk) is
    begin

        if rising_edge(clk) then
            if (rst = '1') then
                sig_bin(0) <= data(0);
                dp      <= dp_vect(0);
                dig     <= "1110";
            else
                case sig_cnt_2bit is

                    when "11" =>
                        sig_bin(0) <= data(3);
                        dp      <= dp_vect(3);
                        dig     <= "0111";
                    when "10" =>
                        sig_bin(0) <= data(2);
                        dp      <= dp_vect(2);
                        dig     <= "1011";
                    when "01" =>
                        sig_bin(0) <= data(1);
                        dp      <= dp_vect(1);
                        dig     <= "1101";
                    when others =>
                        sig_bin(0) <= data(0);
                        dp      <= dp_vect(0);
                        dig     <= "1110";
                end case;
            end if;
        end if;

    end process p_mux;

end architecture behavioral;