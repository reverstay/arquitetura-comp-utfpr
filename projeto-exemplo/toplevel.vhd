-- UTFPR - DAELN
-- Professores Rafael E. de Goes e Juliano Mourao Vieira
-- Disciplina de Arquitetura e Organizacao de Computadores
-- versao 1.1 - 2019-10-22
-- versão 2.0 - 2022-03-11 - adaptação para a placa DE10-Lite
-- versão 2.1 - limpeza para circuito combinacional apenas 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity toplevel is
    -- sinais que sao usados no toplevel, mapeados no hardware da placa
    -- (substituem o que vinha do testbench)
    port (   
        --- clock master da placa ligado na FPGA
        CLK_H_HW : in std_logic;                 -- PIN_N14 (50 MHz)
            
        -- sinais que sao a interface de teste no HW fisico
        RST_HW : in std_logic;               -- KEY0 PIN_B8
		  KEY1_HW:    in std_logic;				-- KEY1 PIN_A7
        
		  SWITCH_HW : in unsigned (9 downto 0);  --SW9 a SW0  (PINS F15, B14, A14, A13, B12, A12, C12, D12, C11, C10) 
        LED_HW        : out unsigned (9 downto 0);    -- LED9..LED0 (PINS B11, A11, D14, E14, C13, D13, B10, A10, A9, A8)

        -- displays da placa conectados na FPGA
        HEX0_HW: out std_logic_vector(6 downto 0);   -- display 7 segmentos (LSd)
        HEX1_HW: out std_logic_vector(6 downto 0);   -- display 7 segmentos
        HEX2_HW: out std_logic_vector(6 downto 0);   -- display 7 segmentos
        HEX3_HW: out std_logic_vector(6 downto 0);   -- display 7 segmentos 
		  HEX4_HW: out std_logic_vector(6 downto 0);   -- display 7 segmentos 
		  HEX5_HW: out std_logic_vector(6 downto 0)    -- display 7 segmentos (MSd)
		  
    );
end entity;

architecture arch of toplevel is
    component displays is
        port(
            dado_in   : in unsigned (7 downto 0);         -- numero binario de entrada
            disp0_out : out std_logic_vector(6 downto 0); -- display LSd convertido para 7 segmentos
            disp1_out : out std_logic_vector(6 downto 0); -- 
            disp2_out : out std_logic_vector(6 downto 0); -- 
				disp3_out : out std_logic_vector(6 downto 0); -- 
				disp4_out : out std_logic_vector(6 downto 0); -- 
				disp5_out : out std_logic_vector(6 downto 0)  -- display MSd convertido para 7 segmentos
        );
    end component;

    signal mostra_disp : unsigned(7 downto 0);        -- numero a mostrar no display

begin
    display: displays port map (
			dado_in=>mostra_disp,
         disp0_out=> HEX0_HW,
			disp1_out=> HEX1_HW,
			disp2_out=> HEX2_HW,
			disp3_out=> HEX3_HW,
			disp4_out=> HEX4_HW,
			disp5_out=> HEX5_HW);
			
    mostra_disp <= SWITCH_HW (7 downto 0);
    
    -- leds da placa usados para monitoramento cas chaves e alguma lógica combinacional
    LED_HW (7 downto 0)   <= SWITCH_HW (7 downto 0);     
    LED_HW(8) <= SWITCH_HW(8) xor RST_HW;  
    LED_HW(9) <= SWITCH_HW(9) xor KEY1_HW;  


end architecture ;