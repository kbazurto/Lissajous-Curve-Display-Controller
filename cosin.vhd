----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.10.2017 18:43:22
-- Design Name: 
-- Module Name: cosin - Behavioral
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

entity cosin is
    Port ( aclk : in STD_LOGIC;
           enableInput : in STD_LOGIC;
           enableOutput : out STD_LOGIC;
           left : in STD_LOGIC_VECTOR(7 DOWNTO 0);
           right : in STD_LOGIC_VECTOR(7 DOWNTO 0);
           cosineOut : out STD_LOGIC_VECTOR(7 DOWNTO 0);
           clearFlag : in STD_LOGIC;
           Fflag : in STD_LOGIC;
           modeChanged : in STD_LOGIC
    );
end cosin;

architecture Behavioral of cosin is
component cordic_0 port (
		aclk : IN STD_LOGIC;
        s_axis_phase_tvalid : IN STD_LOGIC;
        s_axis_phase_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        m_axis_dout_tvalid : OUT STD_LOGIC;
        m_axis_dout_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	); end component;
	
	signal sineCosine: std_logic_vector(15 downto 0):="0000000000000000";
	signal dataIn : std_logic_vector(15 downto 0):="0000000000000000";
begin

    u1 : cordic_0 port map (
		aclk => aclk,
		s_axis_phase_tvalid => enableInput,
		s_axis_phase_tdata => dataIn,
		m_axis_dout_tvalid => enableOutput,
		m_axis_dout_tdata => sineCosine
	);	

-- pi 0110010010000000
-- negative pi 100110111000
    process (aclk) begin
        if(clearFlag = '1' or modeChanged = '1' or Fflag = '1') then
                dataIn <="0000000000000000";
        elsif(dataIn = "0110010010000000" ) then
            dataIn <= "1001101110000000";
        elsif(rising_edge(aclk)) then
            dataIn <= dataIn + "0000000000000001";
            cosineOut <= (sineCosine(7 downto 0) + "01100000")- left + right;
        end if;
    end process;

end Behavioral;
