-- UTFPR - DAELN
-- Professores Rafael E. de Goes e Juliano Mourao Vieira
-- Disciplina de Arquitetura e Organizacao de Computadores
-- versao 1.1 - 2019-10-22
-- versão 2.0 - 2022-03-11 - adaptação para a placa DE10-Lite
-- CONVERSAO DO NUMERO BINARIO PARA ESCRITA NOS DISPLAYS 7 SEGMENTOS
-- versão 3.0 - 2022-08-30 - correção da tabela de decodificação Bin-BCD
-- versão 4.0 - Equipe 03 - 3 digitos decimais (0 a 255), sinal e dois
--              digitos hexadecimais extras; a tabela BCD (que tinha erros
--              em 58 e 88) foi substituida por divisao por constantes
--
-- Layout (HEX5 a esquerda):
--   HEX5 : hex5_in em hexadecimal
--   HEX4 : hex4_in em hexadecimal
--   HEX3 : '-' quando neg_in = '1', apagado caso contrario
--   HEX2..HEX0 : dado_in em decimal, sem zeros a esquerda

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity displays is
    port (
        dado_in   : in unsigned (7 downto 0);         -- numero binario de entrada (modulo)
        neg_in    : in std_logic;                     -- '1' acende o sinal de menos
        hex4_in   : in unsigned (3 downto 0);         -- digito hexadecimal para HEX4
        hex5_in   : in unsigned (3 downto 0);         -- digito hexadecimal para HEX5
        disp0_out : out std_logic_vector(6 downto 0); -- unidade (LSd)
        disp1_out : out std_logic_vector(6 downto 0); -- dezena
        disp2_out : out std_logic_vector(6 downto 0); -- centena
        disp3_out : out std_logic_vector(6 downto 0); -- sinal
        disp4_out : out std_logic_vector(6 downto 0); -- hex4_in
        disp5_out : out std_logic_vector(6 downto 0)  -- hex5_in (MSd)
    );
end entity;


architecture arch of displays is

    -- os segmentos sao "gfedcba", 0 acende e 1 apaga
    constant APAGADO : std_logic_vector(6 downto 0) := "1111111";
    constant TRACO   : std_logic_vector(6 downto 0) := "0111111";

    function seg7 (d : unsigned(3 downto 0)) return std_logic_vector is
    begin
        case to_integer(d) is
            when 0      => return "1000000";
            when 1      => return "1111001";
            when 2      => return "0100100";
            when 3      => return "0110000";
            when 4      => return "0011001";
            when 5      => return "0010010";
            when 6      => return "0000010";
            when 7      => return "1111000";
            when 8      => return "0000000";
            when 9      => return "0010000";
            when 10     => return "0001000";  -- A
            when 11     => return "0000011";  -- b
            when 12     => return "1000110";  -- C
            when 13     => return "0100001";  -- d
            when 14     => return "0000110";  -- E
            when others => return "0001110";  -- F
        end case;
    end function;

    -- auxiliares para conversao
    signal valor                      : integer range 0 to 255;
    signal unidade, dezena, centena   : unsigned(3 downto 0);

-- IMPLEMENTACAO PROPRIAMENTE DITA

begin

    -------------------------------------------------
    -- DECODIFICACAO DA ENTRADA BINARIA PARA DIGITOS DECIMAIS
    valor   <= to_integer(dado_in);
    unidade <= to_unsigned(valor mod 10, 4);
    dezena  <= to_unsigned((valor / 10) mod 10, 4);
    centena <= to_unsigned(valor / 100, 4);

    -------------------------------------------------
    -- ESCRITA EFETIVA NOS PINOS DE SAIDA
    disp0_out <= seg7(unidade);
    disp1_out <= seg7(dezena)  when valor >= 10  else APAGADO;
    disp2_out <= seg7(centena) when valor >= 100 else APAGADO;
    disp3_out <= TRACO when neg_in = '1' else APAGADO;
    disp4_out <= seg7(hex4_in);
    disp5_out <= seg7(hex5_in);

end architecture;
