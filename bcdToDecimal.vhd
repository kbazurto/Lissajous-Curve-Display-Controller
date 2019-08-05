----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.10.2017 16:56:33
-- Design Name: 
-- Module Name: bcdToDecimal - Behavioral
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

entity bcdToDecimal is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           firstDigit : in STD_LOGIC_VECTOR(3 DOWNTO 0);
           secondDigit : in STD_LOGIC_VECTOR(3 downto 0);
           thirdDigit : in STD_LOGIC_VECTOR(3 DOWNTO 0);
           fourthDigit : in STD_LOGIC_VECTOR(3 downto 0);
           decimal1 : out integer;
           decimal : out integer);
end bcdToDecimal;

architecture Behavioral of bcdToDecimal is

    signal MSB : integer:=0;
    signal LSB : integer:=0;
    signal MSB1 : integer:=0;
    signal LSB1 : integer:=0;
begin
    MSB <= CONV_INTEGER(firstDigit);
    LSB <= CONV_INTEGER(secondDigit);
    MSB1 <= CONV_INTEGER(thirdDigit);
    LSB1 <= CONV_INTEGER(fourthDigit);
    process(clk) begin
        decimal <= 2*((MSB*10)+LSB)-2;
        decimal1 <= 2*((MSB1*10)+LSB1)-2;
    end process;

end Behavioral;
