library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Add_Sub_Processor_TB is
end Add_Sub_Processor_TB;

architecture Behavioral of Add_Sub_Processor_TB is
    component Zhang_Add_Sub_Processor is
        Port (
            clk               : in  STD_LOGIC;
            instruction_input : in  STD_LOGIC_VECTOR(31 downto 0);
            result            : out STD_LOGIC_VECTOR(31 downto 0);
            overflow          : out STD_LOGIC;
			operand1				: out STD_LOGIC_VECTOR(31 downto 0);
			operand2				: out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;
    
    constant CLK_PERIOD : time := 10 ps;

    signal clk : STD_LOGIC := '0';
    signal instruction_input : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal result : STD_LOGIC_VECTOR(31 downto 0);
    signal overflow : STD_LOGIC;
    signal operand1 : STD_LOGIC_VECTOR(31 downto 0);
    signal operand2 : STD_LOGIC_VECTOR(31 downto 0); 

    -- For visual, I forget the codes
    constant FUNCT_ADD  : STD_LOGIC_VECTOR(5 downto 0) := "100000"; -- 0x20
    constant FUNCT_ADDU : STD_LOGIC_VECTOR(5 downto 0) := "100001"; -- 0x21
    constant FUNCT_SUB  : STD_LOGIC_VECTOR(5 downto 0) := "100010"; -- 0x22
    constant FUNCT_SUBU : STD_LOGIC_VECTOR(5 downto 0) := "100011"; -- 0x23
    
begin
    UUT: Zhang_Add_Sub_Processor port map (
        clk => clk,
        instruction_input => instruction_input,
        result => result,
        overflow => overflow,
		  operand1 => operand1,
		  operand2 => operand2
    );


    CLK_CYCLE: process
    begin
        clk <= '0';
        wait for CLK_PERIOD/2;
        clk <= '1';
        wait for CLK_PERIOD/2;
    end process;
    
STIM_PROC: process
begin
    -- initialization
    wait for CLK_PERIOD*2;
    
    
    -- Case 1: add $9, $1, $2    (1 + 2 = 3, NO OVERFLOW)
    -- 000000 00001 00010 01001 00000 100000
    instruction_input <= "00000000001000100100100000100000";
    wait for CLK_PERIOD*2;
    
    -- Case 2: add $10, $4, $1    (MAX_INT + 1, OVERFLOW)
    -- 000000 00100 00001 01010 00000 100000
    -- This will overflow because 0x7FFFFFFF + 1 = 0x80000000 (positive + positive = negative)
    instruction_input <= "00000000100000010101000000100000";
    wait for CLK_PERIOD*2;
    
    -- Case 3: addu $11, $1, $2    (1 + 2 = 3, NO OVERFLOW IN UNSIGNED)
    -- 000000 00001 00010 01011 00000 100001
    instruction_input <= "00000000001000100101100000100001";
    wait for CLK_PERIOD*2;
    
    -- Case 4: addu $12, $3, $1   (MAX_INT + 1, would OVERFLOW in unsigned operations)
    -- 000000 00011 00001 01100 00000 100001
    -- Note: addu does not detect overflow, result will be 0x00000000
    instruction_input <= "00000000011000010110000000100001";
    wait for CLK_PERIOD*2;
    
    -- Case 5: sub $13, $8, $6    (10 - 5 = 5, NO OVERFLOW)
    -- 000000 00100 00110 01101 00000 100010
    instruction_input <= "00000000100001100110100000100010";
    wait for CLK_PERIOD*2;
    
    -- Case 6: sub $14, $5, $1    (MIN_INT - 1, OVERFLOW)
    -- 000000 00101 00001 01110 00000 100010
    -- This will overflow because 0x80000000 - 1 = 0x7FFFFFFF (negative - positive = positive)
    instruction_input <= "00000000101000010111000000100010";
    wait for CLK_PERIOD*2;
    
    -- Case 7: subu $15, $8, $6    (10 - 5 = 5, NO OVERFLOW IN UNSIGNED)
    -- 000000 00100 00110 01111 00000 100010
    -- Note: subu does not detect overflow, but this operation wouldn't overflow anyway
    instruction_input <= "00000000100001100111100000100010";
    wait for CLK_PERIOD*2;
    
    -- Case 8: subu $16, $7, $1    (MIN_INT - 1, would OVERFLOW in signed operations)
    -- 000000 00111 00001 10000 00000 100011
    -- Note: subu does not detect overflow, result will be 0x7FFFFFFF
    instruction_input <= "00000000100001010111000000100011";
    wait for CLK_PERIOD*2;
	 
	 wait;
	 end process;
	 
end Behavioral;