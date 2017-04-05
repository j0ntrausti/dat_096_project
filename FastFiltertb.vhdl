LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY FastFiltertb IS
   GENERIC (WIDTH:INTEGER:=12);
   PORT(y:OUT signed(WIDTH-1 DOWNTO 0));
END FastFiltertb;

ARCHITECTURE arch_FastFiltertb OF
                     FastFiltertb IS

   COMPONENT FastFilter IS
      GENERIC(WIDTH:INTEGER:=12;
              N:INTEGER:=4);
      PORT(reset:STD_LOGIC;
           clk:STD_LOGIC;
           clk250k:STD_LOGIC;
           clk6M:STD_LOGIC;
           x:IN signed(WIDTH-1 DOWNTO 0);
           y:OUT signed(WIDTH-1 DOWNTO 0);
           finished:OUT STD_LOGIC);
   END COMPONENT FastFilter;

   SIGNAL x_tb_signal:signed(WIDTH-1 DOWNTO 0);
   SIGNAL y_tb_signal:signed(WIDTH-1 DOWNTO 0);
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



   x_tb_signal<="000000000000",
                "010000000000" AFTER 4250 ns, -- 0,5=64
		"001000000000" AFTER 4420 ns, -- -0,25=-32=224
                "000100000000" AFTER 4590 ns, -- -0,25=-32=224
                "000010000000" AFTER 4760 ns, -- 0,375=48
		"000001000000" AFTER 4930 ns; -- 0,5=64
--                "101000000000" AFTER 5100 ns, -- -0,75=-96=160
--                "000000000000" AFTER 5270 ns;
--

   clk_proc:
   PROCESS
   BEGIN
      WAIT FOR 10 ns;
      clk<=NOT(clk);
   END PROCESS clk_proc;

   clk_proc2:
   PROCESS
   BEGIN
      WAIT FOR 170 ns;
      clk6M<=NOT(clk6M);
	WAIT FOR 10 ns;
	clk6M<=NOT(clk6M);
   END PROCESS clk_proc2;

   clk_proc22:
   PROCESS
   BEGIN
      WAIT FOR 4130 ns;
      clk250k<=NOT(clk250k);
      wait for 10 ns;
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