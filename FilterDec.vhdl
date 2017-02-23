--lab 5 sample system 
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY FilterDec IS
    PORT(
	clk,reset_filter,dout	:in std_logic;

	cs_adc, cs_dac,clk_adc,clk_dac, din, sdi,ldac	:out std_logic;
	outs 	:out signed(11 downto 0)
	);
END FilterDec;

ARCHITECTURE arch OF FilterDec IS
signal start_adc,start_dac,start_filter,end_dac,end_adc,end_filter,clk_enable_samplerate_filter,clk_enable_samplerate_adc,clk_enable_samplerate_dac	:std_logic;
signal dac_input, adc_output, FIR_input : STD_LOGIC_VECTOR(11 downto 0);
signal FIR_output	:std_logic_vector(23 downto 0);
signal done : std_logic;

component adc
  port (
	start, clk	:in std_logic; -- we probably need a clock input
	dout_internal	:out std_logic_vector(11 downto 0);	
	dout	:in std_logic;
	din	:out std_logic; --the din for the controll bits
	clk_adc	:out std_logic; -- this is a clock signal for the adc  this clock should be slower than clk.
	cs	:out std_logic --cs=0 starts a new conversation and cs=1 shuts it off
	);
end component;

--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

component linearphaseFIRbl
 	generic(Width	:integer;
		N :integer);
	port(	reset:STD_LOGIC;
           start:STD_LOGIC;
           clk:STD_LOGIC;
           x:IN signed(WIDTH-1 DOWNTO 0);
           y:OUT signed(2*WIDTH-1 DOWNTO 0);
           finished:OUT STD_LOGIC);
end component;


component linearphaseFIRch
 	generic(Width	:integer;
		N :integer);
	port(	reset:STD_LOGIC;
           start:STD_LOGIC;
           clk:STD_LOGIC;
           x:IN signed(WIDTH-1 DOWNTO 0);
           y:OUT signed(2*WIDTH-1 DOWNTO 0);
           finished:OUT STD_LOGIC);
end component;

end component;
component clk_enable_sampled
  generic (N:integer); 
  port (clk,reset	:in std_logic;
		end_clk,clk_enable	:out std_logic);
end component;

clkEnable_comp_block: clk_enable_sampled generic map(17) port map (clk,'0',end_filter,clk_enable_samplerate_filter); --5.77kHz   100MHZ / 120 kHZ
clkEnable_comp_channel: clk_enable_sampled generic map(400) port map (clk,'0',end_filter,clk_enable_samplerate_filter); --250kHz   100MHZ / 250 kHZ




--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


component filter
  	generic(Width	:integer;
		N :integer);
	port(	reset:STD_LOGIC;
           	start:STD_LOGIC;
           	clk:STD_LOGIC;
           	x:IN STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0);
           	y:OUT STD_LOGIC_VECTOR(2*WIDTH-1 DOWNTO 0);
          	finished:OUT STD_LOGIC);
end component;

begin
clkEnable_comp_adc: clk_enable_sampled generic map(3*833) port map (clk,'0',end_adc,clk_enable_samplerate_adc); --40kHz
clkEnable_comp_dac: clk_enable_sampled generic map(4*833) port map (clk,'0',end_dac,clk_enable_samplerate_dac); --30kHz
clkEnable_comp_filter: clk_enable_sampled generic map(833) port map (clk,'0',end_filter,clk_enable_samplerate_filter); --120kHz   100MHZ / 120 kHZ
adc_component: adc  port map (start_adc,clk,adc_output,dout,din,clk_adc,cs_adc);
dac_component: dac  port map (dac_Input,start_dac,clk,cs_dac,sdi,clk_dac,ldac);
fir_component: filter generic map (12,25) port map (reset_filter,start_filter,clk,FIR_input,FIR_output, done);


leds<=adc_output;
process(clk)
begin
if(rising_edge(clk)) then 
--ADC
	if(clk_enable_samplerate_adc = '1') then
		start_adc <= '1';
		FIR_input<=adc_output; --to send the last stored values			
	elsif(end_adc='1') then		
		start_adc<='0';
	end if;
--FILTER
	if(clk_enable_samplerate_filter = '1') then
		start_filter <= '1';
		dac_input<=FIR_output(23 downto 12); --to send the last stored values				
	elsif(end_filter='1') then		
		start_filter<='0';
	end if;
--DAC
	if(clk_enable_samplerate_dac = '1') then
		start_dac <= '1';
	elsif(end_dac='1') then
		start_dac<='0';
	end if;
end if;
end process;
END arch;