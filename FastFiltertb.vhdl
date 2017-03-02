LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY FastFiltertb IS
   GENERIC (WIDTH:INTEGER:=8);
   PORT(y:OUT signed(2*WIDTH-1 DOWNTO 0));
END FastFiltertb;

ARCHITECTURE arch_FastFiltertb OF
                     FastFiltertb IS

   COMPONENT FastFilter IS
      GENERIC(WIDTH:INTEGER:=8;
              N:INTEGER:=4);
      PORT(reset:STD_LOGIC;
           clk:STD_LOGIC;
           clk250k:STD_LOGIC;
           clk6M:STD_LOGIC;
           x:IN signed(WIDTH-1 DOWNTO 0);
           y:OUT signed(2*WIDTH-1 DOWNTO 0);
           finished:OUT STD_LOGIC);
   END COMPONENT FastFilter;

   SIGNAL x_tb_signal:signed(WIDTH-1 DOWNTO 0);
   SIGNAL y_tb_signal:signed(2*WIDTH-1 DOWNTO 0);
   SIGNAL clk:STD_LOGIC:='0';
   SIGNAL clk250k:STD_LOGIC:='0';
   SIGNAL clk6M:STD_LOGIC:='0';
   SIGNAL reset_tb_signal:STD_LOGIC;
   SIGNAL finished_tb_signal:STD_LOGIC;
BEGIN
   FastFiltertb_comp:
   COMPONENT FastFilter
         PORT MAP(
                  reset=>reset_tb_signal,
		  clk=>clk,
		  clk250k=>clk250k,
          	  clk6M=>clk6M,
                  x=>x_tb_signal,
                  y=>y_tb_signal,
                  finished=>finished_tb_signal
);

   reset_tb_signal<='0',
                    '1' AFTER 225 ns,
                    '0' AFTER 425 ns;



   x_tb_signal<=
                "01000000" AFTER 725 ns, -- 0,5=64
		"11100000" AFTER 1675 ns, -- -0,25=-32=224
                "10100000" AFTER 2500 ns, -- -0,25=-32=224
                "00110000" AFTER 3350 ns, -- 0,375=48
		"01000000" AFTER 4200 ns, -- 0,5=64
                "10100000" AFTER 5050 ns; -- -0,75=-96=160


   clk_proc:
   PROCESS
   BEGIN
      WAIT FOR 50 ns;
      clk<=NOT(clk);
   END PROCESS clk_proc;
   clk_proc2:
   PROCESS
   BEGIN
      WAIT FOR 850 ns;
      clk6M<=NOT(clk6M);
	WAIT FOR 50 ns;
	clk6M<=NOT(clk6M);
   END PROCESS clk_proc2;
   clk_proc22:
   PROCESS
   BEGIN
      WAIT FOR 5450 ns;
      clk250k<=NOT(clk250k);
      wait for 50 ns;
	clk250k<=NOT(clk250k);
   END PROCESS clk_proc22;

--clk_proc1:
--   PROCESS
--   BEGIN
--      WAIT FOR 2*25 ns;
--      clk_tb_signal2<=NOT(clk_tb_signal2);
--   END PROCESS clk_proc1;
--
--clk_proc11:
--   PROCESS
--   BEGIN
--      WAIT FOR 3*25 ns;
--      clk_tb_signal3<=NOT(clk_tb_signal3);
--   END PROCESS clk_proc11;



         
END arch_FastFiltertb;