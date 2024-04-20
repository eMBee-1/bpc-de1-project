library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity top is
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
        BTNU      : in    std_logic; 
        BTND      : in    std_logic;
        AUD_PWM   : out   std_logic;
        AUD_SD    : out   std_logic                                           
    );
end entity top;

architecture behavioral of top is
    
    signal sig_clk : std_logic;
    signal data0   : std_logic;
    signal data1   : std_logic;
    signal data2   : std_logic;
    signal data3   : std_logic;
    signal period : integer;
    
    signal duty : std_logic_vector(3 downto 0);
    
    
       component driver is
        port (
            clk     : in    std_logic;
            rst     : in    std_logic;
            data0   : in    std_logic;
            data1   : in    std_logic;
            data2   : in    std_logic;
            data3   : in    std_logic;
            dp_vect : in    std_logic_vector(3 downto 0);
            dp      : out   std_logic;
            seg     : out   std_logic_vector(6 downto 0);
            dig     : out   std_logic_vector(3 downto 0)
        );
    end component;
    
    component debounce is
            Port ( 
                clk      : in STD_LOGIC;
                rst      : in STD_LOGIC;
                en       : in STD_LOGIC;
                bouncey  : in STD_LOGIC;
                clean    : out STD_LOGIC);
    end component debounce;
    
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
            data0 <= '1';
            data1 <= '0';
            data2 <= '0';
            data3 <= '0';
        elsif (SW(5) = '1') then
            duty <= ("1010");
            AUD_SD <= '1';
            data0 <= '0';
            data1 <= '1';
            data2 <= '0';
            data3 <= '1';
        elsif (SW(4) = '1') then
            duty <= ("0010");
            AUD_SD <= '1';
            data0 <= '0';
            data1 <= '1';
            data2 <= '0';
            data3 <= '0';
        elsif (SW(3) = '1') then
            duty <= ("1001");
            AUD_SD <= '1';
            data0 <= '1';
            data1 <= '0';
            data2 <= '0';
            data3 <= '1';
        elsif (SW(2) = '1') then
            duty <= ("0100");
            AUD_SD <= '1';
            data0 <= '1';
            data1 <= '1';
            data2 <= '0';
            data3 <= '1';
        elsif (SW(1) = '1') then
            duty <= ("0101");
            AUD_SD <= '1';
            data0 <= '1';
            data1 <= '0';
            data2 <= '1';
            data3 <= '0';
        elsif (SW(0) = '1') then
            duty <= ("1000");
            AUD_SD <= '1';
            data0 <= '0';
            data1 <= '0';
            data2 <= '0';
            data3 <= '1';
        else 
            AUD_SD <= '0';
            data0 <= '0';
            data1 <= '0';
            data2 <= '0';
            data3 <= '0';
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
   
    driver_seg : component driver
        port map (
            clk      => CLK100MHZ,
            rst      => BTNC,
            
            data0 => data0,
            data1 => data1,
            data2 => data2,
            data3 => data3,
            
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