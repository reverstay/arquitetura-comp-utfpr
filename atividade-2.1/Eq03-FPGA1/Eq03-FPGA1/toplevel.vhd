-- UTFPR - DAELN
-- Professores Rafael E. de Goes e Juliano Mourao Vieira
-- Disciplina de Arquitetura e Organizacao de Computadores
-- versao 1.1 - 2019-10-22
-- versão 2.0 - 2022-03-11 - adaptação para a placa DE10-Lite
-- versão 2.1 - limpeza para circuito combinacional apenas
-- versão 3.0 - Equipe 3 - ULA de 4 bits, 3 operacoes e 2 flags instanciada na FPGA
--
-- Equipe 3
-- Autores [RA]: Guilherme Pacheco Batista [2404753]
--               Ramon Miguel Pinto Mariano [2028905]
--
-- Mapeamento:
--   SW9..SW8 : operacao (00 soma, 01 subtracao, 10 multiplicacao)
--   SW7..SW4 : entrada A (4 bits)
--   SW3..SW0 : entrada B (4 bits)
--   HEX5     : A em hexadecimal
--   HEX4     : B em hexadecimal
--   HEX3     : sinal de menos (subtracao com A < B)
--   HEX2..HEX0 : resultado da ULA em decimal (0 a 15; na subtracao com A < B, o modulo)
--   LED3..LED0 : resultado da ULA em binario (4 bits)
--   LED7..LED4 : apagados
--   LED8 : flag zero  (outZ)
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
        KEY1_HW:    in std_logic;            -- KEY1 PIN_A7

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
            dado_in   : in unsigned (7 downto 0);
            neg_in    : in std_logic;
            hex4_in   : in unsigned (3 downto 0);
            hex5_in   : in unsigned (3 downto 0);
            disp0_out : out std_logic_vector(6 downto 0);
            disp1_out : out std_logic_vector(6 downto 0);
            disp2_out : out std_logic_vector(6 downto 0);
            disp3_out : out std_logic_vector(6 downto 0);
            disp4_out : out std_logic_vector(6 downto 0);
            disp5_out : out std_logic_vector(6 downto 0)
        );
    end component;

    component Ula is
        port(
            inOP : in  std_logic_vector(1 downto 0);
            inA  : in  unsigned(3 downto 0);
            inB  : in  unsigned(3 downto 0);
            outR : out unsigned(3 downto 0);
            outZ  : out std_logic;
            outLT : out std_logic
        );
    end component;

    signal ula_op : std_logic_vector(1 downto 0);
    signal ula_a  : unsigned(3 downto 0);
    signal ula_b  : unsigned(3 downto 0);
    signal ula_r  : unsigned(3 downto 0);
    signal ula_z  : std_logic;
    signal ula_lt : std_logic;

    signal negativo    : std_logic;             -- subtracao com resultado negativo
    signal mostra_disp : unsigned(7 downto 0);  -- modulo do resultado a mostrar

begin
    display: displays port map (
            dado_in   => mostra_disp,
            neg_in    => negativo,
            hex4_in   => SWITCH_HW(3 downto 0),
            hex5_in   => SWITCH_HW(7 downto 4),
            disp0_out => HEX0_HW,
            disp1_out => HEX1_HW,
            disp2_out => HEX2_HW,
            disp3_out => HEX3_HW,
            disp4_out => HEX4_HW,
            disp5_out => HEX5_HW);

    ula0: Ula port map (
            inOP => ula_op,
            inA  => ula_a,
            inB  => ula_b,
            outR => ula_r,
            outZ  => ula_z,
            outLT => ula_lt);

    -- chaves -> entradas da ULA
    ula_op <= std_logic_vector(SWITCH_HW(9 downto 8));
    ula_a  <= SWITCH_HW(7 downto 4);
    ula_b  <= SWITCH_HW(3 downto 0);

    -- resultado no display: na subtracao com A < B mostra "-" e o modulo
    -- (complemento de 2 do resultado)
    negativo    <= '1' when ula_op = "01" and ula_lt = '1' else '0';
    mostra_disp <= "0000" & (not ula_r + 1) when negativo = '1' else
                   "0000" & ula_r;

    -- leds da placa: resultado em binario e flags da ULA
    LED_HW(3 downto 0) <= ula_r;
    LED_HW(7 downto 4) <= "0000";
    LED_HW(8) <= ula_z;
    LED_HW(9) <= ula_lt;

end architecture ;
