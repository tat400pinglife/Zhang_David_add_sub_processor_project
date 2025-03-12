library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity OneBitALU is
    Port (
        A     : in  STD_LOGIC;  -- First input bit
        B     : in  STD_LOGIC;  -- Second input bit
        Cin   : in  STD_LOGIC;  -- Carry in
        BInvert : in STD_LOGIC; -- Invert B (0: add, 1: subtract)
        Operation : in STD_LOGIC; -- 0: signed, 1: unsigned
        Sum   : out STD_LOGIC;  -- Sum/Difference output
        Cout  : out STD_LOGIC   -- Carry out
    );
end OneBitALU;

architecture Structural of OneBitALU is
    component FullAdder
        Port (
            A     : in  STD_LOGIC;
            B     : in  STD_LOGIC;
            Cin   : in  STD_LOGIC;
            Sum   : out STD_LOGIC;
            Cout  : out STD_LOGIC
        );
    end component;
    
    signal b_input : STD_LOGIC; -- B or not B based on BInvert
    
begin
    -- B input logic - invert for subtraction
    b_input <= B xor BInvert;
    
    FA: FullAdder
    port map (
        A => A,
        B => b_input,
        Cin => Cin,
        Sum => Sum,
        Cout => Cout
    );
    
end Structural;