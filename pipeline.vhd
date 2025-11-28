library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity pipeline is
	
	port (
		
		clock : in std_logic;
		reset : in std_logic;
		aluSrc : in std_logic;
		regDst : in std_logic;
		aluControl : in std_logic_vector(1 downto 0);
		memToReg : in std_logic;
		memWrite : in std_logic;
		memRead : in std_logic;
		regWrite : in std_logic;
		branch : in std_logic;
		opcode : out std_logic_vector(3 downto 0)
		
	);
	
end entity;


architecture behavior of pipeline is
	
	
	signal programCounter : std_logic_vector(7 downto 0);
	
	-------------- MEMORIA DE INSTRUÇÃO ----------------
	
	type mem is array(integer range 0 to 255) of std_logic_vector(19 downto 0);
	signal memInst : mem;
	signal memInstOut : std_logic_vector(19 downto 0);
	signal op_code : std_logic_vector(3 downto 0);
	signal regOp1 : std_logic_vector(3 downto 0);
	signal regOp2 : std_logic_vector(3 downto 0);
	signal regDest : std_logic_vector(3 downto 0);
	signal desloc : std_logic_vector(7 downto 0);
	signal endereco : std_logic_vector(7 downto 0);
	signal imm_extend : std_logic_vector(15 downto 0);
	signal imm : std_logic_vector(7 downto 0);
	
	------------------------------------------------------
	
	-------------- BANCO DE REGISTRADORES ----------------
	
	type bReg is array(integer range 0 to 15) of std_logic_vector(15 downto 0);
	signal bancoRegs : bReg;
	signal regDestino : std_logic_vector(3 downto 0);
	
	------------------------------------------------------
	
	---------- UNIDADE LÓGICA ARITMÉTICA (ULA) -----------
	
	signal saidaUla : std_logic_vector(15 downto 0);
	signal add : std_logic_vector(15 downto 0);
	signal sub : std_logic_vector(15 downto 0);
	signal mult : std_logic_vector(31 downto 0);
	signal equal : std_logic;
	signal op1 : std_logic_vector(15 downto 0);
	signal op2 : std_logic_vector(15 downto 0);
	
	------------------------------------------------------
	
	--------------- MEMORIA DE DADOS ---------------------
	
	type memData is array(integer range 0 to 255) of std_logic_vector(15 downto 0);
	signal memDados : memData;
	signal memDadosOut : std_logic_vector(15 downto 0);
	
	------------------------------------------------------
	
	------------ REGISTRADORES DE PIPELINE ---------------
		
	signal memToReg_MEM_WB : std_logic;
	signal regWrite_MEM_WB : std_logic;
	signal saidaUla_MEM_WB : std_logic_vector(15 downto 0);
	signal memDadosOut_MEM_WB : std_logic_vector(15 downto 0);
	signal regDestino_MEM_WB : std_logic_vector(3 downto 0);
		
	signal memToReg_EX_MEM : std_logic;
	signal regWrite_EX_MEM : std_logic;
	signal memWrite_EX_MEM : std_logic;
	signal memRead_EX_MEM : std_logic;
	signal saidaUla_EX_MEM : std_logic_vector(15 downto 0);
	signal regDestino_EX_MEM : std_logic_vector(3 downto 0);
	signal endereco_EX_MEM : std_logic_vector(7 downto 0);
		
	signal memToReg_ID_EX : std_logic;
	signal regWrite_ID_EX : std_logic;
	signal memWrite_ID_EX : std_logic;
	signal memRead_ID_EX : std_logic;
	signal aluControl_ID_EX : std_logic_vector(1 downto 0);
	signal regDest_ID_EX : std_logic;
	signal aluSrc_ID_EX : std_logic;
	signal regA_ID_EX : std_logic_vector(15 downto 0);
	signal regB_ID_EX : std_logic_vector(15 downto 0);
	signal imm_extend_ID_EX : std_logic_vector(15 downto 0);
	signal regOp2_ID_EX : std_logic_vector(3 downto 0);
	signal regDestino_ID_EX : std_logic_vector(3 downto 0);
	signal endereco_ID_EX : std_logic_vector(7 downto 0);
		
	signal programCounter_IF_ID : std_logic_vector(7 downto 0);
	signal instrucao_IF_ID : std_logic_vector(19 downto 0);
		
		
	------------------------------------------------------
	
	begin
		
		--------------- MEMORIA DE INSTRUÇÃO -----------------
		
		memInst(0) <= 20x"81005"; -- LDI $1, 5
		memInst(1) <= 20x"82003"; -- LDI $2, 3
		memInst(2) <= 20x"14120"; -- ADD $4, $1, $2
		memInst(3) <= 20x"25410"; -- SUB $5, $4, $1
		memInst(4) <= 20x"93005"; -- ADDI $3, $0, 5
		memInst(5) <= 20x"3A320"; -- MUL $10, $3, $2
		memInst(6) <= 20x"50034"; -- BEQ $0, $3, salta p/ memInst(10)
		memInst(7) <= 20x"B7202"; -- MULI $2, $2, 2
		memInst(8) <= 20x"A3301"; -- SUBI $3, $3, 1
		memInst(9) <= 20x"40006"; -- JMP memInst(6)
		memInst(10) <= 20x"60242"; -- BNE $2, $4, salta p/ memInst(12)
		memInst(11) <= 20x"4000A"; -- JMP memInst(10)
		memInst(12) <= 20x"70205"; -- SW MemDados[5], $2
		memInst(13) <= 20x"0F005"; -- LW $15 MemDados[5]
		
		memInstOut <= memInst(conv_integer(programCounter));
		
		op_code <= instrucao_IF_ID(19 downto 16);
		regDest <= instrucao_IF_ID(15 downto 12);
		regOp1 <= instrucao_IF_ID(11 downto 8);
		regOp2 <= instrucao_IF_ID(7 downto 4);
		imm <= instrucao_IF_ID(7 downto 0);
		imm_extend <= (15 downto 8 => '0') & imm;
		endereco <= instrucao_IF_ID(7 downto 0);
		desloc <= regDest & instrucao_IF_ID(3 downto 0);
		
		opcode <= op_code; -- Entrada do Decoder
		
		------------------------------------------------------
		
		-------------- BANCO DE REGISTRADORES ----------------
		
		regDestino <= regOp2_ID_EX when regDest_ID_EX = '0' else
						  regDestino_ID_EX;
		
		
		---------- UNIDADE LÓGICA ARITMÉTICA (ULA) -----------
		
		op1 <= regA_ID_EX;
		
		op2 <= regB_ID_EX when aluSrc_ID_EX = '0' else
				 imm_extend_ID_EX;
		
		saidaUla <= add when aluControl_ID_EX = "00" else
						sub when aluControl_ID_EX = "01" else
						mult(15 downto 0);
						
		add <= op1 + op2;
				 
		sub <= op1 - op2;
				 
		mult <= op1 * op2;
				  
		equal <= '1' when op1 = op2 else '0';
	
		------------------------------------------------------
		
		--------------- MEMORIA DE DADOS ---------------------
		
		memDadosOut <= memDados(conv_integer(endereco_EX_MEM));
		
		------------------------------------------------------		
		
		
		process(clock, reset)
			
			begin
				
				if reset = '1' then
					
					memToReg_MEM_WB <= '0';
					regWrite_MEM_WB <= '0';
					saidaUla_MEM_WB <= (others => '0');
					memDadosOut_MEM_WB <= (others => '0');
					regDestino_MEM_WB <= (others => '0');
					
					memToReg_EX_MEM <= '0';
					regWrite_EX_MEM <= '0';
					memWrite_EX_MEM <= '0';
					memRead_EX_MEM <= '0';
					saidaUla_EX_MEM <= (others => '0');
					regDestino_EX_MEM <= (others => '0');
					endereco_EX_MEM <= (others => '0');
					
					memToReg_ID_EX <= '0';
					regWrite_ID_EX <= '0';
					memWrite_ID_EX <= '0';
					memRead_ID_EX <= '0';
					aluControl_ID_EX <= (others => '0');
					regDest_ID_EX <= '0';
					aluSrc_ID_EX <= '0';
					regA_ID_EX <= (others => '0');
					regB_ID_EX <= (others => '0');
					imm_extend_ID_EX <= (others => '0');
					regOp2_ID_EX <= (others => '0');
					regDestino_ID_EX <= (others => '0');
					endereco_ID_EX <= (others => '0');
					
					programCounter_IF_ID <= (others => '0');
					instrucao_IF_ID <= (others => '0');
				
				elsif rising_edge(clock) then
					
					programCounter_IF_ID <= programCounter;
					instrucao_IF_ID <= memInstOut;
					
					regWrite_ID_EX <= regWrite;
					memToReg_ID_EX <= memToReg;
					memWrite_ID_EX <= memWrite;
					memRead_ID_EX <= memRead;
					aluControl_ID_EX <= aluControl;
					regDest_ID_EX <= regDst;
					aluSrc_ID_EX <= aluSrc;
					regA_ID_EX <= bancoRegs(conv_integer(regOp1));
					regB_ID_EX <= bancoRegs(conv_integer(regOp2));
					imm_extend_ID_EX <= imm_extend;
					regOp2_ID_EX <= regOp2;
					regDestino_ID_EX <= regDest;
					endereco_ID_EX <= endereco;
					
					regWrite_EX_MEM <= regWrite_ID_EX;
					memToReg_EX_MEM <= memRead_ID_EX;
					memWrite_EX_MEM <= memWrite_ID_EX;
					memRead_EX_MEM <= memRead_ID_EX;
					saidaUla_EX_MEM <= saidaUla;
					regDestino_EX_MEM <= regDestino;
					endereco_EX_MEM <= endereco_ID_EX;
					
					regWrite_MEM_WB <= regWrite_EX_MEM;
					memToReg_MEM_WB <= memToReg_EX_MEM;
					saidaUla_MEM_WB <= saidaUla_EX_MEM;
					memDadosOut_MEM_WB <= memDadosOut;
					regDestino_MEM_WB <= regDestino_EX_MEM;
					
				end if;			
		end process;
		
		process(clock, reset)
			
			begin
				
				if reset = '1' then
					
					programCounter <= (others => '0');
					bancoRegs <= (others => (others => '0'));
					memDados <= (others => (others => '0'));
					
				elsif rising_edge(clock) then
				
				-------------------------- INCREMENTO DO PROGRAM COUNTER --------------------------
					
					if (memInstOut(18) = '0') or (memInstOut(19 downto 16) = "0101" and equal = '0') or (memInstOut(19 downto 16) = "0110" and equal = '1') or (memInstOut(19 downto 16) = "0111") then
						
						programCounter <= programCounter + 1;
					
					else
						
						if op_code = "0100" then -- INCRMENTO DO JUMP
							
							programCounter <= endereco;
						
						else -- INCREMENTO DO BRANCH
							
							programCounter <= programCounter + desloc;
						
						end if;
					end if;
					
				-----------------------------------------------------------------------------------
				
				----------------------------- TIPO R / TIPO I / LW / LWI --------------------------
					
					
					if regWrite_MEM_WB = '1' then
						
						if memToReg_MEM_WB = '1' then
							
							bancoRegs(conv_integer(regDestino_MEM_WB)) <= memDadosOut_MEM_WB;
						
						else
						
							bancoRegs(conv_integer(regDestino_MEM_WB)) <= saidaUla_MEM_WB;
							
						end if;
					end if;
					
				----------------------------------------------------------------------------------
				
				--------------------------------- SW ---------------------------------------------
						
					if memWrite_EX_MEM = '1' then
							
						memDados(conv_integer(endereco_EX_MEM)) <= saidaUla_EX_MEM;
						
					end if;
					
				---------------------------------------------------------------------------------
		
				end if;
		end process;

end behavior;