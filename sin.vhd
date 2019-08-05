----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.10.2017 15:34:05
-- Design Name: 
-- Module Name: sin - Behavioral
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

entity sin is
    Port ( aclk : in STD_LOGIC;
           enableInput : in STD_LOGIC;
           enableOutput : out STD_LOGIC;
           down : in STD_LOGIC_VECTOR(7 DOWNTO 0);
           up : in STD_LOGIC_VECTOR(7 DOWNTO 0);
           sineOut : out STD_LOGIC_VECTOR(7 downto 0);
           clearFlag : in STD_LOGIC;
           Fflag : in STD_LOGIC;
           mode3 : in STD_LOGIC;
           mode4 : in STD_LOGIC;
           ACCEL_Xs : in STD_LOGIC_VECTOR (7 downto 0);
           MOUSE_X:  in STD_LOGIC_VECTOR (7 downto 0);
           modeChanged : in STD_LOGIC
    );
end sin;


architecture Behavioral of sin is

    component cordic_0 port (
		aclk : IN STD_LOGIC;
        s_axis_phase_tvalid : IN STD_LOGIC;
        s_axis_phase_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        m_axis_dout_tvalid : OUT STD_LOGIC;
        m_axis_dout_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	); end component;
	
	signal sineCosine: std_logic_vector(15 downto 0):="0000000000000000";
	signal dataIn : std_logic_vector(15 downto 0):="0000000000000000";
	signal newData : std_logic_vector(15 downto 0):="0000000000000000";
	signal flag3 : std_logic:='0';
	signal ACCEL_X : std_logic_vector(7 downto 0);
begin

    u1 : cordic_0 port map (
		aclk => aclk,
		s_axis_phase_tvalid => enableInput,
		s_axis_phase_tdata => dataIn,
		m_axis_dout_tvalid => enableOutput,
		m_axis_dout_tdata => sineCosine
	);	
	process(aclk, mode4)begin
	   if(mode4 = '1') then
	       ACCEL_X <= MOUSE_X;
	   else
	       ACCEL_X <= ACCEL_Xs;
	   end if;
	end process;
    
    process(aclk, mode3, mode4, ACCEL_X) begin
        if (mode3 = '0' and mode4 = '0') then
            newData <= "1001101110000000";
        --elsif(mode4 = '0') then
          --  newData <= "1001101110000000";
        elsif((ACCEL_X <= "11111101" and ACCEL_X > "11111010") and (mode3 = '1' or mode4 ='1')) then --FD/FB
            newData <= "1001101110000000";
        elsif(((ACCEL_X <= "11111010" and ACCEL_X > "11110000") or ACCEL_X = "11111111" or ACCEL_X= "11111110" or (ACCEL_X >= "00000000" and ACCEL_X < "00001011")) and (mode3 = '1' or mode4 ='1')) then--FB/F0 - 00/0B
           newData <= "1001101110000011"; --1
        elsif(((ACCEL_X <= "11110000" and ACCEL_X > "11100000") or (ACCEL_X >= "00001011" and ACCEL_X < "00011000")) and (mode3 = '1' or mode4 ='1')) then--F0/E0 - 0B/18
           newData <= "1001101110000111";--2
        elsif(((ACCEL_X <= "11100000" and ACCEL_X > "11010000") or (ACCEL_X >= "00011000" and ACCEL_X < "00101000")) and (mode3 = '1' or mode4 ='1')) then--E0/D0 - 18/28
             --newData <= "1001101111100110";
             newData <= "1001101110001110";--3
        elsif(((ACCEL_X <= "11010000" and ACCEL_X > "11000000") or (ACCEL_X >= "00101000" and ACCEL_X < "00111000")) and (mode3 = '1' or mode4 ='1')) then--D0/C0 - 28/38
             newData <= "1001101110011100";--4
        elsif(((ACCEL_X <= "11000000" and ACCEL_X > "10111011") or (ACCEL_X >= "00111000" and ACCEL_X < "00111100")) and (mode3 = '1' or mode4 ='1')) then--C0/BB - 38/3C
            newData <= "1001101111100110";--5
        else
            newData <= "1001111111110000";
        end if;
        
    end process;
-- pi 0110010010000000
-- negative pi 100110111000
    process (aclk) begin
        if(clearFlag = '1' or modeChanged = '1' or Fflag = '1') then
            dataIn <="0000000000000000";
        elsif(dataIn = "0110010010000000") then
            dataIn <= newData;
        elsif(rising_edge(aclk)) then
            dataIn <= dataIn + "0000000000000001";
            sineOut <= (sineCosine(15 downto 8) + "01100000") - down + up;
        end if;
    end process;
end Behavioral;
