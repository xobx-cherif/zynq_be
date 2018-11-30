--****************************************************--
--************* DIY valid ready handshake ************--
--****************************************************--

-- by bilel

-- this example demonstrates how a valid ready handshake
-- protocol function


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity td_ex01 is

generic(

	width : integer := 8;
	reg : integer := 2

);

port(

	clk: in std_logic;

	rst: in std_logic;

	ready : out std_logic;

	valid: in std_logic;

	data : in std_logic_vector(width-1 downto 0)

);

end td_ex01;

architecture arch of td_ex01 is



-- signals

signal rvh_ready : std_logic;

signal reg_wren : std_logic;

signal reg1 : std_logic_vector(width-1 downto 0);

begin
	ready <= rvh_ready;
	
	
	--awready generation
--asserted in one clock cycle when awvlid and awready are both asserted
-- desasserted when reset is low
--awready: 
process(clk)

begin
if clk'event and clk = '1' then 

	if rst = '0' then
		rvh_ready <= '0';
	else
		if( rvh_ready = '0' and valid = '1' ) then

			rvh_ready <= '1';
		else
			rvh_ready <= '0';
		end if;
	end if;
end if;
end process; --awready;


--data latching

reg_wren <= rvh_ready and valid ; 

--regs: 

process(clk)

begin
if clk'event and clk = '1' then 
	if rst = '0' then
		reg1 <= (others => '0');
	else
		if reg_wren = '1' then
			reg1 <= data;
		end if;
	end if;
end if;
end process; --regs;




end arch;

