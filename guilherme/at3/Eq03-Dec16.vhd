--
-- Título       : Decoder de 16
--
-- Autor(es)[RA]: Guilherme Pacheco Batista[2404753]
--                Ramon M. P. Mariano[2028905]
--

library ieee;
use ieee.std_logic_1164.all;

package types is
  type logic_vector_vector is array (natural range <>) of std_logic_vector(19 downto 0);
end package;

library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.types.all;

entity Dec16 is
  port(
    inA  : in  std_logic_vector(3  downto 0);
    outX : out std_logic_vector(15 downto 0)
  );
end entity;

architecture Arch of Dec16 is
begin
  outX <= "0000000000000001" when inA = "0000" else
          "0000000000000010" when inA = "0001" else
          "0000000000000100" when inA = "0010" else
          "0000000000001000" when inA = "0011" else
          "0000000000010000" when inA = "0100" else
          "0000000000100000" when inA = "0101" else
          "0000000001000000" when inA = "0110" else
          "0000000010000000" when inA = "0111" else
          "0000000100000000" when inA = "1000" else
          "0000001000000000" when inA = "1001" else
          "0000010000000000" when inA = "1010" else
          "0000100000000000" when inA = "1011" else
          "0001000000000000" when inA = "1100" else
          "0010000000000000" when inA = "1101" else
          "0100000000000000" when inA = "1110" else
          "1000000000000000" when inA = "1111";
end Arch;
