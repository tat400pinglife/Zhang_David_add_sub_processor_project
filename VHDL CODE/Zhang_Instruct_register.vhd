library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Instruction_Register is
    Port (
        clk          : in  STD_LOGIC;
        instruction_in  : in  STD_LOGIC_VECTOR(31 downto 0);
        instruction_out : out STD_LOGIC_VECTOR(31 downto 0)
    );
end Instruction_Register;

architecture Behavioral of Instruction_Register is
begin
    -- Store the instruction during execution time
    process(clk)
    begin
        if rising_edge(clk) then
            instruction_out <= instruction_in;
        end if;
    end process;
end Behavioral;