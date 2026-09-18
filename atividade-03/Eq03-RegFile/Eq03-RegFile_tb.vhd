--
-- Autor(es)[RA]: Guilherme Pacheco Batista[2404753]
--                Ramon M. P. Mariano[2028905]
--
-- Test bench do banco de 16 registradores de 20 bits.
--
-- Roteiro:
--   1) reset explicito, zerando todos os registradores;
--   2) escrita dos RAs da equipe em dois registradores distintos, R9 e R11;
--   3) leitura dos dois RAs em RD2;
--   4) leitura dos dois RAs em RD1;
--   5) tentativa de escrita em R0 (deve continuar em zero);
--   6) reset final, mostrando o banco voltando a zero.
--
-- Observacao sobre os RAs: o registrador tem 20 bits e o maior valor que ele
-- representa e' 1048575, entao os RAs completos nao cabem. Foram usados os
-- seis digitos decimais menos significativos de cada RA, que continuam
-- legiveis na simulacao quando os barramentos sao exibidos em decimal:
--   Guilherme: RA 2404753 -> 404753
--   Ramon    : RA 2028905 ->  28905
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RegFile_tb is
end RegFile_tb;

architecture Test of RegFile_tb is

  constant c_PERIODO : time := 20 ns;

  -- RAs da equipe, em decimal (seis digitos menos significativos) --------------
  constant c_RA_GUILHERME : std_logic_vector(19 downto 0) :=
             std_logic_vector(to_unsigned(404753, 20));  -- RA 2404753
  constant c_RA_RAMON     : std_logic_vector(19 downto 0) :=
             std_logic_vector(to_unsigned( 28905, 20));  -- RA 2028905

  signal s_CLK : std_logic := '0';
  signal s_RST : std_logic := '0';
  signal s_WE3 : std_logic := '0';
  signal s_A1  : std_logic_vector(3  downto 0) := (others => '0');
  signal s_A2  : std_logic_vector(3  downto 0) := (others => '0');
  signal s_A3  : std_logic_vector(3  downto 0) := (others => '0');
  signal s_WD3 : std_logic_vector(19 downto 0) := (others => '0');
  signal s_RD1 : std_logic_vector(19 downto 0);
  signal s_RD2 : std_logic_vector(19 downto 0);

  signal s_fim : boolean := false;

  component RegFile is
    port(
      CLK : in  std_logic;
      RST : in  std_logic;
      WE3 : in  std_logic;
      A1  : in  std_logic_vector(3  downto 0);
      A2  : in  std_logic_vector(3  downto 0);
      A3  : in  std_logic_vector(3  downto 0);
      WD3 : in  std_logic_vector(19 downto 0);
      RD1 : out std_logic_vector(19 downto 0);
      RD2 : out std_logic_vector(19 downto 0)
    );
  end component;

begin

  DUT : entity work.RegFile port map(
    CLK => s_CLK,
    RST => s_RST,
    WE3 => s_WE3,
    A1  => s_A1 ,
    A2  => s_A2 ,
    A3  => s_A3 ,
    WD3 => s_WD3,
    RD1 => s_RD1,
    RD2 => s_RD2
  );

  -- Gerador de clock: bordas de subida em 10 ns, 30 ns, 50 ns, ...
  s_CLK <= not s_CLK after c_PERIODO / 2 when not s_fim else '0';

  process begin

    -- 1) RESET EXPLICITO --------------------------------------------------------
    s_RST <= '1';
    s_WE3 <= '0';
    s_A1  <= "0000";
    s_A2  <= "0000";
    s_A3  <= "0000";
    s_WD3 <= (others => '0');
    wait for 25 ns;          -- cobre uma borda de subida com o reset ativo
    s_RST <= '0';

    -- 2) ESCRITA DOS RAs EM R9 E R11 --------------------------------------------
    -- R9 <= RA do Guilherme
    s_A3  <= "1001";
    s_WD3 <= c_RA_GUILHERME;
    s_WE3 <= '1';
    wait for 20 ns;          -- escrita efetivada na borda de subida em 30 ns

    -- R11 <= RA do Ramon
    s_A3  <= "1011";
    s_WD3 <= c_RA_RAMON;
    wait for 20 ns;          -- borda em 50 ns

    -- Encerra a escrita
    s_WE3 <= '0';
    s_A3  <= "0000";
    s_WD3 <= (others => '0');
    wait for 20 ns;

    -- 3) LEITURA DOS DOIS RAs EM RD2 --------------------------------------------
    s_A1 <= "0000";          -- RD1 fica no registrador 0 (zero)

    s_A2 <= "1001";          -- RD2 = RA do Guilherme
    wait for 20 ns;
    s_A2 <= "1011";          -- RD2 = RA do Ramon
    wait for 20 ns;
    s_A2 <= "0000";          -- RD2 = 0 (registrador 0)
    wait for 20 ns;

    -- 4) LEITURA DOS DOIS RAs EM RD1 --------------------------------------------
    s_A2 <= "0000";          -- RD2 fica no registrador 0 (zero)

    s_A1 <= "1001";          -- RD1 = RA do Guilherme
    wait for 20 ns;
    s_A1 <= "1011";          -- RD1 = RA do Ramon
    wait for 20 ns;
    s_A1 <= "0000";          -- RD1 = 0 (registrador 0)
    wait for 20 ns;

    -- 5) TENTATIVA DE ESCRITA NO REGISTRADOR 0 ----------------------------------
    -- O registrador 0 e' constante: mesmo com WE3 ativo ele continua em zero.
    s_A3  <= "0000";
    s_WD3 <= x"FFFFF";
    s_WE3 <= '1';
    wait for 20 ns;
    s_WE3 <= '0';
    s_WD3 <= (others => '0');
    s_A1  <= "0000";
    s_A2  <= "0000";
    wait for 20 ns;

    -- 6) RESET FINAL -------------------------------------------------------------
    -- Com R9 e R11 nas saidas, o reset zera o banco inteiro.
    s_A1 <= "1001";
    s_A2 <= "1011";
    wait for 20 ns;
    s_RST <= '1';
    wait for 20 ns;
    s_RST <= '0';
    wait for 20 ns;

    s_fim <= true;
    wait;
  end process;

end Test;
