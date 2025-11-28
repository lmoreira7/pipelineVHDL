library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity forwarding is
	
	port (
		
		adiantaA : out std_logic_vector(1 downto 0);
		adiantaB : out std_logic_vector(1 downto 0);
		rOp1_ID_EX : in std_logic_vector(3 downto 0);
		rOp2_ID_EX : in std_logic_vector(3 downto 0);
		dest_EX_MEM : in std_logic_vector(3 downto 0);
		dest_MEM_WB : in std_logic_vector(3 downto 0);
		escReg_MEM_WB : in std_logic;
		escReg_EX_MEM : in std_logic
	
	);

end entity;


architecture behavior of forwarding is
	
	begin
	
	adiantaA <= "10" when (escReg_EX_MEM = '1') and (dest_EX_MEM /= "0000") and (rOp1_ID_EX = dest_EX_MEM) else
					"01" when (escReg_MEM_WB = '1') and (dest_MEM_WB /= "0000") and (rOp1_ID_EX = dest_MEM_WB) else
					"00";
					
	adiantaB <= "10" when (escReg_EX_MEM = '1') and (dest_EX_MEM /= "0000") and (rOp2_ID_EX = dest_EX_MEM) else
					"01" when (escReg_MEM_WB = '1') and (dest_MEM_WB /= "0000") and (rOp2_ID_EX = dest_MEM_WB) else
					"00";
					
		
end behavior;