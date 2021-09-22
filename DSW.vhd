library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity DSW is
port(clk,start_stop : in std_logic;
     min,sec : in unsigned(5 downto 0);
     finish : out std_logic;
     sec_out,min_out : out unsigned(5 downto 0));
end DSW;
architecture BEH of DSW is
    type state is (x,y);
    signal p,n : state:=x;
    signal sect,mint,sout,mout : integer range 0 to 63; --(2to the power6)-1
begin
    sect <= conv_integer(sec);        --convert binary to integer
    mint <= conv_integer(min);
    sec_out <= conv_unsigned(sout,6); --6 bit convert like "111011"=59 and asigned sec_out in sout signal
    min_out <= conv_unsigned(mout,6);
    process(clk,start_stop)           --process senstive to clock and start_stop
    begin
       if (start_stop = '1') then     --initial  value recorded before start   
       p <= n;   
       case p is
            when x =>
                       if (sect > 59) then sout <= 59;
                       elsif (mint > 59) then mout <= 59;
                       else sout <= sect; mout <= mint;  -- active low stopwatch
                       end if; 
                       finish <= '0';
                       n <= y;
            when y =>   
                     if (clk = '1' and clk'event) then     
                       if (sout = 0) then 
                         sout <= 59;
                         if (mout = 0) then
                           finish <= '1';    --end process
                           sout <= 0;
                         else
                           mout <= mout - 1; --minutes countdown
                           finish <= '0';
                         end if;
                       else
                         sout <= sout - 1;   --seconds countdown
                         finish <= '0';
                       end if;  
                     end if; 
       end case;
       else
       n <= x;  
       end if;    
    end process;
end BEH;