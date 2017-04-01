----------------------------------------
-- testbench type 3 for               --
-- successive addition multiplier_tb1 --
-- for generic vector                 --
----------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY BitMulti_tb IS
   GENERIC (WIDTH:INTEGER:=12);
END BitMulti_tb ;

ARCHITECTURE arch_BitMulti_tb  OF
                      BitMulti_tb  IS

   COMPONENT BitMulti IS
      GENERIC(WIDTH:INTEGER:=WIDTH);
      PORT(reset:IN STD_LOGIC;
             clk:IN STD_LOGIC;
	     start:IN STD_LOGIC;
	     A:IN signed(WIDTH-1 downto 0); -- X-input
	     B:IN signed(WIDTH-1 downto 0); -- coff modified vector
	     y:OUT signed(2*WIDTH-1 downto 0); -- multiplied output
             finished:OUT STD_LOGIC);
   END COMPONENT BitMulti;

   SIGNAL A_tb:signed(WIDTH-1 DOWNTO 0);
   SIGNAL B_tb:signed(WIDTH-1 DOWNTO 0);
   SIGNAL y_tb:signed(2*WIDTH-1 DOWNTO 0);
   SIGNAL start_tb:STD_LOGIC;
   SIGNAL clk_tb:STD_LOGIC:='0';
   SIGNAL reset_tb:STD_LOGIC;
   SIGNAL finished_tb:STD_LOGIC;
BEGIN
   BitMulti_comp:
   COMPONENT BitMulti
         GENERIC MAP(WIDTH=>WIDTH)
         PORT MAP(reset=>reset_tb,
 	            clk=>clk_tb,
		     start=>start_tb,
		     A=>A_tb, -- X-input
		     B=>B_tb, -- coff modified vector
		     y=>y_tb, -- multiplied output
	             finished=>finished_tb );


   A_tb<=	"000000000000",  -- 0          
                "010000000000" AFTER 350 ns, -- 120
		"010000000000" AFTER 450 ns; -- 120
   B_tb<=	"000000000000",  -- 0
                "011100000000" AFTER 350 ns, -- 12,
		"001000000000" AFTER 450 ns; -- 123
   start_tb<='0',
                    '1' AFTER 350 ns,
                    '0' AFTER 2950 ns;
    reset_tb<='0',
                     '1' AFTER 50 ns,
                     '0' AFTER 150 ns;

   clk_proc:
   PROCESS
   BEGIN
      WAIT FOR 50 ns;
      clk_tb<=NOT(clk_tb);
   END PROCESS clk_proc;

   test_proc:
   PROCESS
   BEGIN
-- test reset
      WAIT FOR 1700 ns;
   END PROCESS test_proc;
END arch_BitMulti_tb ;
