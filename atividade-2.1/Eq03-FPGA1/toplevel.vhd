-- UTFPR - DAELN
-- Professores Rafael E. de Goes e Juliano Mourao Vieira
-- Disciplina de Arquitetura e Organizacao de Computadores
-- versao 1.1 - 2019-10-22
-- versão 2.0 - 2022-03-11 - adaptação para a placa DE10-Lite
-- versão 2.1 - limpeza para circuito combinacional apenas
-- versão 3.0 - Equipe 03 - ULA 20 bits da atividade 2 instanciada na FPGA
--
-- Mapeamento:
--   SW9..SW8 : operacao (00 soma, 01 subtracao, 10 multiplicacao, 11 xor)
--   SW7..SW4 : entrada A (4 bits)
--   SW3..SW0 : entrada B (4 bits)
--   HEX1..HEX0 : resultado em decimal (0 a 99; acima disso mostra "--")
--   LED7..LED0 : resultado em binario (8 bits menos significativos)
--   LED8 : flag zero (outZ)
--   LED9 : flag A < B (outLT)

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

    component Ula is
        port(
            inOP  : in  std_logic_vector(1  downto 0);
            inA   : in          unsigned(19 downto 0);
            inB   : in          unsigned(19 downto 0);
            outR  : out         unsigned(19 downto 0);
            outZ  : out                     std_logic;
            outLT : out                     std_logic
        );
    end component;

    signal mostra_disp : unsigned(7 downto 0);        -- numero a mostrar no display

    signal ula_op  : std_logic_vector(1 downto 0);
    signal ula_a   : unsigned(19 downto 0);
    signal ula_b   : unsigned(19 downto 0);
    signal ula_r   : unsigned(19 downto 0);
    signal ula_z   : std_logic;
    signal ula_lt  : std_logic;

begin
    display: displays port map (
			dado_in=>mostra_disp,
         disp0_out=> HEX0_HW,
			disp1_out=> HEX1_HW,
			disp2_out=> HEX2_HW,
			disp3_out=> HEX3_HW,
			disp4_out=> HEX4_HW,
			disp5_out=> HEX5_HW);

    ula0: Ula port map (
            inOP  => ula_op,
            inA   => ula_a,
            inB   => ula_b,
            outR  => ula_r,
            outZ  => ula_z,
            outLT => ula_lt);

    -- chaves -> entradas da ULA (completando com zeros ate 20 bits)
    ula_op <= std_logic_vector(SWITCH_HW(9 downto 8));
    ula_a  <= "0000000000000000" & SWITCH_HW(7 downto 4);
    ula_b  <= "0000000000000000" & SWITCH_HW(3 downto 0);

    -- resultado no display
    mostra_disp <= ula_r(7 downto 0);

    -- leds da placa: resultado em binario e flags da ULA
    LED_HW(7 downto 0) <= ula_r(7 downto 0);
    LED_HW(8) <= ula_z;
    LED_HW(9) <= ula_lt;


end architecture ;
