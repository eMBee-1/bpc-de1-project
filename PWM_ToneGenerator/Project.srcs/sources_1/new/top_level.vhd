library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity top_level is
    port (
        CLK100MHZ : in    std_logic;
        SW        : in    std_logic_vector(6 downto 0);                 
        CA        : out   std_logic;                     
        CB        : out   std_logic;                     
        CC        : out   std_logic;                     
        CD        : out   std_logic;                     
        CE        : out   std_logic;                     
        CF        : out   std_logic;                     
        CG        : out   std_logic;                     
        DP        : out   std_logic;                     
        AN        : out   std_logic_vector(7 downto 0);  
        BTNC      : in    std_logic;
        AUD_PWM   : out   std_logic;
        AUD_SD    : out   std_logic                                           
    );
end entity top_level;

architecture behavioral of top_level is
    
    signal sig_clk : std_logic;
    
    signal duty : std_logic_vector(3 downto 0);
    
       component display_driver is
        port (
            clk     : in    std_logic;
            rst     : in    std_logic;
            data    : in    std_logic_vector(3 downto 0);
            dp_vect : in    std_logic_vector(3 downto 0);
            dp      : out   std_logic;
            seg     : out   std_logic_vector(6 downto 0);
            dig     : out   std_logic_vector(3 downto 0)
        );
    end component;

    component PWM_clock is
            generic (
                PERIOD : integer
                    );
            Port ( clk : in STD_LOGIC;
                   rst : in STD_LOGIC;
                   pulse : out STD_LOGIC);
        end component PWM_clock;
    
    component PWM is
           Port (
        clk : in STD_LOGIC;  
        rst : in STD_LOGIC;  
        pwm_out : out STD_LOGIC;  
        duty_cycle : in STD_LOGIC_VECTOR(3 downto 0)
    );
    end component;       
    
begin
    duty_cycle : process (duty) is
    begin
    if (SW(6) = '1') then
            duty <= ("0001");
            AUD_SD <= '1';
        elsif (SW(5) = '1') then
            duty <= ("1010");
            AUD_SD <= '1';
        elsif (SW(4) = '1') then
            duty <= ("0010");
            AUD_SD <= '1';
        elsif (SW(3) = '1') then
            duty <= ("1001");
            AUD_SD <= '1';
        elsif (SW(2) = '1') then
            duty <= ("0100");
            AUD_SD <= '1';
        elsif (SW(1) = '1') then
            duty <= ("0101");
            AUD_SD <= '1';
        elsif (SW(0) = '1') then
            duty <= ("1000");
            AUD_SD <= '1';
        else 
            AUD_SD <= '0';
            duty <= ("0000");
        end if;   
    end process;
    
    pwm_clocks : PWM_clock
    
        generic map(
                    PERIOD => 200_000
                    )
    
        port map(
                    clk => CLK100MHZ,
                    rst => BTNC,
                    pulse => sig_clk);
   
    driver_seg : component display_driver
        port map (
            clk      => CLK100MHZ,
            rst      => BTNC,
            
            data => duty,
            
            dp_vect => "1111",
            dp      => DP,

            seg(6) => CA,
            seg(5) => CB,
            seg(4) => CC,
            seg(3) => CD,
            seg(2) => CE,
            seg(1) => CF,
            seg(0) => CG,

            dig(3 downto 0) => AN(3 downto 0)
        );
    
    AN(7 downto 4) <= "1111";
    
    PWMko : PWM
        port map(
                    clk => sig_clk,
                    rst => BTNC,
                    duty_cycle => duty,
                    pwm_out => AUD_PWM
               );     
    
end architecture behavioral;