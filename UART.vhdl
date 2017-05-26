----------------------------------------------------------------------------------------------------
---file: UART.vhdl--------------------------------------------------------------------------------------
---purpose: This UART.vhdl reads the serial data from RX pin and displays the data on 7-segment display at 9600 baud rate.
---protocol: 9600 buad rate, one start bit, 8 data bits, no parity bit, one stop bit
----------------------------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

	
entity UART is
generic (frame_size: integer:=10);
port ( 
         data_serial: in STD_LOGIC;
         clk : in STD_LOGIC;
		 Reset : in STD_LOGIC;
         CATH : out STD_LOGIC_VECTOR(6 DOWNTO 0);     ------seg selection for 7-segment
         ANO : out STD_LOGIC_VECTOR(7 DOWNTO 0);      ------bit selection for 7-segment
         LED : out STD_LOGIC		 	
	) ;
end UART;


architecture UART_ARCH of UART is

signal clk_uart:std_logic;
signal counter_s: integer range 0 to 10;
signal data_parallel: std_logic_vector(frame_size-2 downto 0);   ----array for temporarily storing the coming 8 serial data 
signal data_out: std_logic_vector ( frame_size-3 downto 0);      


-------clock component:9600 baud rate----------------------
component samplefreq_clk_9600khz is
   port(	
            clk : in std_logic;
	        samplefreq_clk : out std_logic);
end component ;
 
 
---------------7-segment component----------------------------
component readwrite_display is
PORT ( 
             data : IN STD_LOGIC_VECTOR(7 downto 0);
             clk : IN  STD_LOGIC;
             ANO : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
             CATH : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
             Reset : IN STD_LOGIC
            );
end component ;
 
 

begin
comp_clk: component samplefreq_clk_9600khz
			port map (  
			           clk => clk,
					   samplefreq_clk => clk_uart		
					);

comp_7sed : component readwrite_display 
port map ( 
             data => data_out,  
             clk => clk_uart, 
             ANO => ANO,   
             CATH => CATH,
             Reset => Reset
            );

			
			
----------process: read serial data at 9600 baud rate and trasmit the data to FPGA 7-segment--------------------
uart_RX:
process (clk_uart)
begin

if rising_edge(clk_uart) then
	
	if  Reset= '1'then
		data_parallel <= (others => '0');
		counter_s <= 0 ;
	else
	
		if counter_s/=9 then
		   data_parallel(counter_s)<= data_serial ;  ------store 8-bit serial data in an array
		   counter_s <= counter_s +1 ;
		   LED<= '1';
		
		else
		   data_out<= data_parallel(frame_size-2 downto 1); -----NOT INCLUDES START BIT AND STOP BIT 
		   counter_s<= 0;
		   LED<=data_parallel(0);
		end if ;	
	end if;
	
end if ; ---clk

end process;
end UART_ARCH;