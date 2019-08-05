----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.10.2017 16:06:44
-- Design Name: 
-- Module Name: sineTest - Behavioral
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

entity sineTest is
--  Port ( );
end sineTest;

architecture Behavioral of sineTest is
    component sin Port ( aclk : in STD_LOGIC;
           enableInput : in STD_LOGIC;
           enableOutput : out STD_LOGIC;
           sineOut : out STD_LOGIC_VECTOR(7 downto 0)
           --cosineOut : out STD_LOGIC_VECTOR(7 DOWNTO 0)
    ); end component;
    
    component cosin Port ( aclk : in STD_LOGIC;
        enableInput : in STD_LOGIC;
        enableOutput : out STD_LOGIC;
        cosineOut : out STD_LOGIC_VECTOR(7 DOWNTO 0)
    ); end component;
    
     signal clock: std_logic:='1';
     signal clock1: std_logic:='1';
     signal ENIN : std_logic :='1';
     signal ENOUT : std_logic;-- :='1';
     signal ENIN1 : std_logic :='1';
     signal ENOUT1 : std_logic;-- :='1';
     signal maybeCosine : std_logic_vector(7 downto 0);
     signal maybeSine : std_logic_vector(7 downto 0);
     
begin
utt: sin port map(
        aclk => clock,
        enableInput => ENIN,
        enableOutput => ENOUT,
        sineOut => maybeSine
        --cosineOut => maybeCosine
    );
    
u3: cosin port map(
                    aclk => clock1, 
                    enableInput => ENIN1,
                    enableOutput => ENOUT1,
                    cosineOut => maybeCosine
            );
clock <= NOT clock after 20 ps;
clock1 <= NOT clock1 after 40 ps;
ENIN <= NOT ENIN after 10 us;
end Behavioral;
