----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.10.2017 15:33:47
-- Design Name: 
-- Module Name: frequencyHandler - Behavioral
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

entity frequencyHandler is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           number : integer;
           clockOut : out STD_LOGIC;
           clearFlag : in STD_LOGIC;
           Fflag : in STD_LOGIC;
           modeChanged : in STD_LOGIC);
end frequencyHandler;

architecture Behavioral of frequencyHandler is
    TYPE State_type_frequency IS (A,B);
    SIGNAL frequency : State_type_frequency:=A;
    signal newClock : std_logic:='0';
    signal scalar : integer:= 0;
    signal count : integer:= 0;
begin
    scalar <= number;
    clockOut <= newClock;
    process(clk, rst) begin
        if(rst = '1') then
            frequency <= A;
            count <= 0;
            newClock <= '0';
        elsif(rising_edge(clk))then
            case frequency is
                when A =>
                    if (clearFlag = '1' or modeChanged = '1' or Fflag = '1') then
                        count <= 0;
                    elsif(count >= scalar)then
                        frequency <= B;
                    end if;
                    count <= count + 1;
                    newClock <= '0';
                when B =>
                    newClock <= '1';
                    count <= 0;
                    frequency <= A;
            end case;
        end if;
    end process;
end Behavioral;
