--
-- Título       : Multiplexador de 16
--
-- Autor(es)[RA]: Guilherme Pacheco Batista[2404753]
--                Ramon M. P. Mariano[2028905]
--
-- https://codereview.stackexchange.com/questions/73708/vhdl-mux-in-need-of-generics
--

-- library ieee;
-- use ieee.std_logic_1164.all;
--
-- package types is
--   type logic_vector_vector is array (natural range <>) of std_logic_vector(19 downto 0);
-- end package;

library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.types.all;

entity Mux16 is
  port(
    inA  : in  logic_vector_vector(15 downto 0);
    inS  : in  std_logic_vector(3 downto 0);
    outX : out std_logic_vector(19 downto 0)
  );
end entity;

architecture Arch of Mux16 is
begin
  outX <= inA(to_integer(unsigned(inS)));
end Arch;
