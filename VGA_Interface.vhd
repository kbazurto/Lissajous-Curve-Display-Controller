----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2017/10/24 15:49:17
-- Design Name: 
-- Module Name: VGA_Interface - Behavioral
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
Library IEEE;
use IEEE.STD_Logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity VGA_Interface is
  port( clk : in std_logic;  -- 25.175 Mhz clock
        row : out std_logic_vector(9 downto 0);
        column : out std_logic_vector(9 downto 0);
        Hsync : out std_logic;
        Vsync : out std_logic);
end;

architecture behaviour1 of VGA_Interface is
  subtype counter is std_logic_vector(9 downto 0);
 constant blank : natural := 93; 
  constant guard : natural := 45; 
  constant columns : natural := 640;
  constant rear: natural := 22; 
  constant horizontalCycle : natural := blank + guard + columns + rear;
  constant vBlank : natural := 2;
  constant fGuard : natural := 32;
  constant rows : natural := 480;
  constant rGuard : natural := 11;
  constant vCycle : natural := vBlank + fGuard + rows + rGuard;
   
begin

  --rvga <= red;
  --gvga <= green;
  --bvga <= blue;

  process
    variable vertical, horizontal : counter;
  begin
    wait until clk = '1';
      if  (horizontal < horizontalCycle - 1)  then
        horizontal := horizontal + 1;
      else
        horizontal := (others => '0');

        if  (vertical < vCycle - 1)  then
          vertical := vertical + 1;
        else
          vertical := (others => '0');
        end if;
      end if;

  -- define H pulse
      if  (horizontal >= (columns + rear)  and  horizontal < (columns + rear + blank) ) then
        Hsync <= '0';
      else
        Hsync <= '1';
      end if;

  -- define V pulse
      if  (vertical >= (rows + rGuard)  and  vertical < (rows + rGuard + vBlank)  )then
        Vsync <= '0';
      else
        Vsync <= '1';
      end if;

    row <= vertical;
    column <= horizontal;

  end process;
end architecture;

