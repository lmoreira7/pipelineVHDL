library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity hazard is
	
	port (
		
		PC_Write : out std_logic;
		IF_ID_Write : out std_logic;
		flush_IF_ID : out std_logic;
		flush_ID_EX : out std_logic;
		
		mRead_ID_EX : in std_logic;
		rOp2_ID_EX : in std_logic_vector(3 downto 0);
		regDestino_ID_EX : in std_logic_vector(3 downto 0);
		opcode_IF_ID : in std_logic_vector(3 downto 0);
		opcode_ID_EX : in std_logic_vector(3 downto 0);
		regWrite_EX_MEM : in std_logic;
		equal : in std_logic
		
		
	);

end entity;

architecture behavior of hazard is
	
	signal branchTomado : std_logic;
	
	begin
		
		branchTomado <= '1' when (opcode_ID_EX = "0101") and (equal = '1') else '0';
		
		process(mRead_ID_EX, rOp2_ID_EX, regDestino_ID_EX, regWrite_EX_MEM, Opcode_IF_ID)
			
			begin
			
				PC_Write <= '1';
				IF_ID_Write <= '1';
				flush_ID_EX <= '0';
				flush_IF_ID <= '0';
				
				if (mRead_ID_EX = '1') and ((regDestino_ID_EX = rOp2_ID_EX) or (rOp2_ID_EX = regDestino_ID_EX)) and (regDestino_ID_EX /= "0000") then
					
					PC_Write <= '0';
					IF_ID_Write <= '0';
				
				end if;
				
				if(Opcode_IF_ID = "0100") then
					
					flush_IF_ID  <= '1';
				
				end if;
				
				if(branchTomado = '1') then
					
					flush_IF_ID <= '1';
					flush_ID_EX <= '1';
				
				end if;
		end process;
		
end behavior;