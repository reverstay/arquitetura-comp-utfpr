--
-- Autor(es)[RA]: Guilherme Pacheco Batista[2404753]
--                Ramon M. P. Mariano[2028905]
--
-- Registrador de 20 bits com clock enable e reset assincrono.
-- Bloco basico do banco de registradores (Eq03-RegFile.vhd).
--
-- Correlacao com o diagrama do MIPS X-Ray:
--   CLK -> clock geral do processador
--   RST -> reset (zera o registrador)
--   EN  -> chip select vindo do decoder de escrita (WE3 + A3)
--   D   -> barramento de escrita (WD3)
--   Q   -> saida permanente do registrador, vai para os dois mux de leitura
--

library ieee;
use ieee.std_logic_1164.all;

entity Reg20 is
  port(
    CLK : in  std_logic;                      -- clock geral
    RST : in  std_logic;                      -- reset assincrono, ativo alto
    EN  : in  std_logic;                      -- chip select / clock enable
    D   : in  std_logic_vector(19 downto 0);  -- dado de entrada
    Q   : out std_logic_vector(19 downto 0)   -- dado armazenado
  );
end Reg20;

architecture Arch of Reg20 is
  signal s_Q : std_logic_vector(19 downto 0);
begin

  process(CLK, RST)
  begin
    if RST = '1' then
      s_Q <= (others => '0');
    elsif rising_edge(CLK) then
      if EN = '1' then
        s_Q <= D;
      end if;
    end if;
  end process;

  Q <= s_Q;

end Arch;
