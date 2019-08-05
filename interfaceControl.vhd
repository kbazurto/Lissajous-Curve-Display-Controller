----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.10.2017 16:19:46
-- Design Name: 
-- Module Name: interfaceControl - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity interfaceControl is
    Port ( clk : in STD_LOGIC;
           switches : in STD_LOGIC_VECTOR(2 downto 0);
           mode : out STD_LOGIC_VECTOR(4 downto 0);
           x1 : in STD_LOGIC_VECTOR(3 downto 0);
           x2 : in STD_LOGIC_VECTOR(3 downto 0);
           y1 : in STD_LOGIC_VECTOR(3 downto 0);
           y2 : in STD_LOGIC_VECTOR(3 downto 0);
           firstA : in STD_LOGIC_VECTOR(3 downto 0);
           secondA : in STD_LOGIC_VECTOR(3 downto 0);
           firstB : in STD_LOGIC_VECTOR(3 downto 0);
           secondB : in STD_LOGIC_VECTOR(3 downto 0);
           accX1 : in STD_LOGIC_VECTOR(3 downto 0); 
           accX2 : in STD_LOGIC_VECTOR(3 downto 0); 
           accY1 : in STD_LOGIC_VECTOR(3 downto 0); 
           accY2 : in STD_LOGIC_VECTOR(3 downto 0); 
          
           outA1 : out STD_LOGIC_VECTOR(3 downto 0);
           outA2 : out STD_LOGIC_VECTOR(3 downto 0);
           outB1 : out STD_LOGIC_VECTOR(3 downto 0);
           outB2 : out STD_LOGIC_VECTOR(3 downto 0);
           fifthDigit : out STD_LOGIC_VECTOR(3 downto 0);
           sixthDigit : out STD_LOGIC_VECTOR(3 downto 0);
           seventhDigit : out STD_LOGIC_VECTOR(3 downto 0);
           eigthDigit : out STD_LOGIC_VECTOR(3 downto 0);
           modeChanged : out STD_LOGIC
           );
end interfaceControl;

architecture Behavioral of interfaceControl is
TYPE State_type_mode IS (A,B,C,D,E);
SIGNAL modeState : State_type_mode:=A;

signal memorySwitch : std_logic_vector(2 downto 0):="000";
signal betweenModes : std_logic:='0';
begin
    modeChanged <= betweenModes;
    process(clk)begin
        if(rising_edge(clk))then
            if(memorySwitch /= switches)then
                betweenModes <= '1';
                memorySwitch <= switches;
            elsif(switches = "000")then
                mode <= "00001";
                outA1 <= "0000";
                outA2 <= "0001";
                outB1 <= "0000";
                outB2 <= "0001";
                betweenModes <= '0';
                memorySwitch <= "000";
            elsif(switches = "001")then
                mode <= "00010";
                outA1 <= "0000";
                outA2 <= "0001";
                outB1 <= "0000";
                outB2 <= "0001";
                fifthDigit <= x1;
                sixthDigit <= x2;
                seventhDigit <= y1;
                eigthDigit <= y2;
                betweenModes <= '0';
                memorySwitch <= "001";
            elsif(switches = "010")then
                outA1 <= firstA;
                outA2 <= secondA;
                outB1 <= firstB;
                outB2 <= secondB;
                mode <= "00100";
                fifthDigit <= secondA;
                sixthDigit <= firstA;
                seventhDigit <= secondB;
                eigthDigit <= firstB;
                betweenModes <= '0';
                memorySwitch <= "010";
            elsif(switches = "011")then
                mode <= "01000";
                outA1 <= "0000";
                outA2 <= "0011";
                outB1 <= "0000";
                outB2 <= "0001";
                fifthDigit <= accY2;
                sixthDigit <= accY1;
                seventhDigit <= accX2;
                eigthDigit <= accX1;
                betweenModes <= '0';
                memorySwitch <= "011";
            elsif(switches = "100")then
                mode <= "10000";
                outA1 <= "0000";
                outA2 <= "0011";
                outB1 <= "0000";
                outB2 <= "0001";
                fifthDigit <= accY2;
                sixthDigit <= accY1;
                seventhDigit <= accX2;
                eigthDigit <= accX1;
                betweenModes <= '0';
                memorySwitch <= "100";
                
            end if;
        end if;
    end process;
end Behavioral;
