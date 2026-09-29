--
-- Título       : ULA + Banco de Registradores
--
-- Autor(es)[RA]: Guilherme Pacheco Batista [2404753]
--                Ramon M. P. Mariano       [2028905]
--

library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.types.all;

entity ULARegs is
  port(
    inECONST : in std_logic;                     -- Enable Constant. Para o MUX.
    inCONST  : in std_logic_vector(19 downto 0);
    -- RegFile
    inA1     : in std_logic_vector(3 downto 0);
    inA2     : in std_logic_vector(3 downto 0);
    inA3     : in std_logic_vector(3 downto 0);
    inWE3    : in std_logic;
    inCLK    : in std_logic;
    inRST    : in std_logic;
    outRD1   : out std_logic_vector(19 downto 0);
    outRD2   : out std_logic_vector(19 downto 0);
    -- Ula
    inOP     : in std_logic_vector(1 downto 0);
    outFLAGS : out std_logic_vector(1 downto 0)
  );
end entity;

architecture Arch of ULARegs is
  component Mux2 is
    port(
      inA  : in  std_logic_vector(19 downto 0);
      inB  : in  std_logic_vector(19 downto 0);
      inS  : in  std_logic;
      outX : out std_logic_vector(19 downto 0)
    );
  end component;
  component RegFile is
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
  end component;
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
  signal s_RegFile_WD3 : unsigned(19 downto 0);
  signal s_RegFile_RD1 : std_logic_vector(19 downto 0);
  signal s_RegFile_RD2: std_logic_vector(19 downto 0);
  signal s_Mux_Const : std_logic_vector(19 downto 0);
begin
  RegFile_inst : RegFile port map(
    inA1   => inA1,
    inA2   => inA2,
    inA3   => inA3,
    inWD3  => std_logic_vector(s_RegFile_WD3),
    inWE3  => inWE3,
    inCLK  => inCLK,
    inRST  => inRST,
    outRD1 => s_RegFile_RD1,
    outRD2 => s_RegFile_RD2
  );
  Mux_inst : Mux2 port map(
    inA  => s_RegFile_RD2,
    inB  => inCONST,
    inS  => inECONST,
    outX => s_Mux_Const
  );
  Ula_inst : Ula port map(
    inOP  => inOP,
    inA   => unsigned(s_RegFile_RD1),
    inB   => unsigned(s_Mux_Const),
    outR  => s_RegFile_WD3,
    outZ  => outFLAGS(0),
    outLT => outFLAGS(1)
  );
  outRD1 <= s_RegFile_RD1;
  outRD2 <= s_RegFile_RD2;
end Arch;
