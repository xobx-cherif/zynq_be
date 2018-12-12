--****************************************************--
--************* DIY valid ready handshake ************--
--****************************************************--

-- by bilel

-- this example demonstrates how a valid ready handshake
-- protocol function


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity diy_rvh is

generic(

	width : integer := 8;
	reg : integer := 2

);

port(

	clk: in std_logic;

	rst: in std_logic;

	awready : out std_logic;

	awvalid: in std_logic;

	addresse : in std_logic_vector(reg-1 downto 0);

	wready : out std_logic;

	wvalid : in std_logic;

	wdata : in std_logic_vector(width-1 downto 0);

	reg_out : out std_logic_vector (7 downto 0);
	bready: in std_logic;
	bvalid : out std_logic

);

end diy_rvh;

architecture arch of diy_rvh is



-- signals

signal rvh_awready : std_logic;

--signal rvh_awvalid: std_logic;

signal rvh_addresse : std_logic_vector(reg-1 downto 0);

signal rvh_wready : std_logic;

--signal rvh_wvalid : std_logic;

--signal rvh_wdata : std_logic_vector(width-1 downto 0);

signal reg_wren : std_logic;

signal rvh_bvalid : std_logic;

--signal rvh_bready : std_logic;

-- regs signals

signal reg1 : std_logic_vector(width-1 downto 0);

signal reg2 : std_logic_vector(width-1 downto 0);

signal reg3 : std_logic_vector(width-1 downto 0);

signal reg4 : std_logic_vector(width-1 downto 0);

begin

-- IO assignement

awready <= rvh_awready;

--awvalid: <= rvh_awvalid;

--addresse <= rvh_addresse;

wready <= rvh_wready;

bvalid <= rvh_bvalid;

--wvalid <= rvh_wvalid;

--wdata <= rvh_wdata;

--awready generation
--asserted in one clock cycle when awvlid and awready are both asserted
-- desasserted when reset is low
--awready: 
process(clk)

begin
if clk'event and clk = '1' then 

	if rst = '0' then
		rvh_awready <= '0';
	else
		if( rvh_awready = '0' and awvalid = '1' and wvalid = '1' ) then

			rvh_awready <= '1';
		else
			rvh_awready <= '0';
		end if;
	end if;
end if;
end process; --awready;

--adresse latching
--latching adresse when both awvalid and wvalid are both high

--addresse: 
process(clk)

begin
if clk'event and clk = '1' then 

	if rst = '0' then
		rvh_addresse  <= (others => '0');
	else
		if( rvh_awready = '0' and awvalid = '1' and wvalid = '1' ) then

			rvh_addresse <= addresse;
		end if;
	end if;
end if;
end process; 

--addresse;

--wready generation
--asserted in one clock cycle when awvlid and wvalid are both asserted
-- desasserted when reset is low
--awready: 

process(clk)

begin
if clk'event and clk = '1' then 

	if rst = '0' then
		rvh_wready <= '0';
	else
		if rvh_awready = '0' and awvalid = '1' and wvalid = '1' then

			rvh_wready <= '1';
		else
			rvh_wready <= '0';
		end if;
	end if;
end if;
end process; --awready;


--regs latching

reg_wren <= rvh_awready and awvalid and rvh_wready and wvalid ; 

--regs: 

process(clk)

begin
if clk'event and clk = '1' then 
	if rst = '0' then
		reg1 <= (others => '0');
		reg2 <= (others => '0');
		reg3 <= (others => '0');
		reg4 <= (others => '0');
	else
		if reg_wren = '1' then
			case rvh_addresse is
				when b"00" =>
					--write on reg1
					reg1 <= wdata;

				when b"01" =>
					--write on reg2
					reg2 <= wdata;
				when b"10" =>
                    --write on reg2
                    reg3 <= wdata;
				when "11" =>
                    --write on reg2
                    reg4 <= wdata;
				when others =>

					reg1 <= reg1;
					reg2 <= reg2;
					reg3 <= reg3;
					reg4 <= reg4;
			end case;
		end if;
	end if;
end if;
end process; --regs;

process (clk)
	begin
	  if clk'event and clk = '1' then 
	    if rst = '0' then
	      rvh_bvalid  <= '0';

	    else
	      if (rvh_awready = '1' and awvalid = '1' and rvh_wready = '1' and wvalid = '1' and rvh_bvalid = '0'  ) then
	        rvh_bvalid <= '1';
	        
	      elsif (bready = '1' and rvh_bvalid = '1') then   --check if bready is asserted while bvalid is high)
	        rvh_bvalid <= '0';                                 -- (there is a possibility that bready is always asserted high)
	      end if;
	    end if;
	  end if;                   
end process; 

--output the regs

reg_out(7 downto 0) <= reg1; 


end arch;