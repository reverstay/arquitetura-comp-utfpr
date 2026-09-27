--
-- Título       : Banco de registradores de 20 bits (estilo Mips)
--
-- Autor(es)[RA]: Guilherme Pacheco Batista[2404753]
--                Ramon M. P. Mariano[2028905]
--
-- https://stackoverflow.com/questions/19942067/writing-a-register-file-in-vhdl
-- https://www.fpgatutorial.com/vhdl-types-and-conversions/
-- https://stackoverflow.com/questions/62387433/best-way-to-port-map-to-multiple-entities
-- https://vhdlwhiz.com/generate-statement/
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

entity RegFile is
  port(
    inA1   : in std_logic_vector(3 downto 0);
    inA2   : in std_logic_vector(3 downto 0);
    inA3   : in std_logic_vector(3 downto 0);
    inWD3  : in std_logic_vector(19 downto 0);
    inWE3  : in std_logic;
    inCLK  : in std_logic;
    inRST  : in std_logic;
    outRD1 : out std_logic_vector(19 downto 0);
    outRD2 : out std_logic_vector(19 downto 0)
  );
end entity;

architecture Arch of RegFile is
  component Reg20 is
    port(
      inD   : in  std_logic_vector(19 downto 0);
      inCLK : in  std_logic;
      inRST : in  std_logic;
      inWE  : in  std_logic;
      outQ  : out std_logic_vector(19 downto 0)
    );
  end component;
  component Mux16 is
    port(
      inA  : in  logic_vector_vector(15 downto 0);
      inS  : in  std_logic_vector(3 downto 0);
      outX : out std_logic_vector(19 downto 0)
    );
  end component;
  component Dec16 is
    port(
      inA  : in  std_logic_vector(3  downto 0);
      outX : out std_logic_vector(15 downto 0)
    );
  end component;
  signal s_outDec   :    std_logic_vector(15 downto 0);
  signal s_outAnd   :    std_logic_vector(15 downto 0);
  signal s_outR     : logic_vector_vector(15 downto 0);
begin
  Dec : Dec16 port map(
    inA  => inA3,
    outX => s_outDec
  );
  s_outAnd <= s_outDec and (15 downto 0 => inWE3);

  s_outR(0) <= (others => '0');
  Gen_Regs : for idx in 1 to 15 generate
    Reg : Reg20 port map(
      inD   => inWD3,
      inCLK => inCLK,
      inRST => inRST,
      inWE  => s_outAnd(idx),
      outQ  => s_outR(idx)
    );
  end generate;

  Mux_inst1 : Mux16 port map(
    inA  => s_outR,
    inS  => inA1,
    outX => outRD1
  );
  Mux_inst2 : Mux16 port map(
    inA  => s_outR,
    inS  => inA2,
    outX => outRD2
  );
end Arch;
