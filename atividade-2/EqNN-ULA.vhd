--------------------------------------------------------------------------------
-- Disciplina : Arquitetura de Computadores - UTFPR
-- Atividade  : Entrega da ULA (Unidade Logica e Aritmetica) - 20 bits
-- Equipe     : EqNN
-- Autores    : Ramon Miguel Pinto Mariano  - RA a2028905
--              Guilherme Pacheco Batista   - RA a2404753
--
-- Descricao  : ULA combinacional pura (sem "process"), com duas entradas de
--              20 bits (in_A, in_B), um barramento de selecao de operacao
--              (op, 2 bits -> 4 operacoes possiveis), uma saida de resultado
--              de 20 bits (out_ULA) e dois flags de sinalizacao (zero, LT),
--              atualizados para QUALQUER operacao selecionada.
--
-- Operacoes (op) - exatamente estas 4, conforme especificacao da atividade:
--   "00" -> soma          : out_ULA <= in_A + in_B                (mod 2^20)
--   "01" -> subtracao     : out_ULA <= in_A - in_B                (mod 2^20)
--   "10" -> multiplicacao : out_ULA <= in_A * in_B (20 bits menos
--                            significativos do produto de 40 bits)
--   "11" -> XOR bit-a-bit : out_ULA <= (in_A OR in_B) AND NOT(in_A AND in_B)
--                            (formula dada no enunciado; equivale ao XOR)
--
-- Flags (calculados sempre, independente da operacao escolhida):
--   zero : '1' quando out_ULA = "000...0" (resultado da operacao atual)
--   LT   : '1' quando in_A < in_B, comparando in_A e in_B como NUMEROS
--          NAO SINALIZADOS (unsigned). Nao depende de "op".
--
-- Implementacao: circuito puramente combinacional -> cada operacao e
-- calculada em paralelo por uma atribuicao de sinal concorrente e a saida
-- e escolhida por um multiplexador (with ... select), sem uso de "process".
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity EqNN_ULA is
    Port (
        in_A     : in  STD_LOGIC_VECTOR(19 downto 0);
        in_B     : in  STD_LOGIC_VECTOR(19 downto 0);
        op       : in  STD_LOGIC_VECTOR(1 downto 0);
        out_ULA  : out STD_LOGIC_VECTOR(19 downto 0);
        zero     : out STD_LOGIC;
        LT       : out STD_LOGIC
    );
end EqNN_ULA;

architecture Combinacional of EqNN_ULA is

    -- Codificacao do barramento de operacao
    constant OP_SOMA : STD_LOGIC_VECTOR(1 downto 0) := "00";
    constant OP_SUB  : STD_LOGIC_VECTOR(1 downto 0) := "01";
    constant OP_MUL  : STD_LOGIC_VECTOR(1 downto 0) := "10";
    constant OP_XOR  : STD_LOGIC_VECTOR(1 downto 0) := "11";

    -- Resultado de cada operacao, calculado em paralelo (sem process)
    signal res_soma : STD_LOGIC_VECTOR(19 downto 0);
    signal res_sub  : STD_LOGIC_VECTOR(19 downto 0);
    signal res_mul  : STD_LOGIC_VECTOR(19 downto 0);
    signal res_xor  : STD_LOGIC_VECTOR(19 downto 0);

    signal res_mux  : STD_LOGIC_VECTOR(19 downto 0);

begin

    -- Soma dos 20 bits (carry final descartado, resultado mod 2^20)
    res_soma <= STD_LOGIC_VECTOR(unsigned(in_A) + unsigned(in_B));

    -- Subtracao dos 20 bits (borrow final descartado, resultado mod 2^20)
    res_sub  <= STD_LOGIC_VECTOR(unsigned(in_A) - unsigned(in_B));

    -- Multiplicacao: produto tem ate 40 bits; mantem-se os 20 bits menos
    -- significativos do resultado (truncamento), pois out_ULA tem 20 bits.
    res_mul  <= STD_LOGIC_VECTOR(resize(unsigned(in_A) * unsigned(in_B), 20));

    -- XOR bit-a-bit, implementado literalmente como pedido no enunciado:
    -- (in_A OR in_B) AND (NOT (in_A AND in_B))  ==  in_A XOR in_B
    res_xor  <= (in_A or in_B) and not(in_A and in_B);

    -- Multiplexador de saida: escolhe qual operacao vai para out_ULA
    with op select
        res_mux <= res_soma when OP_SOMA,
                   res_sub  when OP_SUB,
                   res_mul  when OP_MUL,
                   res_xor  when OP_XOR,
                   (others => '0') when others;

    out_ULA <= res_mux;

    -- Flag "zero": resultado da operacao selecionada e igual a zero
    zero <= '1' when res_mux = "00000000000000000000" else '0';

    -- Flag "LT": comparacao NAO SINALIZADA de in_A e in_B, independente de op
    LT <= '1' when unsigned(in_A) < unsigned(in_B) else '0';

end Combinacional;
