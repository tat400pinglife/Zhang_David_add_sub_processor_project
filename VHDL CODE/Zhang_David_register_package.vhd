library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package Zhang_David_registers_pkg is
    component Instruction_Register is
        Port (
            clk             : in  STD_LOGIC;
            instruction_in  : in  STD_LOGIC_VECTOR(31 downto 0);
            instruction_out : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;
    
    component Instruction_Decoder is
        Port (
            instruction  : in  STD_LOGIC_VECTOR(31 downto 0);
            opcode       : out STD_LOGIC_VECTOR(5 downto 0);
            rs           : out STD_LOGIC_VECTOR(4 downto 0);
            rt           : out STD_LOGIC_VECTOR(4 downto 0);
            rd           : out STD_LOGIC_VECTOR(4 downto 0);
            shamt        : out STD_LOGIC_VECTOR(4 downto 0);
            funct_control: out STD_LOGIC_VECTOR(1 downto 0);
            r_type       : out STD_LOGIC
        );
    end component;
    
    component Register_File is
        Port (
            clk      : in  STD_LOGIC;
            Ra       : in  STD_LOGIC_VECTOR(4 downto 0);
            Rb       : in  STD_LOGIC_VECTOR(4 downto 0);
            Rw       : in  STD_LOGIC_VECTOR(4 downto 0);
            busW     : in  STD_LOGIC_VECTOR(31 downto 0);
            enable   : in  STD_LOGIC;
            busA     : out STD_LOGIC_VECTOR(31 downto 0);
            busB     : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;

end package;