library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package Zhang_David_add_sub_ALU_pkg is
	 component ALU is
    Port (
        A : in STD_LOGIC_VECTOR(31 downto 0);
        B : in STD_LOGIC_VECTOR(31 downto 0); 
        funct_control : in STD_LOGIC_VECTOR(1 downto 0);
        Result : out STD_LOGIC_VECTOR(31 downto 0);
        Overflow : out STD_LOGIC;
		  operand1: out STD_LOGIC_VECTOR(31 downto 0);
		  operand2: out STD_LOGIC_VECTOR(31 downto 0)  
    );
	end component;

end package;