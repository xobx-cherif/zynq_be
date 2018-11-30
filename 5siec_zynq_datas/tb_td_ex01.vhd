library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.td_ex01;


entity testbench is
generic
(
  tb_width             : integer              := 8;
  tb_reg             : integer              := 2
);

end testbench;

architecture Behavioral of testbench is
    
    signal tb_clk                     :  std_logic;
    signal tb_rst                 :  std_logic;
    signal tb_addresse                   :  std_logic_vector(tb_reg-1 downto 0);
    signal tb_valid                  :  std_logic;
    signal tb_ready                  :  std_logic;
    signal tb_data                   :  std_logic_vector(tb_width-1 downto 0);



    
    Constant ClockPeriod : TIME := 5 ns;
    Constant ClockPeriod2 : TIME := 10 ns;
    shared variable ClockCount : integer range 0 to 50_000 := 10;
    signal sendIt : std_logic := '0';
    --signal readIt : std_logic := '0';

begin

  -- instance "diy_rvh"
   td_ex01_1: entity td_ex01
    generic map (
      width => tb_width,
      reg => tb_reg )
    port map (

	clk=> tb_clk,

	rst =>tb_rst,

	ready => tb_ready,

	valid => tb_valid,

	data =>tb_data
);

 -- Generate S_AXI_ACLK signal
 GENERATE_REFCLOCK : process
 begin
   wait for (ClockPeriod / 2);
   ClockCount:= ClockCount+1;
   tb_clk <= '1';
   wait for (ClockPeriod / 2);
   tb_clk <= '0';
 end process;

 -- Initiate process which simulates a master wanting to write.
 -- This process is blocked on a "Send Flag" (sendIt).
 -- When the flag goes to 1, the process exits the wait state and
 -- execute a write transaction.
 send : PROCESS
 BEGIN
    tb_valid<='0';

    loop
        wait until sendIt = '1';
        wait until tb_clk = '0';
            tb_valid<='1';
        wait for 10 ns;
		tb_valid<='0';
    end loop;
 END PROCESS send;



 -- 
 tb : PROCESS
 BEGIN
        tb_rst<='0';
        sendIt<='0';
    wait for 15 ns;
        tb_rst<='1';
		
        tb_data<=b"00000001";
        sendIt<='1';                --Start AXI Write to Slave
        wait for 1 ns; sendIt<='0'; --Clear Start Send Flag
        wait until tb_ready = '0';
        
        
		
		tb_data<=b"10010101";
		wait for 5 ns;
        sendIt<='1';                --Start AXI Write to Slave
        wait for 1 ns; sendIt<='0'; --Clear Start Send Flag
        wait until tb_ready = '0';
        
        
     
     wait; -- will wait forever
 END PROCESS tb;

end Behavioral;