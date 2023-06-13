library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity subtractor is
generic (width: integer:=16);
port(
   	A : in std_logic_vector(width-1 downto 0);
		B : in std_logic_vector(width-1 downto 0);
		S : out std_logic_vector(width-1 downto 0);
		Co: out std_logic
	);
end entity;

architecture dataflow of subtractor is 
signal temp: std_logic_vector(width downto 0);
begin
		temp <= ('0' & A) - ('0' & B);
		S    <= temp(width-1 downto 0);
		Co   <= temp(width);
end dataflow;