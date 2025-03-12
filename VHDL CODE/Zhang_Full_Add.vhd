library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FullAdder is
    Port (
        A     : in  STD_LOGIC;  -- First input bit
        B     : in  STD_LOGIC;  -- Second input bit
        Cin   : in  STD_LOGIC;  -- Carry in
        Sum   : out STD_LOGIC;  -- Sum output
        Cout  : out STD_LOGIC   -- Carry out
    );
end FullAdder;

architecture Behavioral of FullAdder is
begin
    -- Full adder logic
    Sum  <= A xor B xor Cin;
    Cout <= (A and B) or (Cin and (A xor B));
end Behavioral;