----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.10.2017 21:31:23
-- Design Name: 
-- Module Name: keyTest - Behavioral
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

entity keyTest is
--  Port ( );
end keyTest;

architecture Behavioral of keyTest is

component keyPad Port ( 
           clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           rows : in STD_LOGIC_VECTOR (3 downto 0);
           columns : out STD_LOGIC_VECTOR (3 downto 0)
           --firstDigit : out STD_LOGIC_VECTOR (3 downto 0);
           --secondDigit: out STD_LOGIC_VECTOR (3 downto 0);
           --thirdDigit : out STD_LOGIC_VECTOR (3 downto 0);
           --fourthDigit: out STD_LOGIC_VECTOR (3 downto 0);
           --keyCheck : out STD_LOGIC_VECTOR(3 downto 0);
           --addSho : out STD_LOGIC_VECTOR(3 downto 0)
           );
end component;


component register_simple Port ( 
           rst: in std_logic; 
           clk : in std_logic;
           reg_in : in std_logic_vector(3 downto 0); 
           AB : in std_logic_vector(3 downto 0); 
           reg_out : out std_logic_vector(3 downto 0)
		 ); 
end component;

signal reset: std_logic:='1';
signal clock: std_logic:='1';
signal row : std_logic_vector (3 downto 0);
signal column: std_logic_vector (3 downto 0);
signal a: std_logic_vector(3 downto 0);
signal b: std_logic_vector(3 downto 0);
signal c: std_logic_vector(3 downto 0);
signal d: std_logic_vector(3 downto 0);
signal e: std_logic_vector(3 downto 0);
signal outputt1 : std_logic_vector(3 downto 0);
signal outputt2 : std_logic_vector(3 downto 0);
signal outputt3 : std_logic_vector(3 downto 0);
signal outputt4 : std_logic_vector(3 downto 0);

begin
clock <= NOT clock after 2 ps;

utt: keyPad port map(
            clk =>clock,
          rst => reset,
          rows => row,
          columns => column
          --firstDigit => a,
          --secondDigit => b,
          --thirdDigit=> c,
          --fourthDigit =>d,
          --keyCheck : out STD_LOGIC_VECTOR(3 downto 0);
       --   addSho => e
);

u2: register_simple port map (
        rst => reset,
           clk => clock,
           reg_in => a, 
           AB => e,
           reg_out => outputt1
);

u3: register_simple port map (
         rst => reset,
          clk => clock,
          reg_in => b, 
          AB => e,
          reg_out => outputt2
);

u4: register_simple port map (
         rst => reset,
          clk => clock,
          reg_in => c, 
          AB => e,
          reg_out => outputt3
);
    
u5: register_simple port map (
         rst => reset,
          clk => clock,
          reg_in => d, 
          AB => e,
          reg_out => outputt4
);
    
    
     
key_generator: process begin
    reset <= '1';
    wait for 20 ps;
    reset<='0';
    
    wait for 20 ps;
    a <= "0001";
    row <= "0001";
    wait for 20 ps;
    b <= "0010" ;
    row <= "0010"; 
    wait for 20 ps;  
    e <= "1010";
    row <= "1010"; 
    wait for 20 ps;
    e<= "0000";
    c <= "0100";
    row <= "0100"; 
    wait for 20 ps;
    d <= "1000";
    row <= "1000";
    wait for 20 ps; 
    e <="1011";
    
    
--    row <= "0010";
--    wait for 20 ps;
--    row <= "0001";
--    wait for 20 ps;
--    row <= "1010";
--    wait for 20 ps;
--    row <= "0011";
--    wait for 20 ps;
--    row <= "0100";
--    wait for 20 ps;
--    row <= "1011";
    wait;
end process;


end Behavioral;


