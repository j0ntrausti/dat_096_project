
-- This is a Linear phase FIR filter of type 1. Has N coeff. and N-1 inputs.
-- The filter is written generic so it is defined as;
--                            Width = number of bits
--                            N = number of tabs   
-- Takes in, generic values width (nr. of bits), N number of tabs, x[n].
-- Sends out finihs signal, and y[n] (note double size, need to take the 12 last bits)
-- Authors: Jón Trausti
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FastFilter is
    generic(Width    :integer     :=16;
        N :integer    :=188);
    port(    reset:IN STD_LOGIC;
           clk:IN STD_LOGIC;
           clk250k:IN STD_LOGIC;
           clk6M:IN STD_LOGIC;
           x:IN signed(width-5 DOWNTO 0);
           y:OUT signed(WIDTH-5 DOWNTO 0);
           finished:OUT STD_LOGIC);
end FastFilter;



architecture behaiv_arch of FastFilter is


-- New signals
signal swapping    :std_logic :='0'; --this shall trigger when start goes to '1' and go down when start goes to '0' to see if there is a new x or not
signal i    :integer range 0 to N; --index for how many clkcykles the calculation have been running
signal finished_sig    :std_logic :='1';
-- For our x's
-- (2*(N-1)-2) is the last X, yeah I've done the calc right, unless I'm wrong (haven't tested)
type xLArray is array (0 to (2*(N-1)-2)) of signed(width-1 downto 0);
signal xL    :xLArray;
signal x_s :SIGNED(WIDTH-1 downto 0);
type MiddleArray is array (0 to (N-1)) of signed(width-1 downto 0); --- need to fix size
signal MiddleAdder    :MiddleArray;

type queue2multiArray is array (0 to (N-1)) of signed(width-1 downto 0); --- need to fix size
signal queue2multi    :queue2multiArray;

-- For the tabs
type tLArray is array (0 to N-1) of signed(width-1 downto 0);
signal t    :tLArray;




-- Old signals

signal y_s    :signed(2*width-1 downto 0);--temporary output

begin

x_s <= x & "0000";
process(clk,reset)
begin

    -- This will set all the x's to zero, resetting everything.
    -- so when the program start all values have zeros except for the coefficients
    if(reset='1') then
         -- Pretty much same as start, just double sec. since start is input signal
        i<=0;    -- reset the counter
        y_s <= (others => '0');
        y <= (others => '0');
        finished <= '0';
        finished_sig <= '1';
        
        for i in 0 to (2*(N-1)-2) loop
            if (i<(2*(N-1)-1)) then
                xL(i)<=(others=> '0');  
            end if;
        end loop;
        
        for i in 0 to (N-1) loop
               MiddleAdder(i)<=(others=> '0');
               queue2multi(i)<=(others=> '0');
        end loop;
        

        -- here the coeff. comes in for ex.
t(0)<="0000000000001001";
t(1)<="0000000000000001";
t(2)<="0000000000000001";
t(3)<="0000000000000000";
t(4)<="1111111111111111";
t(5)<="1111111111111111";
t(6)<="1111111111111011";
t(7)<="1111111111111001";
t(8)<="1111111111110110";
t(9)<="1111111111110010";
t(10)<="1111111111101110";
t(11)<="1111111111101010";
t(12)<="1111111111100100";
t(13)<="1111111111011111";
t(14)<="1111111111011001";
t(15)<="1111111111010010";
t(16)<="1111111111001100";
t(17)<="1111111111000101";
t(18)<="1111111110111111";
t(19)<="1111111110111001";
t(20)<="1111111110110011";
t(21)<="1111111110101110";
t(22)<="1111111110101010";
t(23)<="1111111110101000";
t(24)<="1111111110100110";
t(25)<="1111111110100110";
t(26)<="1111111110100111";
t(27)<="1111111110101011";
t(28)<="1111111110110000";
t(29)<="1111111110110111";
t(30)<="1111111111000000";
t(31)<="1111111111001011";
t(32)<="1111111111011000";
t(33)<="1111111111100110";
t(34)<="1111111111110110";
t(35)<="0000000000000111";
t(36)<="0000000000011000";
t(37)<="0000000000101010";
t(38)<="0000000000111101";
t(39)<="0000000001001110";
t(40)<="0000000001011111";
t(41)<="0000000001101110";
t(42)<="0000000001111100";
t(43)<="0000000010000111";
t(44)<="0000000010001111";
t(45)<="0000000010010100";
t(46)<="0000000010010101";
t(47)<="0000000010010010";
t(48)<="0000000010001011";
t(49)<="0000000010000000";
t(50)<="0000000001110001";
t(51)<="0000000001011101";
t(52)<="0000000001000101";
t(53)<="0000000000101001";
t(54)<="0000000000001010";
t(55)<="1111111111101000";
t(56)<="1111111111000100";
t(57)<="1111111110011111";
t(58)<="1111111101111010";
t(59)<="1111111101010101";
t(60)<="1111111100110010";
t(61)<="1111111100010001";
t(62)<="1111111011110101";
t(63)<="1111111011011101";
t(64)<="1111111011001011";
t(65)<="1111111011000000";
t(66)<="1111111010111101";
t(67)<="1111111011000011";
t(68)<="1111111011010010";
t(69)<="1111111011101011";
t(70)<="1111111100001110";
t(71)<="1111111100111100";
t(72)<="1111111101110100";
t(73)<="1111111110110111";
t(74)<="0000000000000011";
t(75)<="0000000001011000";
t(76)<="0000000010110110";
t(77)<="0000000100011100";
t(78)<="0000000110000111";
t(79)<="0000000111111000";
t(80)<="0000001001101011";
t(81)<="0000001011100000";
t(82)<="0000001101010110";
t(83)<="0000001111001001";
t(84)<="0000010000111001";
t(85)<="0000010010100100";
t(86)<="0000010100001000";
t(87)<="0000010101100011";
t(88)<="0000010110110100";
t(89)<="0000010111111010";
t(90)<="0000011000110011";
t(91)<="0000011001011111";
t(92)<="0000011001111101";
t(93)<="0000011010001100";
t(94)<="0000011010001100";
t(95)<="0000011001111101";
t(96)<="0000011001011111";
t(97)<="0000011000110011";
t(98)<="0000010111111010";
t(99)<="0000010110110100";
t(100)<="0000010101100011";
t(101)<="0000010100001000";
t(102)<="0000010010100100";
t(103)<="0000010000111001";
t(104)<="0000001111001001";
t(105)<="0000001101010110";
t(106)<="0000001011100000";
t(107)<="0000001001101011";
t(108)<="0000000111111000";
t(109)<="0000000110000111";
t(110)<="0000000100011100";
t(111)<="0000000010110110";
t(112)<="0000000001011000";
t(113)<="0000000000000011";
t(114)<="1111111110110111";
t(115)<="1111111101110100";
t(116)<="1111111100111100";
t(117)<="1111111100001110";
t(118)<="1111111011101011";
t(119)<="1111111011010010";
t(120)<="1111111011000011";
t(121)<="1111111010111101";
t(122)<="1111111011000000";
t(123)<="1111111011001011";
t(124)<="1111111011011101";
t(125)<="1111111011110101";
t(126)<="1111111100010001";
t(127)<="1111111100110010";
t(128)<="1111111101010101";
t(129)<="1111111101111010";
t(130)<="1111111110011111";
t(131)<="1111111111000100";
t(132)<="1111111111101000";
t(133)<="0000000000001010";
t(134)<="0000000000101001";
t(135)<="0000000001000101";
t(136)<="0000000001011101";
t(137)<="0000000001110001";
t(138)<="0000000010000000";
t(139)<="0000000010001011";
t(140)<="0000000010010010";
t(141)<="0000000010010101";
t(142)<="0000000010010100";
t(143)<="0000000010001111";
t(144)<="0000000010000111";
t(145)<="0000000001111100";
t(146)<="0000000001101110";
t(147)<="0000000001011111";
t(148)<="0000000001001110";
t(149)<="0000000000111101";
t(150)<="0000000000101010";
t(151)<="0000000000011000";
t(152)<="0000000000000111";
t(153)<="1111111111110110";
t(154)<="1111111111100110";
t(155)<="1111111111011000";
t(156)<="1111111111001011";
t(157)<="1111111111000000";
t(158)<="1111111110110111";
t(159)<="1111111110110000";
t(160)<="1111111110101011";
t(161)<="1111111110100111";
t(162)<="1111111110100110";
t(163)<="1111111110100110";
t(164)<="1111111110101000";
t(165)<="1111111110101010";
t(166)<="1111111110101110";
t(167)<="1111111110110011";
t(168)<="1111111110111001";
t(169)<="1111111110111111";
t(170)<="1111111111000101";
t(171)<="1111111111001100";
t(172)<="1111111111010010";
t(173)<="1111111111011001";
t(174)<="1111111111011111";
t(175)<="1111111111100100";
t(176)<="1111111111101010";
t(177)<="1111111111101110";
t(178)<="1111111111110010";
t(179)<="1111111111110110";
t(180)<="1111111111111001";
t(181)<="1111111111111011";
t(182)<="1111111111111111";
t(183)<="1111111111111111";
t(184)<="0000000000000000";
t(185)<="0000000000000001";
t(186)<="0000000000000001";
t(187)<="0000000000001001";




    elsif (rising_edge(clk)) then
--------------------------------------------------------------------    
-----------------------------SENDING OUT ---------------------------    
--------------------------------------------------------------------       
        if(finished_sig = '0') then
            
            if(i=N) then
                finished <= '1';
                finished_sig <= '1';
                y <= y_s(2*width-2 downto width+3);
                
            else
                y_s <= (((queue2multi(i)*t(i)))+y_s);
                i <= i+1;
            end if;
        elsif(clk250k = '1') then     
        	y_s <= (others => '0');
            finished_sig <= '0';
            finished<='0';
            i<=0;
            for j in 0 to N-1 loop
                queue2multi(j)<= MiddleAdder(j);
            end loop;
        end if;
--------------------------------------------------------------------    
-----------------------------READING IN ----------------------------    
--------------------------------------------------------------------  
        if (clk6M='1' AND swapping='0') then       
            swapping<='1';
            --y_s <= (others => '0');
            -- the first adding
            MiddleAdder(0)<=(xL((2*(N-1)-2)) + x_s);
            -- the last adding
            MiddleAdder(N-1)<= (xL(N-1));                        
            -- all the other adding
            for j in 1 to N-2 loop
                MiddleAdder(j)<= (xL(j-1) + xL(2*(N-1)-3-j));
            end loop;
        elsif (swapping='1') then
            -- this is the "delay" process, that moves x's to new location.
            -- its ok the swap them this soon, since after we load the middle adder we don't care about them.
            for j in 0 to (2*(N-1)-2) loop
                if (j<(2*(N-1)-2)) then
                    xL((2*(N-1)-2)-j)<=xL((2*(N-1)-3)-j);
                elsif (j=(2*(N-1)-2)) then
                    xL(0)<=x_s;
                end if;
            end loop;
            swapping<='0';    
        end if;
    end if;
end process;

end behaiv_arch;



