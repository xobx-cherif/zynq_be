-- Testbench template by cherif bilel

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library xil_defaultlib;

-- your module name should replace module_name
use xil_defaultlib.module_name;

entity testbench is
generic(
    tb_id            : integer              := 8
);
end testbench;
architecture Behavioral of testbench is

		-- your tb signals should go here
      signal tb_port1: std_logic;
      signal tb_port2 :  std_logic_vector (7 downto 0); 



		-- tb constants should go here
    -- this defines the Clock Period you want to simulate with
    Constant ClockPeriod : TIME := 5 ns;
    --Constant ClockPeriod2 : TIME := 10 ns;
    shared variable ClockCount : integer range 0 to 50_000_000 := 10;
begin	
	 -- place an instance of your module here
pwm_1: entity your_module_name 
	port map(
	  Port1=> tb_port1,
      Port2 => tb_port2

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
        -- your TB logic should be placed here
		
	wait; -- will wait forever


 END PROCESS tb;

end Behavioral;