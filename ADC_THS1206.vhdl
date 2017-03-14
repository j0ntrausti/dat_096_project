LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all ;
use ieee.std_logic_arith.all;

entity ADC_THS1206 is
GENERIC (WIDTH:INTEGER:=12);
port(
CS0_activelow: out std_logic;
CS1_activehigh: out std_logic;
clk_6MHz: in std_logic;
dig_out: out std_logic_vector (WIDTH-1 downto 0);
reset: in std_logic;
data_av: in std_logic;
rd_activelow: out std_logic ; 
wr_activelow: out std_logic ; 
D11_D0 : inout std_logic_vector (WIDTH-1 downto 0) 
);
end ADC_THS1206  ;

architecture ADC_THS1206_ARCH of ADC_THS1206 is

signal digital_val:  std_logic_vector (WIDTH-1 downto 0);

signal count: integer:=0;


begin 

dig_out<= digital_val;
	
adc:
process(clk_6MHz)


begin


   if rising_edge(clk_6MHz) then
      if reset = '1' then
             CS0_activelow	<= '0' ;
		     CS1_activehigh	<= '1' ;
		     rd_activelow	<= '1';
		     wr_activelow	<= '0'; 
             digital_val <= (others=>'0');
             count <=0 ;
      else

	        case count is
    
	----------------------------------------------------------------------------
	---------------------------------INITIALIZATION-----------------------------			
	----------------------------------------------------------------------------
                 WHEN 0 =>
	
		              CS0_activelow	<= '0' ;
		              CS1_activehigh	<= '1' ;
		              rd_activelow	<= '1';
		              wr_activelow	<= '0';   --- enable WR ---
              
		              D11_D0 <= "010000000001";  ----set reset  in CR1 i.e write 401 to CR1
                      count<=count+1;
		
		
	         WHEN 1 =>
			
		               D11_D0 <= "010000000000"; ----clear reset in CR1 i.e write 400 to CR1	
                       count<=count+1;
		
	         WHEN 2 =>
	             
		               D11_D0 <= "000000010100"; ----CR0 |TEST1 |TEST0 |SCAN |DIFF1| DIFF0 |CHSEL1 |CHSEL0| PD |MODE| VREF
                       count<=count+1;
		
	         WHEN 3 =>
	             
						D11_D0 <="010111010000";  ----CR1| RBACK| OFFSET |BIN/2s |R/W |DATA_P |DATA_T |TRIG1 |TRIG0 |OVFL/FIFO RESET |RESET
						count<=count+1;
                      
                      
                       
		
	----------------------------------------------------------------------------
	----------------------- end -initialisation---------------------------------			
	----------------------------------------------------------------------------
		
	          WHEN 4 =>

		               rd_activelow	<= '0';  ----set read operation
		               wr_activelow	<= '1';
		               D11_D0 <= (others=>'Z');
	        
		               if data_av = '1' then
		             
			                digital_val <= D11_D0 ;  ----capture the data in a buffer and then transmit to the next module
		              
		               end if ;
	

                 WHEN others =>
                       D11_D0 <= (others => 'Z');
                   
		
            end case ;	
        end if; -----reset
     end if;  -------rising_edge_enable



end process;
end architecture ADC_THS1206_ARCH ;	
