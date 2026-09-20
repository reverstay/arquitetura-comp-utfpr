--
-- Título       : Registrador de 20 bits
--
-- Autor(es)[RA]: Guilherme Pacheco Batista[2404753]
--                Ramon M. P. Mariano[2028905]
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Reg20 is
  port(
    inD   : in  std_logic_vector(19 downto 0);
    inCLK : in  std_logic;
    inRST : in  std_logic;
    inWE  : in  std_logic;
    outQ  : out std_logic_vector(19 downto 0)
  );
end entity;

architecture Arch of Reg20 is
begin
  process (inCLK, inRST)
  begin
    if inRST = '1' then
      outQ <= (others => '0');
    elsif rising_edge(inCLK) then
      if inWE = '1' then
        outQ <= inD;
      end if;
    end if;
  end process;
end Arch;
