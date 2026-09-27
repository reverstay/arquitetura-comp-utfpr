--
-- Título       : Multiplexador de 2
--
-- Autor(es)[RA]: Guilherme Pacheco Batista[2404753]
--                Ramon M. P. Mariano[2028905]
--

library ieee;
use ieee.std_logic_1164.all;

entity Mux2 is
  port(
    inA  : in  std_logic_vector(19 downto 0);
    inB  : in  std_logic_vector(19 downto 0);
    inS  : in  std_logic;
    outX : out std_logic_vector(19 downto 0)
  );
end entity;

architecture Arch of Mux2 is
begin
  outX <= inB when inS = '1' else inA;
end Arch;
