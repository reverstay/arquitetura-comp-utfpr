--------------------------------------------------------------------------------
-- Disciplina : Arquitetura de Computadores - UTFPR
-- Atividade  : Entrega da ULA (Unidade Logica e Aritmetica) - 20 bits
-- Equipe     : EqNN
-- Autores    : Ramon Miguel Pinto Mariano  - RA a2028905
--              Guilherme Pacheco Batista   - RA a2404753
--
-- Testbench da entidade EqNN_ULA (arquivo EqNN-ULA.vhd).
--
-- Cobertura:
--   1) As 4 operacoes exigidas (soma, subtracao, multiplicacao, XOR),
--      cada uma com mais de um vetor de teste;
--   2) Casos com flag "zero" = '1' e '0' para cada operacao (inclusive
--      "zero" produzido por estouro/wrap da soma e da multiplicacao);
--   3) Casos com flag "LT" (unsigned, in_A < in_B) = '1' e '0';
--   4) Um caso de teste obrigatorio com os RAs dos dois integrantes da
--      equipe, truncados para caber em 20 bits (ver bloco de comentarios
--      "CASO DE TESTE COM OS RAs DA EQUIPE" mais abaixo), aplicado nas
--      4 operacoes da ULA.
--
-- Todos os vetores foram conferidos previamente em Python (aritmetica
-- modulo 2^20 para soma/subtracao/multiplicacao) e sao verificados aqui
-- com "assert ... severity error", alem de "report" informativo a cada
-- caso.
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity EqNN_ULA_tb is
end EqNN_ULA_tb;

architecture Simulacao of EqNN_ULA_tb is

    constant OP_SOMA : STD_LOGIC_VECTOR(1 downto 0) := "00";
    constant OP_SUB  : STD_LOGIC_VECTOR(1 downto 0) := "01";
    constant OP_MUL  : STD_LOGIC_VECTOR(1 downto 0) := "10";
    constant OP_XOR  : STD_LOGIC_VECTOR(1 downto 0) := "11";

    signal in_A_tb    : STD_LOGIC_VECTOR(19 downto 0) := (others => '0');
    signal in_B_tb    : STD_LOGIC_VECTOR(19 downto 0) := (others => '0');
    signal op_tb      : STD_LOGIC_VECTOR(1 downto 0)  := OP_SOMA;
    signal out_ULA_tb : STD_LOGIC_VECTOR(19 downto 0);
    signal zero_tb    : STD_LOGIC;
    signal LT_tb      : STD_LOGIC;

    -- Aplica um vetor de teste e checa saida/flags esperadas
    procedure aplica_e_checa(
        signal a_sig, b_sig : out STD_LOGIC_VECTOR(19 downto 0);
        signal op_sig       : out STD_LOGIC_VECTOR(1 downto 0);
        a, b                : in integer;
        op_code             : in STD_LOGIC_VECTOR(1 downto 0);
        esperado            : in integer;
        zero_esp, lt_esp    : in STD_LOGIC;
        rotulo               : in string
    ) is
    begin
        a_sig  <= STD_LOGIC_VECTOR(to_unsigned(a, 20));
        b_sig  <= STD_LOGIC_VECTOR(to_unsigned(b, 20));
        op_sig <= op_code;
        wait for 10 ns;
        assert out_ULA_tb = STD_LOGIC_VECTOR(to_unsigned(esperado, 20))
            report rotulo & " -> out_ULA incorreto" severity error;
        assert zero_tb = zero_esp
            report rotulo & " -> flag zero incorreta" severity error;
        assert LT_tb = lt_esp
            report rotulo & " -> flag LT incorreta" severity error;
        report rotulo & " OK";
    end procedure;

begin

    DUT: entity work.EqNN_ULA
        port map (
            in_A    => in_A_tb,
            in_B    => in_B_tb,
            op      => op_tb,
            out_ULA => out_ULA_tb,
            zero    => zero_tb,
            LT      => LT_tb
        );

    processo_estimulos: process
    begin
        ----------------------------------------------------------------
        -- SOMA
        ----------------------------------------------------------------
        -- soma simples, sem zero, sem LT
        aplica_e_checa(in_A_tb, in_B_tb, op_tb, 5, 3, OP_SOMA, 8, '0', '0', "SOMA simples (5+3)");

        -- soma que resulta em zero (0+0)
        aplica_e_checa(in_A_tb, in_B_tb, op_tb, 0, 0, OP_SOMA, 0, '1', '0', "SOMA para zero (0+0)");

        -- soma com estouro dos 20 bits (wrap): 0xFFFFF + 1 = 0 (zero=1)
        aplica_e_checa(in_A_tb, in_B_tb, op_tb, 1048575, 1, OP_SOMA, 0, '1', '0', "SOMA com overflow (0xFFFFF+1 -> 0)");

        ----------------------------------------------------------------
        -- SUBTRACAO
        ----------------------------------------------------------------
        -- subtracao positiva simples
        aplica_e_checa(in_A_tb, in_B_tb, op_tb, 10, 3, OP_SUB, 7, '0', '0', "SUB simples (10-3)");

        -- subtracao que resulta em zero (A=B)
        aplica_e_checa(in_A_tb, in_B_tb, op_tb, 1234, 1234, OP_SUB, 0, '1', '0', "SUB para zero (A=B)");

        -- subtracao com underflow (A<B, resultado "empresta" -> wrap) e LT=1
        aplica_e_checa(in_A_tb, in_B_tb, op_tb, 3, 10, OP_SUB, 1048569, '0', '1', "SUB com underflow (3-10, wrap) e LT=1");

        ----------------------------------------------------------------
        -- MULTIPLICACAO
        ----------------------------------------------------------------
        -- multiplicacao simples, com LT=1 (A<B)
        aplica_e_checa(in_A_tb, in_B_tb, op_tb, 6, 7, OP_MUL, 42, '0', '1', "MUL simples (6*7) com LT=1");

        -- multiplicacao por zero -> resultado zero
        aplica_e_checa(in_A_tb, in_B_tb, op_tb, 12345, 0, OP_MUL, 0, '1', '0', "MUL por zero (12345*0)");

        -- multiplicacao com truncamento: 1500*1500=2.250.000, so cabem os
        -- 20 bits menos significativos (2.250.000 mod 2^20 = 152.848)
        aplica_e_checa(in_A_tb, in_B_tb, op_tb, 1500, 1500, OP_MUL, 152848, '0', '0', "MUL com truncamento (1500*1500 mod 2^20)");

        ----------------------------------------------------------------
        -- XOR bit-a-bit : (A OR B) AND NOT(A AND B)
        ----------------------------------------------------------------
        -- padrao alternado 0xAAAAA / 0x55555 -> XOR = 0xFFFFF (todos os bits)
        aplica_e_checa(in_A_tb, in_B_tb, op_tb, 699050, 349525, OP_XOR, 1048575, '0', '0', "XOR alternado (0xAAAAA xor 0x55555 = 0xFFFFF)");

        -- XOR de A com ele mesmo -> resultado zero
        aplica_e_checa(in_A_tb, in_B_tb, op_tb, 74565, 74565, OP_XOR, 0, '1', '0', "XOR A xor A -> zero");

        -- XOR com LT=1
        aplica_e_checa(in_A_tb, in_B_tb, op_tb, 1, 3, OP_XOR, 2, '0', '1', "XOR (1 xor 3) com LT=1");

        ----------------------------------------------------------------
        -- CASO DE TESTE COM OS RAs DA EQUIPE
        --
        -- RAs da equipe: Ramon a2028905 (RA=2028905) e Guilherme a2404753
        -- (RA=2404753). Truncamento para caber em 20 bits (2^20=1.048.576):
        -- divide-se o RA por uma potencia de 2 ate o resultado ficar menor
        -- que 2^20 (conforme exemplo do enunciado: "divide-se por 2 ou 4").
        --
        --   Ramon:      2.028.905 / 2^1 = 1.014.452  (0xF7AB4) -> cabe em 20 bits
        --   Guilherme:  2.404.753 / 2^1 = 1.202.376.5 -> nao cabe (>2^20-1);
        --               2.404.753 / 2^2 =   601.188   (0x92C64) -> cabe em 20 bits
        --
        -- "Maior pelo menor, ja truncados em 20 bits":
        --   maior = 1.014.452 (Ramon)   menor = 601.188 (Guilherme)
        --
        -- A ULA desta atividade NAO possui operacao de divisao (apenas
        -- soma, subtracao, multiplicacao e XOR, conforme especificado).
        -- Por isso, o par (maior, menor) acima e aplicado como in_A/in_B
        -- nas 4 operacoes suportadas pela ULA, cobrindo o caso pedido.
        -- Apenas como registro/documentacao, a divisao inteira desses
        -- valores seria: 1.014.452 div 601.188 = 1 (resto = 413.264).
        ----------------------------------------------------------------
        aplica_e_checa(in_A_tb, in_B_tb, op_tb, 1014452, 601188, OP_SOMA, 567064, '0', '0', "RAs equipe: SOMA (maior+menor, wrap)");
        aplica_e_checa(in_A_tb, in_B_tb, op_tb, 1014452, 601188, OP_SUB,  413264, '0', '0', "RAs equipe: SUB (maior-menor)");
        aplica_e_checa(in_A_tb, in_B_tb, op_tb, 1014452, 601188, OP_MUL,  450128, '0', '0', "RAs equipe: MUL (maior*menor, truncado 20 bits)");
        aplica_e_checa(in_A_tb, in_B_tb, op_tb, 1014452, 601188, OP_XOR,  415440, '0', '0', "RAs equipe: XOR (maior xor menor)");

        report "Todos os casos de teste da ULA foram executados.";
        wait;
    end process;

end Simulacao;
