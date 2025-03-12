library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Instruction_Decoder is
    Port (
        instruction  : in  STD_LOGIC_VECTOR(31 downto 0);
        opcode       : out STD_LOGIC_VECTOR(5 downto 0);
        rs           : out STD_LOGIC_VECTOR(4 downto 0);
        rt           : out STD_LOGIC_VECTOR(4 downto 0);
        rd           : out STD_LOGIC_VECTOR(4 downto 0);
        shamt        : out STD_LOGIC_VECTOR(4 downto 0);
        funct_control: out STD_LOGIC_VECTOR(1 downto 0); -- Prepare signal to be sent to ALU
        r_type       : out STD_LOGIC  -- for r-type confirmation
    );
end Instruction_Decoder;

architecture Behavioral of Instruction_Decoder is
    signal opcode_internal : STD_LOGIC_VECTOR(5 downto 0);
    signal funct_internal  : STD_LOGIC_VECTOR(5 downto 0);
begin
    opcode_internal <= instruction(31 downto 26); -- should be all 0 for r-tpye
    rs <= instruction(25 downto 21);
    rt <= instruction(20 downto 16);
    rd <= instruction(15 downto 11);
    shamt <= instruction(10 downto 6); -- don't think we are using this currently
    funct_internal <= instruction(5 downto 0); -- code for operation 

	 
    opcode <= opcode_internal;
    

    process(opcode_internal, funct_internal)
    begin
        -- Default values
        r_type <= '0';
        funct_control <= "00";
        
        -- For R-type instructions (opcode = 000000)
        if opcode_internal = "000000" then
            r_type <= '1';
            

            case funct_internal is 
				-- if I do ever add to this, just add more funct codes and increase function_control if needed
                when "100000" => funct_control <= "00"; -- add
                when "100010" => funct_control <= "01"; -- sub
                when "100001" => funct_control <= "10"; -- addu (same ALU operation as add)
                when "100011" => funct_control <= "11"; -- subu (same ALU operation as sub)
                when others   => funct_control <= "00"; -- Default to add
            end case;
        end if;
    end process;
end Behavioral;