library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library xil_defaultlib;
use xil_defaultlib.diy_rvh;


entity testbench is
generic
(
  tb_width             : integer              := 8;
  tb_reg             : integer              := 2
);

end testbench;

architecture Behavioral of testbench is
    signal tb_regout		          : std_logic_vector(7 downto 0);
    
    signal tb_clk                     :  std_logic;
    signal tb_rst                 :  std_logic;
    signal tb_addresse                   :  std_logic_vector(tb_reg-1 downto 0);
    signal tb_awvalid                  :  std_logic;
    signal tb_wdata                   :  std_logic_vector(tb_width-1 downto 0);
    signal tb_wvalid                  :  std_logic;

    signal tb_wready                   : std_logic;
    signal tb_awready                  : std_logic;
    signal tb_bready                   : std_logic;
    signal tb_bvalid                  : std_logic;



    
    Constant ClockPeriod : TIME := 5 ns;
    Constant ClockPeriod2 : TIME := 10 ns;
    shared variable ClockCount : integer range 0 to 50_000 := 10;
    signal sendIt : std_logic := '0';
    --signal readIt : std_logic := '0';

begin

  -- instance "diy_rvh"
   diy_rvh_1: entity diy_rvh
    generic map (
      width => tb_width,
      reg => tb_reg )
    port map (

	clk=> tb_clk,

	rst =>tb_rst,

	awready => tb_awready,

	awvalid => tb_awvalid,

	addresse => tb_addresse,

	wready => tb_wready,

	wvalid => tb_wvalid,

	wdata =>tb_wdata,

	reg_out => tb_regout,
	
	bready => tb_bready,
	
	bvalid => tb_bvalid

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
    tb_awvalid<='0';
    tb_wvalid<='0';

    loop
        wait until sendIt = '1';
        wait until tb_clk = '0';
            tb_awvalid<='1';
            --tb_awvalid<='0'; --let's mess a little bit with our slave
            tb_wvalid<='1';  -- Master in ready
        wait until (tb_awready and tb_wready) = '1';  --Client ready to read address/data        
           tb_bready<='1'; -- Master ready to receive response
        wait until tb_bvalid = '1';  -- Write result valid
	wait until tb_clk = '0';
            tb_awvalid<='0';
            tb_wvalid<='0';
            tb_bready<='1';
        wait until tb_bvalid = '0';  -- All finished
            tb_bready<='0';
    end loop;
 END PROCESS send;



 -- 
 tb : PROCESS
 BEGIN
        tb_rst<='0';
        sendIt<='0';
    wait for 15 ns;
        tb_rst<='1';

        tb_addresse<=b"00";
        tb_wdata<=b"00000001";
        sendIt<='1';                --Start AXI Write to Slave
        wait for 1 ns; sendIt<='0'; --Clear Start Send Flag
        wait until tb_bvalid = '1';
        wait until tb_bvalid = '0'; --AXI Write finished
        
        
        
        tb_addresse<=b"00";
        tb_wdata<=b"00000011";
        sendIt<='1';                --Start AXI Write to Slave
        wait for 1 ns; sendIt<='0'; --Clear Start Send Flag
        wait until tb_bvalid = '1';
        wait until tb_bvalid = '0'; --AXI Write finished
        
	--wait for 15 ns;

            
        tb_addresse<= b"01";
        tb_wdata<=b"00000010";
	sendIt<='1';                --Start AXI Write to Slave
        wait for 1 ns; sendIt<='0'; --Clear Start Send Flag
        wait until tb_bvalid = '1';
        wait until tb_bvalid = '0'; --AXI Write finished
	--wait for 10 ns;
        tb_addresse<= b"00";
        tb_wdata<=b"00000000";      
     wait; -- will wait forever
 END PROCESS tb;

end Behavioral;
