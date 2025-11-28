library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity topo_pipeline is
	
	port (
		
		clock : in std_logic;
		reset : in std_logic
		
	);
	
end entity;

architecture behavior of topo_pipeline is
	
	component decoder is
		
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
		
	end component;
	
	component pipeline is
		
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
		
	end component;
	
	signal aluSrc : std_logic;
	signal regDst : std_logic;
	signal aluControl : std_logic_vector(1 downto 0);
	signal memToReg : std_logic;
	signal memWrite : std_logic;
	signal memRead : std_logic;
	signal regWrite : std_logic;
	signal branch : std_logic;
	signal opcode : std_logic_vector(3 downto 0);
	
	begin
		
		inst_decoder : decoder
			
			port map(
			
				aluSrc => aluSrc,
				regDst => regDst,
				aluControl => aluControl,
				memToReg => memToReg,
				memWrite => memWrite,
				memRead => memRead,
				regWrite => regWrite,
				branch => branch,
				opcode => opcode
				
			);
		
		inst_pipeline : pipeline
			
			port map(
				
				reset => reset,
				clock => clock,
				aluSrc => aluSrc,
				regDst => regDst,
				aluControl => aluControl,
				memToReg => memToReg,
				memWrite => memWrite,
				memRead => memRead,
				regWrite => regWrite,
				branch => branch,
				opcode => opcode
			
			);
	
end behavior;