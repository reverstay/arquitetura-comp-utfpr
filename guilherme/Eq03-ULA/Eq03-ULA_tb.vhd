--
-- Autor(es)[RA]: Guilherme Pacheco Batista[2404753]
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Ula_tb is
end Ula_tb;

architecture Test of Ula_tb is
  signal s_inOP  :  std_logic_vector(1 downto 0);
  signal s_inA   :         unsigned(19 downto 0);
  signal s_inB   :         unsigned(19 downto 0);
  signal s_outR  :         unsigned(19 downto 0);
  signal s_outZ  :                     std_logic;
  signal s_outLT :                     std_logic;
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
begin

  DUT : entity work.Ula port map(
    inOP  =>  s_inOP ,
    inA   =>  s_inA  ,
    inB   =>  s_inB  ,
    outR  =>  s_outR ,
    outZ  =>  s_outZ ,
    outLT =>  s_outLT
  );

  process begin
    --
    -- 0d123 : número decimal 123
    -- 0b101 : número binário 101
    -- 0d0 = 0b0 = 0, 0d1 = 0b1 = 1
    --

    -- Adição ------------------------------------------------------------------
    s_inOP <= "00";

    -- esperado: 0
    s_inA  <= "00000000000000000000";
    s_inB  <= "00000000000000000000";
    wait for 10 ns;

    -- esperado: 0d2
    s_inA  <= "00000000000000000001";
    s_inB  <= "00000000000000000001";
    wait for 10 ns;

    -- esperado: 0d10
    s_inA  <= "00000000000000000111";
    s_inB  <= "00000000000000000011";
    wait for 10 ns;

    -- esperado: 0d10
    s_inA  <= "00000000000000000011";
    s_inB  <= "00000000000000000111";
    wait for 10 ns;

    -- Subtração ---------------------------------------------------------------
    s_inOP <= "01";

    -- esperado: 0
    s_inA  <= "00000000000000000000";
    s_inB  <= "00000000000000000000";
    wait for 10 ns;

    -- esperado: 0
    s_inA  <= "00000000000000000001";
    s_inB  <= "00000000000000000001";
    wait for 10 ns;

    -- esperado: 0d10
    s_inA  <= "00000000000000000111";
    s_inB  <= "00000000000000000011";
    wait for 10 ns;

    -- esperado: 0d10
    s_inA  <= "00000000000000000011";
    s_inB  <= "00000000000000000111";
    wait for 10 ns;

    -- Multiplicação -----------------------------------------------------------
    s_inOP <= "10";

    -- esperado: 0
    s_inA  <= "00000000000000000000";
    s_inB  <= "00000000000000000000";
    wait for 10 ns;

    -- esperado: 1
    s_inA  <= "00000000000000000001";
    s_inB  <= "00000000000000000001";
    wait for 10 ns;

    -- esperado: 0d21
    s_inA  <= "00000000000000000111";
    s_inB  <= "00000000000000000011";
    wait for 10 ns;

    -- esperado: 0d21
    s_inA  <= "00000000000000000011";
    s_inB  <= "00000000000000000111";
    wait for 10 ns;

    -- Não compreendi, a partir da descrição da atividade, qual seria a
    -- sequência correta de passos a se seguir para que o RA seja representado
    -- com apenas 10 bits, então apenas os converti diretamente para binário e
    -- depois peguei os primeiros 10 bits de cada (da esquerda para a direita).
    -- RA Gui. : 0d2404753 -> 0b1001001011000110010001 -> 0b1001001011 -> 0d587
    -- RA Ramon: 0d2028905 -> 0b111101111010101101001  -> 0b1111011110 -> 0d990
    -- -> 0d990 * 0d587 = 0d581130 -> 0b10001101111000001010 (valor esperado).
    s_inA  <= "00000000001111011110";
    s_inB  <= "00000000001001001011";
    wait for 10 ns;

    -- XOR ---------------------------------------------------------------------
    s_inOP <= "11";

    -- esperado: 0
    s_inA  <= "00000000000000000000";
    s_inB  <= "00000000000000000000";
    wait for 10 ns;

    -- esperado: 0
    s_inA  <= "11111111111111111111";
    s_inB  <= "11111111111111111111";
    wait for 10 ns;

    -- esperado: 0b1110
    s_inA  <= "00000000000000101101";
    s_inB  <= "00000000000000100011";
    wait for 10 ns;

    -- esperado: 0b1110
    s_inA  <= "00000000000000100011";
    s_inB  <= "00000000000000101101";
    wait for 10 ns;
    -- -------------------------------------------------------------------------

    wait;
  end process;

end Test;
