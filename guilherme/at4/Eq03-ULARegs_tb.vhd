--
-- Título       : Test Bench da ULA + Banco de Registradores
--
-- Autor(es)[RA]: Guilherme Pacheco Batista [2404753]
--                Ramon M. P. Mariano       [2028905]
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ULARegs_tb is
end entity;

architecture Test of ULARegs_tb is
  component ULARegs is
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
  end component;
  signal s_inECONST : std_logic;
  signal s_inCONST  : std_logic_vector(19 downto 0);
  signal s_inA1     : std_logic_vector(3 downto 0);
  signal s_inA2     : std_logic_vector(3 downto 0);
  signal s_inA3     : std_logic_vector(3 downto 0);
  signal s_inWE3    : std_logic;
  signal s_inCLK    : std_logic;
  signal s_inRST    : std_logic;
  signal s_inOP     : std_logic_vector(1 downto 0);
  signal s_outRD1   : std_logic_vector(19 downto 0);
  signal s_outRD2   : std_logic_vector(19 downto 0);
  signal s_outFLAGS : std_logic_vector(1 downto 0);
begin
  UUT : component ULARegs port map(
      inECONST => s_inECONST,
      inCONST  => s_inCONST,
      -- RegFile
      inA1     => s_inA1,
      inA2     => s_inA2,
      inA3     => s_inA3,
      inWE3    => s_inWE3,
      inCLK    => s_inCLK,
      inRST    => s_inRST,
      outRD1   => s_outRD1,
      outRD2   => s_outRD2,
      -- Ula
      inOP     => s_inOP,
      outFLAGS =>s_outFLAGS 
  );
  process begin
    s_inCLK    <= '0';
    s_inECONST <= '0';
    s_inCONST  <= (others => '0');
    s_inA1     <= (others => '0');
    s_inA2     <= (others => '0');
    s_inA3     <= (others => '0');
    s_inWE3    <= '0';
    s_inOP     <= "00";

    s_inRST    <= '1';

    wait for 10 ns;
    s_inCLK    <= '1';
    wait for 10 ns;
    s_inCLK    <= '0';

    s_inRST    <= '0';

    -- -------------------------------------------------------------------------
    -- Inserir RA trucando do Guilherme

    s_inOP     <= "00";
    s_inA1     <= "0000";
    s_inA2     <= "1010";
    s_inA3     <= "1010";
    s_inWE3    <= '1';
    s_inECONST <= '1';
    s_inCONST  <= std_logic_vector(to_unsigned(240, 20));

    wait for 10 ns;
    s_inCLK    <= '1';
    wait for 10 ns;
    s_inCLK    <= '0';

    -- -------------------------------------------------------------------------
    -- Inserir RA trucando do Ramon

    s_inOP     <= "00";
    s_inA1     <= "0000";
    s_inA2     <= "1011";
    s_inA3     <= "1011";
    s_inWE3    <= '1';
    s_inECONST <= '1';
    s_inCONST  <= std_logic_vector(to_unsigned(202, 20));

    wait for 10 ns;
    s_inCLK    <= '1';
    wait for 10 ns;
    s_inCLK    <= '0';

    -- -------------------------------------------------------------------------
    -- Multiplicação

    s_inOP     <= "10";
    s_inA1     <= "1010";
    s_inA2     <= "1011";
    s_inA3     <= "1100";
    s_inWE3    <= '1';
    s_inECONST <= '0';
    s_inCONST  <= (others => '0');

    wait for 10 ns;
    s_inCLK    <= '1';
    wait for 10 ns;
    s_inCLK    <= '0';

    -- -------------------------------------------------------------------------
    -- Checa 1

    s_inOP     <= "00";
    s_inA1     <= "1100";
    s_inA2     <= "1010";
    s_inA3     <= "0000";
    s_inWE3    <= '0';
    s_inECONST <= '0';
    s_inCONST  <= (others => '0');

    wait for 10 ns;
    s_inCLK    <= '1';
    wait for 10 ns;
    s_inCLK    <= '0';

    -- -------------------------------------------------------------------------
    -- Checa 1

    s_inOP     <= "00";
    s_inA1     <= "1100";
    s_inA2     <= "1011";
    s_inA3     <= "0000";
    s_inWE3    <= '0';
    s_inECONST <= '0';
    s_inCONST  <= (others => '0');

    wait for 10 ns;
    s_inCLK    <= '1';
    wait for 10 ns;
    s_inCLK    <= '0';

    -- -------------------------------------------------------------------------

    wait;
  end process;

  -- Reset explícito
  -- Colocar RA's truncados em R10 & R11
  -- Realizar multiplicação e colocar resultado em R12
  -- Verificar o overflow por SW
end architecture;
