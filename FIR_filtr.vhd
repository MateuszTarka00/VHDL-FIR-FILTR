library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FIR_filtr is
	port( reset, clk : in std_logic;
			wsp_0 : in std_logic_vector(7 downto 0);
			wsp_1 : in std_logic_vector(7 downto 0);
			wsp_2 : in std_logic_vector(7 downto 0);
			wsp_3 : in std_logic_vector(7 downto 0);
			i_data : in std_logic_vector(7 downto 0);
			o_data : out std_logic_vector(9 downto 0));
end FIR_filtr;

architecture FIR_filtr_arch of FIR_filtr is

signal first_stage_0, first_stage_1, first_stage_2, first_stage_3 : std_logic_vector(15 downto 0);
signal second_stage_0, second_stage_1 : std_logic_vector(16 downto 0);
signal third_stage : std_logic_vector(17 downto 0);
signal filtr_data_0,  filtr_data_1,  filtr_data_2,  filtr_data_3 : std_logic_vector(7 downto 0);

function multiply(
	a : std_logic_vector(7 downto 0);
	b : std_logic_vector(7 downto 0)) 
	return std_logic_vector is
		variable wynik : std_logic_vector(15 downto 0):= (others => '0');
	begin
		for i in 0 to 7 loop
			if(b(i) = '1') then
				wynik(7+i downto i) := wynik(7+i downto i) + a;
			end if;
		end loop;
	return wynik;
end multiply;
	
begin

reg: process(reset, clk)
begin
	if(reset = '0') then
	
		filtr_data_0 <= (others => '0');
		filtr_data_1 <= (others => '0');  
		filtr_data_2 <= (others => '0'); 
		filtr_data_3 <= (others => '0');
	
	elsif(clk'Event and clk = '1') then
		
		filtr_data_0 <= filtr_data_1;
		filtr_data_1 <= filtr_data_2;
		filtr_data_2 <= filtr_data_3;
		filtr_data_3 <= i_data;
		
	end if;

end process;

first_stage: process(reset, clk)
begin
	if(reset = '0') then
	
		first_stage_0 <= (others => '0');
		first_stage_1 <= (others => '0');
		first_stage_2 <= (others => '0');
		first_stage_3 <= (others => '0');
		
	elsif(clk'Event and clk = '1') then
	
		first_stage_0 <= multiply(filtr_data_0, wsp_3);
		first_stage_1 <= multiply(filtr_data_1, wsp_2);
		first_stage_2 <= multiply(filtr_data_2, wsp_1);
		first_stage_3 <= multiply(filtr_data_3, wsp_0);
		
	end if;
end process;

second_stage: process(reset, clk)

variable x_0, x_1, x_2, x_3 : std_logic_vector(16 downto 0);

begin
	if(reset = '0') then
	
		second_stage_0 <= (others => '0');
		second_stage_1 <= (others => '0');
		
	elsif(clk'Event and clk = '1') then
	
		x_0 := '0' & first_stage_0;
		x_1 := '0' & first_stage_1;
		x_2 := '0' & first_stage_2;
		x_3 := '0' & first_stage_3;
		
		second_stage_0 <= x_0 + x_1;
		second_stage_1 <= x_2 + x_3;
		
	end if;
end process;

third_stage_proc: process(reset, clk)

variable x_0, x_1 : std_logic_vector(17 downto 0);

begin

	if(reset = '0') then
	
		third_stage <= (others => '0');
		
	elsif(clk'Event and clk = '1') then
	
		x_0 := '0' & second_stage_1;
		x_1 := '0' & second_stage_0;
		
		third_stage <= x_0 + x_1;
	
	end if;
end process;

o_data <= third_stage(17 downto 8);

end FIR_filtr_arch;

