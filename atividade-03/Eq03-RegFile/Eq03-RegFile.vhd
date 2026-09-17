--
-- Autor(es)[RA]: Guilherme Pacheco Batista[2404753]
--                Ramon M. P. Mariano[2028905]
--
-- Banco de 16 registradores de 20 bits, no estilo MIPS:
--   - leitura combinacional de dois registradores (RD1 e RD2);
--   - escrita sincrona em um registrador (WD3/A3), habilitada por WE3;
--   - registrador 0 vale sempre zero (nao e' instanciado, nem escrito).
--
-- Estrutura interna (mesma do bloco REGISTERS do MIPS X-Ray):
--
--   A3  --> [DECODER 4x16] --+--> s_regEn(1..15) --> chip select de cada Reg20
--   WE3 ------------------- /
--   WD3 --> barramento de escrita, comum a todos os Reg20
--   CLK --> clock de todos os Reg20
--   RST --> reset de todos os Reg20
--   s_regOut(0..15) --> [MUX 16x1 A1] --> RD1
--                   --> [MUX 16x1 A2] --> RD2
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RegFile is
  port(
    CLK : in  std_logic;                      -- clock geral do processador
    RST : in  std_logic;                      -- reset, zera todos os registradores
    WE3 : in  std_logic;                      -- write enable da porta de escrita
    A1  : in  std_logic_vector(3  downto 0);  -- selecao de leitura 1
    A2  : in  std_logic_vector(3  downto 0);  -- selecao de leitura 2
    A3  : in  std_logic_vector(3  downto 0);  -- selecao de escrita
    WD3 : in  std_logic_vector(19 downto 0);  -- dado a ser escrito
    RD1 : out std_logic_vector(19 downto 0);  -- dado lido do registrador A1
    RD2 : out std_logic_vector(19 downto 0)   -- dado lido do registrador A2
  );
end RegFile;

architecture Arch of RegFile is

  type t_regBus is array (0 to 15) of std_logic_vector(19 downto 0);

  signal s_regOut : t_regBus;                     -- saidas dos 16 registradores
  signal s_regEn  : std_logic_vector(15 downto 0);-- chip select de cada registrador

  component Reg20 is
    port(
      CLK : in  std_logic;
      RST : in  std_logic;
      EN  : in  std_logic;
      D   : in  std_logic_vector(19 downto 0);
      Q   : out std_logic_vector(19 downto 0)
    );
  end component;

begin

  -- ---------------------------------------------------------------------------
  -- DECODER DE ESCRITA 4x16
  -- Habilita um unico registrador por vez, e somente quando WE3 = '1'.
  -- A posicao 0 fica sempre desabilitada: o registrador 0 e' constante.
  -- ---------------------------------------------------------------------------
  s_regEn(0) <= '0';

  GEN_DECODER : for i in 1 to 15 generate
    s_regEn(i) <= WE3 when (to_integer(unsigned(A3)) = i) else '0';
  end generate GEN_DECODER;

  -- ---------------------------------------------------------------------------
  -- REGISTRADOR 0: valor fixo em zero (igual ao $zero do MIPS)
  -- ---------------------------------------------------------------------------
  s_regOut(0) <= (others => '0');

  -- ---------------------------------------------------------------------------
  -- REGISTRADORES 1 A 15: instancias do componente Reg20
  -- ---------------------------------------------------------------------------
  GEN_REGS : for i in 1 to 15 generate
    REGx : Reg20 port map(
      CLK => CLK,
      RST => RST,
      EN  => s_regEn(i),
      D   => WD3,
      Q   => s_regOut(i)
    );
  end generate GEN_REGS;

  -- ---------------------------------------------------------------------------
  -- MULTIPLEXADORES DE LEITURA 16x1 (combinacionais)
  -- ---------------------------------------------------------------------------
  RD1 <= s_regOut(to_integer(unsigned(A1)));
  RD2 <= s_regOut(to_integer(unsigned(A2)));

end Arch;
