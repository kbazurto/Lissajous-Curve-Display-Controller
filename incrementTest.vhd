----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.10.2017 22:36:28
-- Design Name: 
-- Module Name: incrementTest - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity incrementTest is
--  Port ( );
end incrementTest;

architecture Behavioral of incrementTest is
 component showIncrement Port ( clk : in STD_LOGIC;
              rst : in STD_LOGIC;
              increment : in STD_LOGIC_VECTOR(7 downto 0);
              firstDigit : out STD_LOGIC_VECTOR(3 DOWNTO 0);
              secondDigit : out STD_LOGIC_VECTOR(3 DOWNTO 0);
              thirdDigit : out STD_LOGIC_VECTOR(3 downto 0);
              negative : out STD_LOGIC
   );end component;
   
   signal clock: std_logic:='1';
   signal masterReset : std_logic:='0';
   signal one: std_logic_vector(3 downto 0);
       signal two: std_logic_vector(3 downto 0);
       signal three: std_logic_vector(3 downto 0);
       signal hola : std_logic;
       signal positiveX : std_logic_vector(7 downto 0);

begin
clock <= NOT clock after 2 ps;
utt: showIncrement port map ( 
        clk => clock,
               rst => masterReset,
               increment => positiveX,
               firstDigit => one,
               secondDigit => two,
               thirdDigit => three,
               negative => hola
        );
key_generator: process begin
            masterReset <= '1';
            wait for 20 ps;
            masterReset<='0';
            
            wait for 20 ps;
            positiveX <= "11111111";
            wait for 20 ps;
            wait;
            end process;

end Behavioral;
