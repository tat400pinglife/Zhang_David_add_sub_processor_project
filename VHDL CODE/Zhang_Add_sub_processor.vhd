library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.Zhang_David_add_sub_ALU_pkg.all;
use work.Zhang_David_registers_pkg.all;


entity Zhang_Add_Sub_Processor is
    Port (
        clk               : in  STD_LOGIC;
        instruction_input : in  STD_LOGIC_VECTOR(31 downto 0);
        result            : out STD_LOGIC_VECTOR(31 downto 0);
		  overflow			  : out STD_LOGIC;
		  operand1			  : out STD_LOGIC_VECTOR(31 downto 0);
		  operand2			  : out STD_LOGIC_VECTOR(31 downto 0)
    );
end Zhang_Add_Sub_Processor;

architecture Structural of Zhang_Add_Sub_Processor is
    
    signal instruction     : STD_LOGIC_VECTOR(31 downto 0);
    signal opcode          : STD_LOGIC_VECTOR(5 downto 0);
    signal rs, rt, rd      : STD_LOGIC_VECTOR(4 downto 0); -- rs is first register, rt is second, rd destination
    signal shamt           : STD_LOGIC_VECTOR(4 downto 0); -- not used
    signal busA, busB, busW: STD_LOGIC_VECTOR(31 downto 0);
    signal funct_control   : STD_LOGIC_VECTOR(1 downto 0);
    signal r_type           : STD_LOGIC;
	 signal overflow_sig			: STD_LOGIC;
	 signal operand1_sig			: STD_LOGIC_VECTOR(31 downto 0);
	 signal operand2_sig			: STD_LOGIC_VECTOR(31 downto 0);
    
begin
    -- Instruction Register instantiation
    INSTR_REG: Instruction_Register
    port map (
        clk             => clk,
        instruction_in  => instruction_input,
        instruction_out => instruction
    );
    
    -- Instruction Decoder instantiation
    DECODER: Instruction_Decoder
    port map (
        instruction   => instruction,
        opcode        => opcode,
        rs            => rs,
        rt            => rt,
        rd            => rd,
        shamt         => shamt,
        funct_control => funct_control,
        r_type        => r_type
    );
    
    -- Register File instantiation
    REG_FILE: Register_File
    port map (
        clk      => clk,
        Ra       => rs,
        Rb       => rt,
        Rw       => rd,
        busW     => busW,
        enable   => r_type,
        busA     => busA,
        busB     => busB
    );
    
    -- ALU instantiation
    ALU_UNIT: ALU
    port map (
        A     => busA,
        B     => busB,
        funct_control   => funct_control,
        result   => busW,
		  overflow => overflow_sig, -- maybe just put overflow here
		  operand1 => operand1_sig,
		  operand2 => operand2_sig
    );
    
    -- Output the result
	 operand1 <= operand1_sig;
	 operand2 <= operand2_sig;
    result <= busW;
	 overflow <= overflow_sig;
    
end Structural;