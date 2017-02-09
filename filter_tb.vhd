
----------------------------------
-- testbench type 3 for         --
-- multiplier/accumulator (MAC) --
-- for generic vector           --
----------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY filter_tb IS
   GENERIC (WIDTH:INTEGER:=12);
   PORT(y:OUT STD_LOGIC_VECTOR(2*WIDTH-1 DOWNTO 0);
   ready:OUT STD_LOGIC);
END filter_tb;

ARCHITECTURE arch_filter_tb OF
                     filter_tb IS

   COMPONENT filter IS
      GENERIC(WIDTH:INTEGER:=12;
              N:INTEGER:=4);
      PORT(reset:STD_LOGIC;
           start:STD_LOGIC;
           clk:STD_LOGIC;
           x:IN STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0);
           y:OUT STD_LOGIC_VECTOR(2*WIDTH-1 DOWNTO 0);
           finished:OUT STD_LOGIC);
   END COMPONENT filter;

   SIGNAL x_tb_signal:STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0);
   SIGNAL y_tb_signal:STD_LOGIC_VECTOR(2*WIDTH-1 DOWNTO 0);
   SIGNAL clk_tb_signal:STD_LOGIC:='0';
   SIGNAL reset_tb_signal:STD_LOGIC;
   SIGNAL start_tb_signal:STD_LOGIC;
   SIGNAL finished_tb_signal:STD_LOGIC;
BEGIN
   filter_tb_comp:
   COMPONENT filter
         PORT MAP(
                  reset=>reset_tb_signal,
                  start=>start_tb_signal,
		  clk=>clk_tb_signal,
                  x=>x_tb_signal,
                  y=>y_tb_signal,
                  finished=>finished_tb_signal);
   ready<=finished_tb_signal;

   reset_tb_signal<='0',
                    '1' AFTER 225 ns,
                    '0' AFTER 425 ns;

   start_tb_signal<='0',
                    '1' AFTER 825 ns,
                    '0' AFTER 1025 ns,
                    '1' AFTER 1725 ns,
                    '0' AFTER 1925 ns,
                    '1' AFTER 2625 ns,
                    '0' AFTER 2825 ns,
                    '1' AFTER 3525 ns,
                    '0' AFTER 3725 ns;

   x_tb_signal<=
                "000001000000" AFTER 625 ns, -- 0,5=64
                "111111100000" AFTER 1525 ns, -- -0,25=-32=224
                "000000110000" AFTER 2425 ns, -- 0,375=48
                "111110100000" AFTER 3325 ns; -- -0,75=-96=160

   clk_proc:
   PROCESS
   BEGIN
      WAIT FOR 50 ns;
      clk_tb_signal<=NOT(clk_tb_signal);
   END PROCESS clk_proc;

   test_proc:
   PROCESS
   BEGIN
      WAIT FOR 1400 ns; -- 1400 ns
      ASSERT (y_tb_signal="111111111110110000000000") 
      REPORT "incorrect result"
      SEVERITY ERROR;
      WAIT FOR 900 ns; -- 2300 ns
      ASSERT (y_tb_signal="000000000001100010000000") 
      REPORT "incorrect result"
      SEVERITY ERROR;
      WAIT FOR 900 ns; -- 3200 ns
      ASSERT (y_tb_signal="111111111111100001000000")
      REPORT "incorrect result"
      SEVERITY ERROR;
      WAIT FOR 900 ns; -- 4100 ns
      ASSERT (y_tb_signal="000000000000110110100000") 
      REPORT "incorrect result"
      SEVERITY ERROR;
   END PROCESS test_proc;
         
END arch_filter_tb;