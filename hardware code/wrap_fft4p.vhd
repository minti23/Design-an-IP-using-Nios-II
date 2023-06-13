library ieee;
use ieee.std_logic_1164.all;

entity wrap_fft4p is
generic (width: integer:=16);
port(
   clk       : in std_logic;
	rst       : in std_logic;
	write_n   : in std_logic;
	chipselect: in std_logic;
   address   : in std_logic_vector(4 downto 0);
	writedata : in std_logic_vector(width-1 downto 0);
	readdata  : out std_logic_vector(width-1 downto 0)
);
end entity;

architecture dataflow of wrap_fft4p is
component fft4p is
generic (width: integer:=16);
port(
   clk  : in std_logic;
	rst  : in std_logic;
	start: in std_logic;

   	x0_in_re:  in std_logic_vector(width-1 downto 0);
	x0_in_ig:  in std_logic_vector(width-1 downto 0);
	x1_in_re:  in std_logic_vector(width-1 downto 0);
	x1_in_ig:  in std_logic_vector(width-1 downto 0);
	x2_in_re:  in std_logic_vector(width-1 downto 0);
	x2_in_ig:  in std_logic_vector(width-1 downto 0);
	x3_in_re:  in std_logic_vector(width-1 downto 0);
	x3_in_ig:  in std_logic_vector(width-1 downto 0);
	

	X0_out_re: out std_logic_vector(width-1 downto 0);
	X0_out_ig: out std_logic_vector(width-1 downto 0);
	X1_out_re: out std_logic_vector(width-1 downto 0);
	X1_out_ig: out std_logic_vector(width-1 downto 0);
	X2_out_re: out std_logic_vector(width-1 downto 0);
	X2_out_ig: out std_logic_vector(width-1 downto 0);
	X3_out_re: out std_logic_vector(width-1 downto 0);
	X3_out_ig: out std_logic_vector(width-1 downto 0);

	done: out std_logic
);
end component;

signal wr_en    :  std_logic := '0';
signal rd_en    :  std_logic := '0';

signal wr_start :  std_logic := '0';
signal wr_x0_in_re :  std_logic := '0';
signal wr_x0_in_ig :  std_logic := '0';
signal wr_x1_in_re :  std_logic := '0';
signal wr_x1_in_ig :  std_logic := '0';
signal wr_x2_in_re :  std_logic := '0';
signal wr_x2_in_ig :  std_logic := '0';
signal wr_x3_in_re :  std_logic := '0';
signal wr_x3_in_ig :  std_logic := '0';

---- Reg xin ----
signal x0_in_re_reg : std_logic_vector (width-1 downto 0) := (others => '0'); 
signal x0_in_ig_reg : std_logic_vector (width-1 downto 0) := (others => '0'); 
signal x1_in_re_reg : std_logic_vector (width-1 downto 0) := (others => '0');
signal x1_in_ig_reg : std_logic_vector (width-1 downto 0) := (others => '0');
signal x2_in_re_reg : std_logic_vector (width-1 downto 0) := (others => '0'); 
signal x2_in_ig_reg : std_logic_vector (width-1 downto 0) := (others => '0'); 
signal x3_in_re_reg : std_logic_vector (width-1 downto 0) := (others => '0');
signal x3_in_ig_reg : std_logic_vector (width-1 downto 0) := (others => '0');

---- Reg Xout ----
signal X0_out_re_reg: std_logic_vector (width-1 downto 0) := (others => '0');
signal X0_out_ig_reg: std_logic_vector (width-1 downto 0) := (others => '0');
signal X1_out_re_reg: std_logic_vector (width-1 downto 0) := (others => '0');
signal X1_out_ig_reg: std_logic_vector (width-1 downto 0) := (others => '0');
signal X2_out_re_reg: std_logic_vector (width-1 downto 0) := (others => '0');
signal X2_out_ig_reg: std_logic_vector (width-1 downto 0) := (others => '0');
signal X3_out_re_reg: std_logic_vector (width-1 downto 0) := (others => '0');
signal X3_out_ig_reg: std_logic_vector (width-1 downto 0) := (others => '0');

signal done_tick    : std_logic := '0';
signal set_done_tick: std_logic := '0';
signal clr_done_tick: std_logic := '0';

begin
stage0: fft4p port map(clk=>clk, rst=>rst, start=>wr_start,
							  x0_in_re => x0_in_re_reg, x0_in_ig => x0_in_ig_reg,
							  x1_in_re => x1_in_re_reg, x1_in_ig => x1_in_ig_reg,
						        	  x2_in_re => x2_in_re_reg, x2_in_ig => x2_in_ig_reg,
							  x3_in_re => x3_in_re_reg, x3_in_ig => x3_in_ig_reg,							
		                 				  X0_out_re => X0_out_re_reg, X0_out_ig => X0_out_ig_reg, 
							  X1_out_re => X1_out_re_reg, X1_out_ig => X1_out_ig_reg, 
							  X2_out_re => X2_out_re_reg, X2_out_ig => X2_out_ig_reg, 
							  X3_out_re => X3_out_re_reg, X3_out_ig => X3_out_ig_reg, 							
							  done => set_done_tick);

process (clk,rst)
begin
	if (rst = '1') then
		x0_in_re_reg <= (others => '0');
		x0_in_ig_reg <= (others => '0');
		x1_in_re_reg <= (others => '0');
		x1_in_ig_reg <= (others => '0');
		x2_in_re_reg <= (others => '0');
		x2_in_ig_reg <= (others => '0');
		x3_in_re_reg <= (others => '0');
		x3_in_ig_reg <= (others => '0');
		done_tick <= '0';
	elsif (rising_edge(clk)) then
			if (wr_x0_in_re = '1') then
			x0_in_re_reg <= writedata(width-1 downto 0);	
		elsif (wr_x0_in_ig = '1') then
			x0_in_ig_reg <= writedata(width-1 downto 0);
		elsif (wr_x1_in_re = '1') then
			x1_in_re_reg <= writedata(width-1 downto 0);	
		elsif (wr_x1_in_ig = '1') then
			x1_in_ig_reg <= writedata(width-1 downto 0);			
		elsif (wr_x2_in_re = '1') then
			x2_in_re_reg <= writedata(width-1 downto 0);			
		elsif (wr_x2_in_ig = '1') then
			x2_in_ig_reg <= writedata(width-1 downto 0);			
		elsif (wr_x3_in_re = '1') then
			x3_in_re_reg <= writedata(width-1 downto 0);			
		elsif (wr_x3_in_ig = '1') then
			x3_in_ig_reg <= writedata(width-1 downto 0);
		end if;	
		if (set_done_tick = '1') then
			done_tick <= '1';
		elsif (clr_done_tick = '1') then
			done_tick <= '0';
		end if;
	end if;
end process;

---- Write decoding logic ----
wr_en <= '1' when write_n = '0' and chipselect = '1' else '0';	--check write & CS in write phase--	

wr_x0_in_re   <= '1' when address = "00000" and wr_en = '1' else '0';
wr_x0_in_ig   <= '1' when address = "00001" and wr_en = '1' else '0';
wr_x1_in_re   <= '1' when address = "00010" and wr_en = '1' else '0';
wr_x1_in_ig   <= '1' when address = "00011" and wr_en = '1' else '0';
wr_x2_in_re   <= '1' when address = "00100" and wr_en = '1' else '0';
wr_x2_in_ig   <= '1' when address = "00101" and wr_en = '1' else '0';
wr_x3_in_re   <= '1' when address = "00110" and wr_en = '1' else '0';
wr_x3_in_ig   <= '1' when address = "00111" and wr_en = '1' else '0';
wr_start      <= '1' when address = "01000" and wr_en = '1' else '0';	--0x08--
clr_done_tick <= '1' when address = "10001" and wr_en = '1' else '0';	--0x11--

---- Read decoding logic ----
rd_en <= '1' when write_n = '1' and chipselect = '1' else '0';	--check write & CS in read phase--

readdata <= x0_in_re_reg  when address = "00000" and rd_en = '1' else   --0x00--
				x0_in_ig_reg  when address = "00001" and rd_en = '1' else	--0x01--
				x1_in_re_reg  when address = "00010" and rd_en = '1' else	--0x02--
				x1_in_ig_reg  when address = "00011" and rd_en = '1' else 	--0x03--
				x2_in_re_reg  when address = "00100" and rd_en = '1' else	--0x04--
				x2_in_ig_reg  when address = "00101" and rd_en = '1' else	--0x05--
				x3_in_re_reg  when address = "00110" and rd_en = '1' else	--0x06--
				x3_in_ig_reg  when address = "00111" and rd_en = '1' else 	--0x07--
				
				X0_out_re_reg when address = "01001" and rd_en = '1' else	--0x09-- 
				X0_out_ig_reg when address = "01010" and rd_en = '1' else 	--0x0A--
				X1_out_re_reg when address = "01011" and rd_en = '1' else 	--0x0B--
				X1_out_ig_reg when address = "01100" and rd_en = '1' else 	--0x0C--
				X2_out_re_reg when address = "01101" and rd_en = '1' else 	--0x0D--
				X2_out_ig_reg when address = "01110" and rd_en = '1' else 	--0x0E--
				X3_out_re_reg when address = "01111" and rd_en = '1' else 	--0x0F--
				X3_out_ig_reg when address = "10000" and rd_en = '1' else 	--0x10--
		
			  (0 => done_tick, others => '0') when address = "10001" and rd_en = '1' else
			  (others => '0');

end dataflow;
