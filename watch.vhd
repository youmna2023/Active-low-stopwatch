library ieee;
use ieee.std_logic_1164.all;

entity watch is 
generic ( min : integer := 3;
	  sec: integer := 20);
port ( clock ,En ,L ,start_stop,reset: in std_logic;
       sec_out : inout integer :=0;
       min_out : inout integer := 0;
       finish : inout std_logic := '1');
end watch;

architecture beh of watch is 
begin 
process
begin 
wait until (clock'event and clock = '1');
if start_stop = '1' then
	if reset = '1' then
		sec_out <= 0;
		min_out <= 0; 
		finish <= '1';
	else
		if L = '1' then 
			if sec = 0 then
				sec_out <= 59;
				min_out <= min-1;
				finish <= '0';
                                if min = 0 then
                                   sec_out <= 0;
                                   min_out<= 0;
                                   finish <= '1';
                               end if;
                        else
			sec_out <= sec-1;
			min_out <= min;
			finish <= '0';
                        end if;
		else
			if En = '1' then 
				sec_out <= sec_out-1;
				if sec_out = 0 then					
					if min_out = 0 then
						finish <= '1';
						min_out <= 0;
						sec_out	<=0;
					else 
						finish <= '0';
						sec_out <= 59;
						min_out <= min_out-1;
					end if;
				end if;
			end if;
		end if;
	end if;
else 
sec_out <= sec_out;
min_out <= min_out;
finish <= finish;
end if;
end process;
end beh;