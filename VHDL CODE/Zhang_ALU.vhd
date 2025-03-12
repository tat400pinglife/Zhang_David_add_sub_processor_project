library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALU is
    Port (
        A : in STD_LOGIC_VECTOR(31 downto 0);  -- First operand (busA)
        B : in STD_LOGIC_VECTOR(31 downto 0);  -- Second operand (busB)
        funct_control : in STD_LOGIC_VECTOR(1 downto 0); -- 
        Result : out STD_LOGIC_VECTOR(31 downto 0);
        Overflow : out STD_LOGIC;
		  operand1: out STD_LOGIC_VECTOR(31 downto 0);
		  operand2: out STD_LOGIC_VECTOR(31 downto 0)
    );
end ALU;

architecture Structural of ALU is
    -- Component declaration
    component OneBitALU
        Port (
            A     : in  STD_LOGIC;
            B     : in  STD_LOGIC;
            Cin   : in  STD_LOGIC;
            BInvert : in STD_LOGIC;
            Operation : in STD_LOGIC;
            Sum   : out STD_LOGIC;
            Cout  : out STD_LOGIC
        );
    end component;
    
    -- Internal signals
    signal carry : STD_LOGIC_VECTOR(32 downto 0); -- 33 bits for carry chain
    signal result_internal : STD_LOGIC_VECTOR(31 downto 0);
    signal b_invert : STD_LOGIC; -- 0 for add, 1 for subtract
    signal operation_type : STD_LOGIC; -- 00: signed, 01: unsigned
	 signal carry_operand1 : STD_LOGIC_VECTOR(31 downto 0);
	 signal carry_operand2 : STD_LOGIC_VECTOR(31 downto 0);
    
begin
    with funct_control select
        b_invert <= '1' when "01", -- SUB (signed sub)
                    '1' when "11", -- SUBU (unsigned sub)
                    '0' when others; -- since 0 is add in this case
                    
    with funct_control select
        operation_type <= '0' when "00", -- ADD (signed)
                          '0' when "01", -- SUB (signed)
								  '1' when others; -- For overflow control
    
	 -- needed for two-s complement since invert and then add 1
    carry(0) <= b_invert;
    
    -- Generate 32 one-bit ALUs to create the 32-bit ALU
    ALU_GEN: for i in 0 to 31 generate
        BIT_ALU: OneBitALU
        port map (
            A => A(i),
            B => B(i),
            Cin => carry(i),
            BInvert => b_invert,
            Operation => operation_type,
            Sum => result_internal(i),
            Cout => carry(i+1)
        );
    end generate;
	 carry_operand1 <= A;
	 carry_operand2 <= B;
    
    -- Connect result
    Result <= result_internal;
    
	 operand1 <= carry_operand1;
	 operand2 <= carry_operand2;
    -- Overflow detection logic
    -- For signed operations: overflow occurs when carry-in to MSB != carry-out from MSB
    -- For unsigned operations: overflow is simply the final carry-out
    Overflow <= (carry(31) xor carry(32)) when operation_type = '0' else -- Signed
                '0'; -- unsigned does not throw any overflow
    
end Structural;