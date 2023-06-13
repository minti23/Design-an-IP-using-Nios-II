library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity transform_complex is
generic (width: integer:=16);
port(
		A_re : in std_logic_vector(width-1 downto 0);
		A_ig : in std_logic_vector(width-1 downto 0);
		B_re: out std_logic_vector(width-1 downto 0);
		B_ig: out std_logic_vector(width-1 downto 0)
	);
end entity;

architecture dataflow of transform_complex is 
signal A_real    : std_logic_vector(15 downto 0);
signal A_im      : std_logic_vector(15 downto 0);
signal A_im_temp : std_logic_vector(15 downto 0);

begin
	A_im_temp <= not (A_re) + "0000000000000001";
		process (A_im, A_real)
			begin
				A_im   <= A_im_temp;
				A_real <= A_ig;
		end process;
	B_ig  <= A_im;
	B_re  <= A_real;
end dataflow;