library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity decoder is
	
	port (
		
		opcode : in std_logic_vector(3 downto 0);
		aluSrc : out std_logic;
		regDst : out std_logic;
		aluControl : out std_logic_vector(1 downto 0);
		memToReg : out std_logic;
		memWrite : out std_logic;
		memRead : out std_logic;
		regWrite : out std_logic;
		branch : out std_logic
		
	);
	
end entity;

architecture behavior of decoder is
	
	begin
	
	process(opcode)
		
		begin
			
			case opcode is
				
				when "0000" => -- LW
					
					aluSrc <= '1';
					regDst <= '1';
					aluControl <= "00";
					memToReg <= '1';
					memWrite <= '0';
					memRead <= '0';
					regWrite <= '1';
					branch <= '0';
					
				when "0001" => -- ADD
					
					aluSrc <= '0';
					regDst <= '1';
					aluControl <= "00";
					memToReg <= '0';
					memWrite <= '0';
					memRead <= '0';
					regWrite <= '1';
					branch <= '0';
					
				when "0010" => -- SUB
				
					aluSrc <= '0';
					regDst <= '1';
					aluControl <= "01";
					memToReg <= '0';
					memWrite <= '0';
					memRead <= '0';
					regWrite <= '1';
					branch <= '0';
				
				when "0011" => -- MUL
				
					aluSrc <= '0';
					regDst <= '1';
					aluControl <= "10";
					memToReg <= '0';
					memWrite <= '0';
					memRead <= '0';
					regWrite <= '1';
					branch <= '0';
				
				when "0100" => -- JMP
				
					aluSrc <= '0';
					regDst <= '1';
					aluControl <= "00";
					memToReg <= '0';
					memWrite <= '0';
					memRead <= '0';
					regWrite <= '1';
				
				when "0101" => -- BEQ
					
					aluSrc <= '0';
					regDst <= '0';
					aluControl <= "00";
					memToReg <= '0';
					memWrite <= '0';
					memRead <= '0';
					regWrite <= '0';
					branch <= '1';
				
				when "0110" => -- BNE
				
					aluSrc <= '0';
					regDst <= '0';
					aluControl <= "00";
					memToReg <= '0';
					memWrite <= '0';
					memRead <= '0';
					regWrite <= '0';
					branch <= '1';
				
				when "0111" => -- SW
				
					aluSrc <= '0';
					regDst <= '0';
					aluControl <= "00";
					memToReg <= '0';
					memWrite <= '1';
					memRead <= '0';
					regWrite <= '0';
					branch <= '0';
				
				when "1000" => -- LWI
				
					aluSrc <= '1';
					regDst <= '1';
					aluControl <= "00";
					memToReg <= '0';
					memWrite <= '0';
					memRead <= '0';
					regWrite <= '1';
					branch <= '0';
				
				when "1001" => -- ADDI
				
					aluSrc <= '1';
					regDst <= '1';
					aluControl <= "00";
					memToReg <= '0';
					memWrite <= '0';
					memRead <= '0';
					regWrite <= '1';
					branch <= '0';
				
				when "1010" => -- SUBI
				
					aluSrc <= '1';
					regDst <= '1';
					aluControl <= "01";
					memToReg <= '0';
					memWrite <= '0';
					memRead <= '0';
					regWrite <= '1';
					branch <= '0';
				
				when "1011" => -- MULI
				
					aluSrc <= '1';
					regDst <= '1';
					aluControl <= "10";
					memToReg <= '0';
					memWrite <= '0';
					memRead <= '0';
					regWrite <= '1';
					branch <= '0';
					
				when others => -- Para todos os outros casos
					
					aluSrc <= '0';
					regDst <= '0';
					aluControl <= "00";
					memToReg <= '0';
					memWrite <= '0';
					memRead <= '0';
					regWrite <= '0';
					branch <= '0';
					
			end case;
	
	end process;
end behavior;
	