library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity fft4p is
generic (width: integer:=16);
port(
		clk      : in std_logic;
		rst      : in std_logic;
		start    : in std_logic;
		x0_in_re : in std_logic_vector(width-1 downto 0);
		x0_in_ig : in std_logic_vector(width-1 downto 0);
		x1_in_re : in std_logic_vector(width-1 downto 0);
		x1_in_ig : in std_logic_vector(width-1 downto 0);
		x2_in_re : in std_logic_vector(width-1 downto 0);
		x2_in_ig : in std_logic_vector(width-1 downto 0);
		x3_in_re : in std_logic_vector(Width-1 downto 0);
		x3_in_ig : in std_logic_vector(width-1 downto 0);
		
		X0_out_re: out std_logic_vector(width-1 downto 0);
		X0_out_ig: out std_logic_vector(width-1 downto 0);
		X1_out_re: out std_logic_vector(width-1 downto 0);
		X1_out_ig: out std_logic_vector(width-1 downto 0);
		X2_out_re: out std_logic_vector(width-1 downto 0);
		X2_out_ig: out std_logic_vector(width-1 downto 0);
		X3_out_re: out std_logic_vector(width-1 downto 0);
		X3_out_ig: out std_logic_vector(width-1 downto 0);
		done     : out std_logic
);
end entity;

architecture struct of fft4p is 

component adder is
generic (width: integer:=16);
port(
   	A : in std_logic_vector(width-1 downto 0);
		B : in std_logic_vector(width-1 downto 0);
		S : out std_logic_vector(width-1 downto 0);
		Co: out std_logic
);
end component;

component subtractor is
generic (width: integer:=16);
port(
   	A : in std_logic_vector(width-1 downto 0);
		B : in std_logic_vector(width-1 downto 0);
		S : out std_logic_vector(width-1 downto 0);
		Co: out std_logic
);
end component;

component transform_complex is
generic (width: integer:=16);
port(
		A_re : in std_logic_vector(width-1 downto 0);
		A_ig : in std_logic_vector(width-1 downto 0);
		B_re: out std_logic_vector(width-1 downto 0);
		B_ig: out std_logic_vector(width-1 downto 0)
	);
end component;

signal X02_sum_re     : std_logic_vector(width-1 downto 0);
signal X02_sum_ig     : std_logic_vector(width-1 downto 0);
signal X02_sub_re     : std_logic_vector(width-1 downto 0);
signal X02_sub_ig     : std_logic_vector(width-1 downto 0);
signal X13_sum_re     : std_logic_vector(width-1 downto 0);
signal X13_sum_ig     : std_logic_vector(width-1 downto 0);
signal X13_sub_re     : std_logic_vector(width-1 downto 0);
signal X13_sub_ig     : std_logic_vector(width-1 downto 0);
signal X13_subafter_re: std_logic_vector(width-1 downto 0);
signal X13_subafter_ig: std_logic_vector(width-1 downto 0);

signal X0_out_temp_re : std_logic_vector(width-1 downto 0);
signal X1_out_temp_re : std_logic_vector(width-1 downto 0);
signal X2_out_temp_re : std_logic_vector(width-1 downto 0);
signal X3_out_temp_re : std_logic_vector(width-1 downto 0);
signal X0_out_temp_ig : std_logic_vector(width-1 downto 0);
signal X1_out_temp_ig : std_logic_vector(width-1 downto 0);
signal X2_out_temp_ig : std_logic_vector(width-1 downto 0);
signal X3_out_temp_ig : std_logic_vector(width-1 downto 0);

begin
---- 1st floor ----
u0: adder port map(x0_in_re,x2_in_re,X02_sum_re); 	--real part--
u1: adder port map(x0_in_ig,x2_in_ig,X02_sum_ig);  --imaginary part--

u2: subtractor port map(x0_in_re,x2_in_re,X02_sub_re);
u3: subtractor port map(x0_in_ig,x2_in_ig,X02_sub_ig);

u4: adder port map(x1_in_re,x3_in_re,X13_sum_re);
u5: adder port map(x1_in_ig,x3_in_ig,X13_sum_ig);

u6: subtractor port map(x1_in_re,x3_in_re,X13_sub_re);
u7: subtractor port map(x1_in_ig,x3_in_ig,X13_sub_ig);

u8: transform_complex port map(X13_sub_re, X13_sub_ig, X13_subafter_re, X13_subafter_ig);

----2nd floor----
u9:  adder port map(X02_sum_re,X13_sum_re,X0_out_temp_re);
u10: adder port map(X02_sum_ig,X13_sum_ig,X0_out_temp_ig);

u13: adder port map(X02_sub_re,X13_subafter_re,X1_out_temp_re);
u14: adder port map(X02_sub_ig,X13_subafter_ig,X1_out_temp_ig);

u11: subtractor port map(X02_sum_re,X13_sum_re,X2_out_temp_re);
u12: subtractor port map(X02_sum_ig,X13_sum_ig,X2_out_temp_ig);

u15: subtractor port map(X02_sub_re,X13_subafter_re,X3_out_temp_re);
u16: subtractor port map(X02_sub_ig,X13_subafter_ig,X3_out_temp_ig);

process(start,clk,rst,x0_in_re,x0_in_ig,x1_in_re,x1_in_ig,x2_in_re,x2_in_ig,x3_in_re,x3_in_ig)
	begin
	if (rising_edge (clk)) then
		if (rst = '1') then
			 X0_out_re <= (others => '0');
			 X1_out_re <= (others => '0');
			 X2_out_re <= (others => '0');
			 X3_out_re <= (others => '0');
			 X0_out_ig <= (others => '0');
			 X1_out_ig <= (others => '0');
			 X2_out_ig <= (others => '0');
			 X3_out_ig <= (others => '0');
	
			done <= '0';
		else
			if (start = '1') then
				 X0_out_re <= X0_out_temp_re;
				 X1_out_re <= X1_out_temp_re;
				 X2_out_re <= X2_out_temp_re;
				 X3_out_re <= X3_out_temp_re;
				 X0_out_ig <= X0_out_temp_ig;
				 X1_out_ig <= X1_out_temp_ig;
				 X2_out_ig <= X2_out_temp_ig;
				 X3_out_ig <= X3_out_temp_ig;
				
				 done <= '1';
			end if;
		end if;
	end if;
end process;

end struct;
----------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity adder is
generic (width: integer:=16);
port(
		A: in std_logic_vector(width-1 downto 0);
		B: in std_logic_vector(width-1 downto 0);
		S: out std_logic_vector(width-1 downto 0);
		Co: out std_logic
);
end entity;

architecture dataflow of adder is 
signal temp: std_logic_vector(width downto 0);
begin
		temp <= ('0' & A) + ('0' & B);
		S    <= temp(width-1 downto 0);
		Co   <= temp(width);
end dataflow;
----------------------------------------------
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
---------------------------------------------
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

