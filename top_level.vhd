library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
library work;
use work.Read_package.all;

entity top_level is
GENERIC (WIDTH:INTEGER:=12);
Port ( clk_100MHz 	: in STD_LOGIC;
       clk_uber     : in STD_LOGIC;
	   reset 		: in STD_LOGIC:= '0';
       Switches 	: in STD_LOGIC_VECTOR(14 downto 0):=(others => '0');
       LED			: out STD_LOGIC_VECTOR(14 downto 0);
       DUMMY_0      : out STD_LOGIC_VECTOR(WIDTH-1 downto 0));
--       DUMMY_1      : out STD_LOGIC_VECTOR(WIDTH-1 downto 0);
--       DUMMY_2      : out STD_LOGIC_VECTOR(WIDTH-1 downto 0);
--       DUMMY_3      : out STD_LOGIC_VECTOR(WIDTH-1 downto 0);
--       DUMMY_4      : out STD_LOGIC_VECTOR(WIDTH-1 downto 0);
--       DUMMY_5      : out STD_LOGIC_VECTOR(WIDTH-1 downto 0);
--       DUMMY_6      : out STD_LOGIC_VECTOR(WIDTH-1 downto 0);
--       DUMMY_7      : out STD_LOGIC_VECTOR(WIDTH-1 downto 0));
end top_level;

architecture Behavioral of top_level is
--COMPONENT DECLARATIONS
--Clock enable
component clk_enable_generic
GENERIC (N:integer); --how fast should the clock be.
Port  (	clk 		: in STD_LOGIC;
		    reset		: in STD_LOGIC;
		    end_clk		: out STD_LOGIC;
		    clk_enable	: out STD_LOGIC
		    );
end component;

--ADC
component ADC    
GENERIC (WIDTH:INTEGER:=WIDTH);
Port ( clk_6MHz : in STD_LOGIC;
       reset 	: in STD_LOGIC;
       adc_out 	: out STD_LOGIC_VECTOR(WIDTH-1 downto 0)
       );
end component;

--First mixer down step
component Mixer_down_1    
GENERIC (WIDTH:INTEGER:=WIDTH);
Port ( clk_6MHz : in STD_LOGIC;
       in_r : in signed(WIDTH-1 downto 0);
       in_i : in signed(WIDTH-1 downto 0);
       out_r_0 : out signed(WIDTH-1 downto 0);
       out_i_0 : out signed(WIDTH-1 downto 0);
       out_r_1 : out signed(WIDTH-1 downto 0);
       out_i_1 : out signed(WIDTH-1 downto 0);
       out_r_2 : out signed(WIDTH-1 downto 0);
       out_i_2 : out signed(WIDTH-1 downto 0);
       out_r_3 : out signed(WIDTH-1 downto 0);
       out_i_3 : out signed(WIDTH-1 downto 0)
       );
end component;

--Second mixer down step
component Mixer_down_2   
GENERIC (WIDTH:INTEGER:=WIDTH);
Port ( clk_250KHz : in STD_LOGIC;
       in_r : in signed(WIDTH-1 downto 0);
       in_i : in signed(WIDTH-1 downto 0);
       out_r_0 : out signed(WIDTH-1 downto 0);
       out_i_0 : out signed(WIDTH-1 downto 0);
       out_r_1 : out signed(WIDTH-1 downto 0);
       out_i_1 : out signed(WIDTH-1 downto 0);
       out_r_2 : out signed(WIDTH-1 downto 0);
       out_i_2 : out signed(WIDTH-1 downto 0);
       out_r_3 : out signed(WIDTH-1 downto 0);
       out_i_3 : out signed(WIDTH-1 downto 0);
       out_r_4 : out signed(WIDTH-1 downto 0);
       out_i_4 : out signed(WIDTH-1 downto 0);
       out_r_5 : out signed(WIDTH-1 downto 0);
       out_i_5 : out signed(WIDTH-1 downto 0);
       out_r_6 : out signed(WIDTH-1 downto 0);
       out_i_6 : out signed(WIDTH-1 downto 0);
       out_r_7 : out signed(WIDTH-1 downto 0);
       out_i_7 : out signed(WIDTH-1 downto 0)
       );
end component;

--First mixer up step
component Mixer_up_1   
GENERIC (WIDTH:INTEGER:=WIDTH);
Port ( clk_6MHz : in STD_LOGIC;
        in_r_0 : in signed(WIDTH-1 downto 0);
        in_i_0 : in signed(WIDTH-1 downto 0);
        in_r_1 : in signed(WIDTH-1 downto 0);
        in_i_1 : in signed(WIDTH-1 downto 0);
        in_r_2 : in signed(WIDTH-1 downto 0);
        in_i_2 : in signed(WIDTH-1 downto 0);
        in_r_3 : in signed(WIDTH-1 downto 0);
        in_i_3 : in signed(WIDTH-1 downto 0);
        in_r_4 : in signed(WIDTH-1 downto 0);
        in_i_4 : in signed(WIDTH-1 downto 0);
        in_r_5 : in signed(WIDTH-1 downto 0);
        in_i_5 : in signed(WIDTH-1 downto 0);
        in_r_6 : in signed(WIDTH-1 downto 0);
        in_i_6 : in signed(WIDTH-1 downto 0);
        in_r_7 : in signed(WIDTH-1 downto 0);
        in_i_7 : in signed(WIDTH-1 downto 0);
        out_r : out signed(WIDTH-1 downto 0);
        out_i : out signed(WIDTH-1 downto 0)
       );
end component;

--Second mixer up step
component Mixer_up_2    
GENERIC (WIDTH:INTEGER:=WIDTH);
Port ( clk_6MHz : in STD_LOGIC;
        in_r_0 : in signed(WIDTH-1 downto 0);
        in_i_0 : in signed(WIDTH-1 downto 0);
        in_r_1 : in signed(WIDTH-1 downto 0);
        in_i_1 : in signed(WIDTH-1 downto 0);
        in_r_2 : in signed(WIDTH-1 downto 0);
        in_i_2 : in signed(WIDTH-1 downto 0);
        in_r_3 : in signed(WIDTH-1 downto 0);
        in_i_3 : in signed(WIDTH-1 downto 0);
        out_r : out signed(WIDTH-1 downto 0);
        out_i : out signed(WIDTH-1 downto 0)
       );
end component;

--DEC_1_500
component DEC_1_500
GENERIC (WIDTH:INTEGER:=WIDTH);
Port ( clk_100MHz : in STD_LOGIC;
       clk_4MHz : in STD_LOGIC;
       clk_500KHz : in STD_LOGIC;
       reset : in STD_LOGIC;
       in_r : in signed(WIDTH-1 downto 0);
       in_i : in signed(WIDTH-1 downto 0);
       out_r : out signed(WIDTH-1 downto 0);
       out_i : out signed(WIDTH-1 downto 0)
       );
end component;

--DEC_1_250
component DEC_1_250
GENERIC (WIDTH:INTEGER:=WIDTH);
Port ( clk_100MHz : in STD_LOGIC;
       clk_4MHz : in STD_LOGIC;
       clk_250KHz : in STD_LOGIC;
       reset : in STD_LOGIC;
       in_r : in signed(WIDTH-1 downto 0);
       in_i : in signed(WIDTH-1 downto 0);
       out_r : out signed(WIDTH-1 downto 0);
       out_i : out signed(WIDTH-1 downto 0)
       );
end component;
       
----DEC_2 OLD!
--component DEC_2
--GENERIC (WIDTH:INTEGER:=WIDTH);
--Port ( clk_100MHz : in STD_LOGIC;
--       clk_250KHz : in STD_LOGIC;
--       clk_31KHz : in STD_LOGIC;
--       reset : in STD_LOGIC;
--       in_r : in signed(WIDTH-1 downto 0);
--       in_i : in signed(WIDTH-1 downto 0);
--       out_r : out signed(WIDTH-1 downto 0);
--       out_i : out signed(WIDTH-1 downto 0)
--       );
--end component;

--DEC_2
component DEC_2
GENERIC (WIDTH:INTEGER:=WIDTH);
Port ( clk_100MHz : in STD_LOGIC;
	   clk_250KHz : in STD_LOGIC;
       clk_31KHz : in STD_LOGIC;
       reset : in STD_LOGIC;
       in_channels : in Channels;
       out_channels : out Channels
       );
end component;

        

--SIGNAL DECLARATIONS
--Clocks
--signal clk_uber : std_logic :='0';
signal clk_4MHz : std_logic :='0';
signal clk_500KHz : std_logic :='0';
signal clk_250KHz : std_logic :='0';
signal clk_31KHz : std_logic :='0';

---VVVV SIGNAL PATH VVVV----
--ADC component
signal adc_out : STD_LOGIC_VECTOR(WIDTH-1 downto 0);
--mixer_down_1
signal blocks_undec: Blocks; 		--2D array
--DEC_1
signal blocks_dec: Blocks; 			--2D array
--Mixer_down_2
signal signals_undec: Signals; 		--3D array
--DEC_2
signal signals_dec: Signals; 		--3D array
--Redirect
signal signals_redirected: Signals; --3D array
--Mixer_up_1
signal blocks_unpol: Blocks; 		--2D array
--IPOL_1
signal blocks_pol: Blocks; 			--2D array
--Mixer_up_2
signal dac_unpol_r : signed(WIDTH-1 downto 0);
signal dac_unpol_i : signed(WIDTH-1 downto 0);
--IPOL_2
signal dac_pol_r : signed(WIDTH-1 downto 0);
signal dac_pol_i : signed(WIDTH-1 downto 0);
--DAC component

begin

--Clock Enables
--4MHz
Clk_en_4MHz: clk_enable_generic 
GENERIC MAP(N => 26)
PORT MAP (
    clk => clk_100MHz,
    reset => reset,
    clk_enable => clk_4MHz);

--500KHz
Clk_en_500KHz: clk_enable_generic 
    GENERIC MAP(N => 407) 
    PORT MAP (
        clk => clk_100MHz,
        reset => reset,
        clk_enable => clk_250KHz);

--250KHz
Clk_en_250KHz: clk_enable_generic 
GENERIC MAP(N => 407) 
PORT MAP (
    clk => clk_100MHz,
    reset => reset,
    clk_enable => clk_250KHz);
--31.5k     
Clk_en_31KHz: clk_enable_generic 
GENERIC MAP(N => 3263)
PORT MAP (
    clk => clk_100MHz,
    reset => reset,
    clk_enable => clk_31KHz);
         
--ADC
ADC_cmp: ADC    
--GENERIC MAP(WIDTH => WIDTH)
PORT MAP( 
		clk_4MHz => clk_4MHz,
		reset => reset,
		adc_out => adc_out 
    );

--Mixer_down_1
	Mixer_dnw_1: Mixer_down_1    
	GENERIC MAP(WIDTH => WIDTH)
	PORT MAP( 
		clk_4MHz => clk_4MHz,
		in_r => signed(adc_out),
		in_i => (others=> '0'),
		out_r_0 => blocks_undec(0),
		out_i_0 => blocks_undec(1),
		out_r_1 => blocks_undec(2),
		out_i_1 => blocks_undec(3),
		out_r_2 => blocks_undec(4),
		out_i_2 => blocks_undec(5),
		out_r_3 => blocks_undec(6),
		out_i_3 => blocks_undec(7)
		);

--DEC_1_500_block_0
	DEC_1_500_block_0: DEC_1_500
	GENERIC MAP(WIDTH => WIDTH)
	PORT MAP( 
	    clk_100MHz => clk_100MHz,
	    clk_4MHz => clk_4MHz,
		clk_500KHz => clk_500KHz,
		reset => reset,
		in_r => blocks_undec(0),
		in_i => blocks_undec(1),
		out_r => blocks_dec(0),
		out_i => blocks_dec(1)
		);

--DEC_1_250_block_0
            DEC_1_250_block_0: DEC_1_250
            GENERIC MAP(WIDTH => WIDTH)
            PORT MAP( 
                clk_100MHz => clk_100MHz,
                clk_4MHz => clk_4MHz,
                clk_250KHz => clk_250KHz,
                reset => reset,
                in_r => blocks_undec(0),
                in_i => blocks_undec(1),
                out_r => blocks_dec(0),
                out_i => blocks_dec(1)
                );
	Mixer_dnw_2_block_0: Mixer_down_2    
	GENERIC MAP(WIDTH => WIDTH)
	PORT MAP( 
		clk_250KHz => clk_250KHz,
		in_r => blocks_dec(0),
		in_i => blocks_dec(1),
		out_r_0 => signals_undec(0)(0),
		out_i_0 => signals_undec(0)(1),
		out_r_1 => signals_undec(0)(2),
		out_i_1 => signals_undec(0)(3),
		out_r_2 => signals_undec(0)(4),
		out_i_2 => signals_undec(0)(5),
		out_r_3 => signals_undec(0)(6),
		out_i_3 => signals_undec(0)(7),
		out_r_4 => signals_undec(0)(8),
		out_i_4 => signals_undec(0)(9),
		out_r_5 => signals_undec(0)(10),
		out_i_5 => signals_undec(0)(11),
		out_r_6 => signals_undec(0)(12),
		out_i_6 => signals_undec(0)(13),
		out_r_7 => signals_undec(0)(14),
		out_i_7 => signals_undec(0)(15)
		);

--Channel Filters:
--DEC_2_Channel:
--for i in 0 to 7 generate
----DEC_2_channel_0_block_1
--	Dec: DEC_2
--	GENERIC MAP(WIDTH => WIDTH)
--	PORT MAP( 
--		clk_100MHz => clk_100MHz,
--        clk_250KHz => clk_250KHz,
--        clk_31KHz => clk_31KHz,
--		reset => reset,
--		in_r => signals_undec(0)(2*i),
--		in_i => signals_undec(0)(2*i+1),
--		out_r => signals_dec(0)(2*i),
--		out_i => signals_dec(0)(2*i+1)
--		);
--end generate DEC_2_Channel;

--DEC_1_block_0
	DEC_2_block_0: DEC_2
	GENERIC MAP(WIDTH => WIDTH)
	PORT MAP( 
	    clk_100MHz => clk_100MHz,
	    clk_250KHz => clk_250KHz,
        clk_31KHz => clk_31KHz,
		reset => reset,
		in_channels => signals_undec(0),
		out_channels => signals_dec(0)
		);


--Redirect (doesn't exist yet)
signals_redirected <= signals_dec;
--signals_redirected(0)(0) <= signals_dec(0)(0)
--signals_redirected(0)(1) <= signals_dec(0)(1)
--signals_redirected(0)(2) <= signals_dec(0)(2)
--signals_redirected(0)(3) <= signals_dec(0)(3)
--signals_redirected(0)(4) <= signals_dec(0)(4)
--signals_redirected(0)(5) <= signals_dec(0)(5)
--signals_redirected(0)(6) <= signals_dec(0)(6)
--signals_redirected(0)(7) <= signals_dec(0)(7)
--signals_redirected(0)(8) <= signals_dec(0)(8)
--signals_redirected(0)(9) <= signals_dec(0)(9)
--signals_redirected(0)(10) <= signals_dec(0)(10)
--signals_redirected(0)(11) <= signals_dec(0)(11)
--signals_redirected(0)(12) <= signals_dec(0)(12)
--signals_redirected(0)(13) <= signals_dec(0)(13)
--signals_redirected(0)(14) <= signals_dec(0)(14)
--signals_redirected(0)(15) <= signals_dec(0)(15)
 
--first mixer up block_0       
Mixer_up_1_block_0: Mixer_up_1    
	GENERIC MAP(WIDTH => WIDTH)
	PORT MAP( 
		clk_6MHz => clk_6MHz,
		in_r_0 => signals_redirected(0)(0),
		in_i_0 => signals_redirected(0)(1),
		in_r_1 => signals_redirected(0)(2),
		in_i_1 => signals_redirected(0)(3),
		in_r_2 => signals_redirected(0)(4),
		in_i_2 => signals_redirected(0)(5),
		in_r_3 => signals_redirected(0)(6),
		in_i_3 => signals_redirected(0)(7),
		in_r_4 => signals_redirected(0)(8),
		in_i_4 => signals_redirected(0)(9),
		in_r_5 => signals_redirected(0)(10),
		in_i_5 => signals_redirected(0)(11),
		in_r_6 => signals_redirected(0)(12),
		in_i_6 => signals_redirected(0)(13),
		in_r_7 => signals_redirected(0)(14),
		in_i_7 => signals_redirected(0)(15),
		out_r => blocks_unpol(0),
		out_i => blocks_unpol(1)
		);
		
--first IPOL stage (doesn't exist yet)

blocks_pol(0) <= blocks_unpol(0);
blocks_pol(1) <= blocks_unpol(1);
blocks_pol(2) <= blocks_unpol(2);
blocks_pol(3) <= blocks_unpol(3);
blocks_pol(4) <= blocks_unpol(4);
blocks_pol(5) <= blocks_unpol(5);
blocks_pol(6) <= blocks_unpol(6);
blocks_pol(7) <= blocks_unpol(7);

--Second mixer up block
Mixer_up_2_block_0: Mixer_up_2    
	GENERIC MAP(WIDTH => WIDTH)
	PORT MAP( 
		clk_6MHz => clk_6MHz,
		in_r_0 => blocks_pol(0),
		in_i_0 => blocks_pol(1),
		in_r_1 => blocks_pol(2),
		in_i_1 => blocks_pol(3),
		in_r_2 => blocks_pol(4),
		in_i_2 => blocks_pol(5),
		in_r_3 => blocks_pol(6),
		in_i_3 => blocks_pol(7),
		out_r => dac_unpol_r,
		out_i => dac_unpol_i
		);
		
--second IPOL stage (doesn't exist yet)
 dac_pol_r <= dac_unpol_r;
 dac_pol_i <= dac_unpol_i;
 	
DUMMY_0 <= STD_LOGIC_VECTOR(dac_pol_r);
--DUMMY_1 <= STD_LOGIC_VECTOR(signals_dec(0)(2));
--DUMMY_2 <= STD_LOGIC_VECTOR(signals_dec(0)(4));
--DUMMY_3 <= STD_LOGIC_VECTOR(signals_dec(0)(6));
--DUMMY_4 <= STD_LOGIC_VECTOR(signals_dec(0)(8));
--DUMMY_5 <= STD_LOGIC_VECTOR(signals_dec(0)(10));
--DUMMY_6 <= STD_LOGIC_VECTOR(signals_dec(0)(12));
--DUMMY_7 <= STD_LOGIC_VECTOR(signals_dec(0)(14));

end Behavioral;