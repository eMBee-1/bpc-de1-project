library ieee;
  use ieee.std_logic_1164.all;

----------------------------------------------------------
-- Entity declaration for testbench
----------------------------------------------------------

entity tb_display_driver is
  -- Entity of testbench is always empty
end entity tb_display_driver;

----------------------------------------------------------
-- Architecture body for testbench
----------------------------------------------------------

architecture testbench of tb_display_driver is

  -- Testbench local constants
  constant c_CLK_100MHZ_PERIOD : time := 10 ns;

  -- Testench local signals
  signal sig_clk_100mhz : std_logic;
  signal sig_rst        : std_logic;
  signal sig_data0      : integer range 0 to 8;
  signal sig_data1      : integer range 0 to 8;
  signal sig_data2      : integer range 0 to 8;
  signal sig_data3      : integer range 0 to 8;
  signal sig_dp_vect    : std_logic_vector(3 downto 0);
  signal sig_dp         : std_logic;
  signal sig_seg        : std_logic_vector(6 downto 0);
  signal sig_dig        : std_logic_vector(3 downto 0);

begin

  -- Connecting testbench signals with driver_7seg_4digits
  -- entity (Unit Under Test)
  uut_driver : entity work.display_driver
    port map (
      clk     => sig_clk_100mhz,
      rst     => sig_rst,
      data0   => sig_data0,
      data1   => sig_data1,
      data2   => sig_data2,
      data3   => sig_data3,
      dp_vect => sig_dp_vect,
      dp      => sig_dp,
      seg     => sig_seg,
      dig     => sig_dig
    );

  --------------------------------------------------------
  -- Clock generation process
  --------------------------------------------------------
  p_clk_gen : process is
  begin

    while now < 400 ns loop -- 40 periods of 100MHz clock

      sig_clk_100mhz <= '0';
      wait for c_CLK_100MHZ_PERIOD / 2;
      sig_clk_100mhz <= '1';
      wait for c_CLK_100MHZ_PERIOD / 2;

    end loop;
    wait;

  end process p_clk_gen;

  --------------------------------------------------------
  -- Reset generation process
  --------------------------------------------------------
  p_reset_gen : process is
  begin

    sig_rst <= '0';
    -- WRITE YOUR CODE HERE AND ACTIVATE RESET FOR A WHILE
    wait for 12 ns;

    sig_rst <= '1'; -- Reset activated
    wait for 73 ns;

    sig_rst <= '0'; -- Reset deactivated

    wait;

  end process p_reset_gen;

  --------------------------------------------------------
  -- Data generation process
  --------------------------------------------------------
  p_stimulus : process is
  begin

    report "Stimulus process started";

    -- WRITE YOUR CODE HERE AND TEST INPUT VALUE "3.142"
    -- Display "3.142"
    sig_dp_vect <= "1111"; -- Decimal point
    sig_data3   <= 9;
    sig_data2   <= 1;
    sig_data1   <= 4;
    sig_data0   <= 6;

    wait;

  end process p_stimulus;

end architecture testbench;