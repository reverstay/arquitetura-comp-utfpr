--  Equipe 3
-- Autores [RA]: Guilherme Pacheco Batista [2404753]
--               Ramon Miguel Pinto Mariano [2028905]
--
-- ULA combinacional de 4 bits e 3 operacoes
--   inOP = "00" : A + B
--   inOP = "01" : A - B
--   inOP = "10" : A * B   (produto truncado em 4 bits, ou seja, modulo 16)
--   inOP = "11" : nao usada (resultado 0)
-- Flags:
--   outZ  : resultado igual a zero
--   outLT : A < B (sem sinal)

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Ula is
  port(
    inOP  : in  std_logic_vector(1 downto 0);
    inA   : in  unsigned(3 downto 0);
    inB   : in  unsigned(3 downto 0);
    outR  : out unsigned(3 downto 0);
    outZ  : out std_logic;
    outLT : out std_logic
  );
end Ula;

architecture Arch of Ula is
  signal s_outR : unsigned(3 downto 0);
begin
  -- o produto de dois valores de 4 bits tem 8 bits; resize() mantem os 4 bits
  -- menos significativos, preservando a interface de 4 bits da ULA
  s_outR <= (inA + inB)             when inOP = "00" else
            (inA - inB)             when inOP = "01" else
            resize(inA * inB, 4)    when inOP = "10" else
            "0000";

  outR  <= s_outR;
  outZ  <= '1' when s_outR = "0000" else '0';
  outLT <= '1' when inA < inB else '0';
end Arch;
