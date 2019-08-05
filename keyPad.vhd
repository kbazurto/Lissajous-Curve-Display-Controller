----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.09.2017 17:34:50
-- Design Name: 
-- Module Name: keyPad - Behavioral
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

entity keyPad is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           rows : in STD_LOGIC_VECTOR (3 downto 0);
           columns : out STD_LOGIC_VECTOR (3 downto 0);
           firstDigit : out STD_LOGIC_VECTOR (3 downto 0);
           secondDigit: out STD_LOGIC_VECTOR (3 downto 0);
           thirdDigit : out STD_LOGIC_VECTOR (3 downto 0);
           fourthDigit: out STD_LOGIC_VECTOR (3 downto 0);
           changeFlag : out STD_LOGIC;
           betweenModes : in STD_LOGIC;
           Fflag : out STD_LOGIC;
           mode2 : in STD_LOGIC
           );
end keyPad;

architecture Behavioral of keyPad is

    TYPE State_type_row IS(A,B,C,D,E,L);
    TYPE State_type_flag IS (F,G,H,I,J,K);
    TYPE State_type_column IS(S0,S1,S2,S3);
    SIGNAL row : State_type_row:=A; --read rows
    SIGNAL column : State_type_column:=S0; --drive // write
    SIGNAL copyColumn : State_type_column:=S0;
    SIGNAL flag: State_type_flag:=F;
    
    signal key : std_logic_vector(3 downto 0):="0000";
    signal one : std_logic_vector(3 downto 0):="0000";
    signal two : std_logic_vector(3 downto 0):="0000";
    signal three : std_logic_vector(3 downto 0):="0000";
    signal four : std_logic_vector(3 downto 0):="0000";
    signal check : std_logic:='0';
    signal secondCheck : std_logic:='0';
    signal newSet : std_logic:='0';
    signal betModes : std_logic:='0';
    signal circle : std_logic:='0';
begin
    changeFlag <= newSet;
    Fflag <= circle;
    process (clk, rst) begin
        if(rst = '1') then
            column <= S0;
        ELSIF ( clk'Event AND clk = '1' and mode2 ='1') THEN
            CASE column IS
                WHEN S0 =>
                    columns <= "0111";--first
                    column <= S1;
                WHEN S1 =>
                    columns <= "1011"; --second
                    column <= S2;
                WHEN S2 =>
                    columns <= "1101"; --third
                    column <= S3;
                WHEN S3 =>
                    columns <= "1110"; --fourth
                    column <= S0;   
            end case;
        end if;
    end process;
    
    process (clk, rst, rows) begin
        if(rst = '1') then
            row <= A;
        ELSIF ( clk'Event AND clk = '1' and mode2 ='1') THEN
            CASE row IS
                WHEN A =>
                    IF ( column = S0 ) THEN -- fourth column
                        IF ( rows = "0111") THEN
                            key <= "1010"; --A
                            copyColumn <= S0;
                            row <= E;
                        ELSIF ( rows = "1011") THEN --B
                            key <= "1011";
                            copyColumn <= S0;
                            row <= E;
                        ELSE
                            row <= B;
                        END IF;  
                    END IF;
                    check <='0';
                WHEN B =>
                    IF ( column = S1 ) THEN -- first column
                        IF ( rows = "0111") THEN
                            key <= "0001";
                            copyColumn <= S1;
                            row <= E;
                        ELSIF ( rows = "1011") THEN
                            key <= "0100";
                            copyColumn <= S1;
                            row <= E;
                        ELSIF ( rows = "1101") THEN
                            key <= "0111";
                            copyColumn <= S1;
                            row <= E;
                        ELSIF ( rows = "1110") THEN
                            key <= "0000"; 
                            copyColumn <= S1;
                            row <= E;
                        ELSE
                            row <= C;
                        END IF;   
                    END IF;
                    check <='0';
                WHEN C =>
                    IF ( column = S2 ) THEN -- second column
                        IF ( rows = "0111") THEN
                            key <= "0010";
                            copyColumn <= S2;
                            row <= E;
                        ELSIF ( rows = "1011") THEN
                            key <= "0101";
                            copyColumn <= S2;
                            row <= E;
                        ELSIF ( rows = "1101") THEN
                            key <= "1000";
                            copyColumn <= S2;
                            row <= E;
                        ELSIF (rows = "1110") THEN --HANDLE FFFFFFFFFFFFFFFFFFFFFFFFF
                            key <= "1111";
                            copyColumn <= S2;
                            betModes <= '1';
                            row <= L;
                        ELSE
                            row <= D;
                        END IF;     
                    END IF;
                    check <='0';
                WHEN D =>
                    
                    IF ( column = S3 ) THEN --third column
                        IF ( rows = "0111") THEN
                            key <= "0011";
                            copyColumn <= S3;
                            row <= E;
                        ELSIF ( rows = "1011") THEN
                            key <= "0110";
                            copyColumn <= S3;
                            row <= E;
                        ELSIF ( rows = "1101") THEN
                            key <= "1001";
                            copyColumn <= S3;
                            row <= E;
                        ELSE
                            row <= A;
                        END IF;  
                    END IF;
                    check <='0';
                WHEN E =>
                    if(column = copyColumn and rows = "1111") then
                        row <= A;
                        check <='1';
                    end if;
                WHEN L =>
                    if(column = copyColumn and rows = "1111") then
                        row <= A;
                        betModes <= '0';
                    end if;
                    
            end case;
        end if;
    end process;
    
    process(betweenModes,  betModes) begin
        if(betweenModes ='1' or betModes='1' ) then
            circle <='1';
        else
            circle <='0';
        end if;
    end process;
   
    process(check, rst) begin
        if(rst='1' or circle ='1') then
             flag <= F;
             newSet <= '0';
             firstDigit <= "0000";
             secondDigit <= "0001";
             thirdDigit <= "0000";
             fourthDigit <= "0001";
        elsif(check'Event AND check = '1')then
            case flag is
                WHEN F =>
                    flag <= G;
                    one <= key;
                WHEN G =>
                    flag <= H;
                    two <= key;
                WHEN H =>
                    flag <= I;        
                    if(key = "1010") then
                        secondCheck <= '1';
                        newSet <= '1';
                    end if;
                WHEN I =>
                    flag <= J;  
                    three <= key;
                WHEN J =>
                    flag <= K; 
                    four <= key;
                WHEN K =>  
                    if(key = "1011" and secondCheck = '1')then
                        firstDigit <= one;
                        secondDigit <= two;
                        thirdDigit <= three;
                        fourthDigit <= four;
                        secondCheck <= '0';
                        newSet <= '0';
                    end if; 
                    flag <= F;
                
        end case;
                
        end if;
    end process;
end Behavioral;
