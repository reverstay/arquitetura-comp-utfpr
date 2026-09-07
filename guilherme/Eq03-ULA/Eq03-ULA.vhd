--
-- Autor(es)[RA]: Guilherme Pacheco Batista[2404753]
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Ula is
  port(
    inOP  : in  std_logic_vector(1  downto 0);
    inA   : in          unsigned(19 downto 0);
    inB   : in          unsigned(19 downto 0);
    outR  : out         unsigned(19 downto 0);
    outZ  : out                     std_logic;
    outLT : out                     std_logic
  );
end Ula;

architecture Arch of Ula is
  signal s_outR : unsigned(19 downto 0);
begin
  s_outR  <= (inA + inB)                                  when inOP = "00" else
             (inA - inB)                                  when inOP = "01" else
             resize(inA * inB, 20)                        when inOP = "10" else
             ((inA and (not inB)) or ((not inA) and inB)) when inOP = "11" else
             "00000000000000000000";
  outR  <= s_outR;
  outZ  <= '1' when s_outR = "00000000000000000000" else '0';
  outLT <= '1' when inA < inB else '0';
end Arch;
