
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
 
ENTITY FIR_filtr_test IS
END FIR_filtr_test;
 
ARCHITECTURE behavior OF FIR_filtr_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT FIR_filtr
    PORT(
         reset : IN  std_logic;
         clk : IN  std_logic;
         wsp_0 : IN  std_logic_vector(7 downto 0);
         wsp_1 : IN  std_logic_vector(7 downto 0);
         wsp_2 : IN  std_logic_vector(7 downto 0);
         wsp_3 : IN  std_logic_vector(7 downto 0);
         i_data : IN  std_logic_vector(7 downto 0);
         o_data : OUT  std_logic_vector(9 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal reset : std_logic := '0';
   signal clk : std_logic := '0';
   signal wsp_0 : std_logic_vector(7 downto 0) := (others => '0');
   signal wsp_1 : std_logic_vector(7 downto 0) := (others => '0');
   signal wsp_2 : std_logic_vector(7 downto 0) := (others => '0');
   signal wsp_3 : std_logic_vector(7 downto 0) := (others => '0');
   signal i_data : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal o_data : std_logic_vector(9 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: FIR_filtr PORT MAP (
          reset => reset,
          clk => clk,
          wsp_0 => wsp_0,
          wsp_1 => wsp_1,
          wsp_2 => wsp_2,
          wsp_3 => wsp_3,
          i_data => i_data,
          o_data => o_data
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
	
	reset <= '0'; wait for 2*clk_period;
	reset <= '1'; 
	wsp_0 <= "00000101";
	wsp_1 <= "00000011";
	wsp_2 <= "00001000";
	wsp_3 <= "00000100"; wait for clk_period;
	i_data <= "00000011"; wait for clk_period;
	i_data <= "00100010"; wait for clk_period;
	i_data <= "10000100"; wait for clk_period;
	i_data <= "00001000"; wait for clk_period;
	wait for 20*clk_period;
	
   assert false severity failure;

      wait;
   end process;

END;
