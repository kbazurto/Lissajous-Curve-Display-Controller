----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.10.2017 12:08:42
-- Design Name: 
-- Module Name: buttonHandler - Behavioral
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

entity buttonHandler is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           buttonIn : in STD_LOGIC;
           mode1 : in STD_LOGIC;
           display : out STD_LOGIC;
           result : out STD_LOGIC_VECTOR(7 DOWNTO 0));
end buttonHandler;

architecture Behavioral of buttonHandler is
    TYPE State_type_counter IS (A,B);
    SIGNAL counter : State_type_counter:=A;
    
    signal pressed : std_logic_vector(7 downto 0):="00000000";
    signal toggle : std_logic:='1';
begin
    result <= pressed;
    display <= toggle;
    process (clk, rst) begin
        if(mode1 = '1') then 
            if (rst = '1') then
                counter <= A;
                pressed <= "00000000";
                toggle <= '1';
            elsif (rising_edge(clk)) then
                case counter is
                    when A =>
                        if(buttonIn = '1')then
                            counter <= B;
                            toggle <= NOT toggle;
                            pressed <= pressed + '1';
                            
                        end if;
                    when B =>
                        if(buttonIn = '0') then
                            counter <= A;
                        end if;
                end case;       
            end if;
        else
            pressed <= "00000000";
        end if;
    end process;
end Behavioral;
