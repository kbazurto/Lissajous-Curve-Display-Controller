----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.10.2017 18:06:10
-- Design Name: 
-- Module Name: showIncrement - Behavioral
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

entity showIncrement is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           increment : in STD_LOGIC_VECTOR(7 downto 0);
           decrement : in STD_LOGIC_VECTOR(7 downto 0);
           firstDigit : out STD_LOGIC_VECTOR(3 DOWNTO 0);
           secondDigit : out STD_LOGIC_VECTOR(3 DOWNTO 0);
           thirdDigit : out STD_LOGIC_VECTOR(3 downto 0);
           negative : out STD_LOGIC);
end showIncrement;

architecture Behavioral of showIncrement is
signal first : std_logic_vector(3 downto 0):="0000";
signal second : std_logic_vector(3 downto 0):="0000";
signal third : std_logic_vector(3 downto 0):="0011";
signal decimal : integer:=0;


begin

    process(clk, rst) begin
        if(rst = '1') then
            first <= "0000";
            second <= "0000";
            third <= "0000";
        elsif(rising_edge(clk))then
            if(increment >= decrement) then
                decimal <= CONV_INTEGER(increment - decrement);
                negative <= '1';
            else
                decimal <= CONV_INTEGER(decrement - increment);
                negative <= '0';
            end if;
            --decimal <= CONV_INTEGER(increment);
            second <= conv_std_logic_vector(decimal/10, 4);
            first <= conv_std_logic_vector(decimal rem 10, 4);
            --conv_std_logic_vector(integer_signal, num_bits). 
        end if;
    end process;
   firstDigit <= first;
   secondDigit <= second;
end Behavioral;
