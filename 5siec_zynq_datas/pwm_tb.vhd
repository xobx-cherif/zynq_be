-- Testbench by cherif bilel
library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library xil_defaultlib;

-- your module name should replace module_name
use xil_defaultlib.pwm;

entity testbench is
end testbench;
architecture Behavioral of testbench is

		-- your tb signals should go here
      signal rst_tb: std_logic:= '0';
      signal tb_clk: std_logic;
      signal outpwm_tb: std_logic;
      signal duty_tb :  std_logic_vector (7 downto 0); 



		-- tb constants should go here
    -- this defines the Clock Period you want to simulate with
    Constant ClockPeriod : TIME := 5 ns;
    --Constant ClockPeriod2 : TIME := 10 ns;
    shared variable ClockCount : integer range 0 to 50_000_000 := 10;
begin	
	 -- place an instance of your module here
pwm_1: entity pwm 
     port map(
           clk => tb_clk,
           duty_cycle => duty_tb,
           reset => rst_tb,
           outpwm => outpwm_tb
           );
           
-- this process simulates the clock signal
GENERATE_REFCLOCK : process
 begin
   wait for (ClockPeriod / 2);
   ClockCount:= ClockCount+1;
   tb_clk <= '1';
   wait for (ClockPeriod / 2);
   tb_clk <= '0';
 end process;
 
  tb : PROCESS
 BEGIN
   
    duty_tb<= b"00101000"; --40%
    wait until tb_clk = '0';
    rst_tb <= '1';


    


 END PROCESS tb;

end Behavioral;
