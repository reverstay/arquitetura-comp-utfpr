--
-- Título       : Test Bench do banco de registradores
--
-- Autor(es)[RA]: Guilherme Pacheco Batista[2404753]
--                Ramon M. P. Mariano[2028905]
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RegFile_tb is
end entity;

architecture Test of RegFile_tb is
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
  signal s_inA1   : std_logic_vector(3 downto 0);
  signal s_inA2   : std_logic_vector(3 downto 0);
  signal s_inA3   : std_logic_vector(3 downto 0);
  signal s_inWD3  : std_logic_vector(19 downto 0);
  signal s_inWE3  : std_logic;
  signal s_inCLK  : std_logic;
  signal s_inRST  : std_logic;
  signal s_outRD1 : std_logic_vector(19 downto 0);
  signal s_outRD2 : std_logic_vector(19 downto 0);
begin
  UUT : component RegFile port map (
    inA1   => s_inA1,
    inA2   => s_inA2,
    inA3   => s_inA3,
    inWD3  => s_inWD3,
    inWE3  => s_inWE3,
    inCLK  => s_inCLK,
    inRST  => s_inRST,
    outRD1 => s_outRD1,
    outRD2 => s_outRD2
  );
  process begin
    -- Para mais facilmente testar para reset ON e OFF os mesmos testes.
    for idx in 1 downto 0 loop
      if idx = 1 then
        s_inRST <= '1';
      else
        s_inRST <= '0';
      end if;

      -- .........................................................................
      -- Zerar tudo e iniciar.

      s_inA1  <= (others => '0');
      s_inA2  <= (others => '0');

      s_inA3  <= (others => '0');
      s_inWE3 <= '0';
      s_inWD3 <= (others => '0');

      s_inCLK <= '0';
      wait for 50 ns;
      s_inCLK <= '1';
      wait for 50 ns;

      -- .........................................................................
      -- Ligar a escrita e escrever algo no R0, que deveria não mudar.

      s_inA1  <= (others => '0');
      s_inA2  <= (others => '0');

      s_inA3  <= (others => '0');
      s_inWE3 <= '1';
      s_inWD3 <= (0 => '0', others => '1');

      s_inCLK <= '0';
      wait for 50 ns;
      s_inCLK <= '1';
      wait for 50 ns;

      -- .........................................................................
      -- Checar.

      s_inA1  <= (others => '0');
      s_inA2  <= (others => '0');

      s_inA3  <= (others => '0');
      s_inWE3 <= '0';
      s_inWD3 <= (others => '0');

      s_inCLK <= '0';
      wait for 50 ns;
      s_inCLK <= '1';
      wait for 50 ns;

      -- .........................................................................
      -- Escrever algo em R1.

      s_inA1  <= (others => '0');
      s_inA2  <= "0001";

      s_inA3  <= "0001";
      s_inWE3 <= '1';
      s_inWD3 <= (0 => '0', others => '1');

      s_inCLK <= '0';
      wait for 50 ns;
      s_inCLK <= '1';
      wait for 50 ns;

      -- .........................................................................
      -- Checar.

      s_inA1  <= (others => '0');
      s_inA2  <= "0001";

      s_inA3  <= "0001";
      s_inWE3 <= '0';
      s_inWD3 <= (others => '0');

      s_inCLK <= '0';
      wait for 50 ns;
      s_inCLK <= '1';
      wait for 50 ns;

      -- .........................................................................
      -- Escrever algo em R13.

      s_inA1  <= (others => '0');
      s_inA2  <= "1101";

      s_inA3  <= "1101";
      s_inWE3 <= '1';
      s_inWD3 <= (0 => '0', 7 => '0', others => '1');

      s_inCLK <= '0';
      wait for 50 ns;
      s_inCLK <= '1';
      wait for 50 ns;

      -- .........................................................................
      -- Checar.

      s_inA1  <= (others => '0');
      s_inA2  <= "1101";

      s_inA3  <= "1101";
      s_inWE3 <= '0';
      s_inWD3 <= (others => '0');

      s_inCLK <= '0';
      wait for 50 ns;
      s_inCLK <= '1';
      wait for 50 ns;

      -- .........................................................................
      -- Escrever algo em R7.

      s_inA1  <= "0111";
      s_inA2  <= (others => '0');

      s_inA3  <= "0111";
      s_inWE3 <= '1';
      s_inWD3 <= (0 => '0', 7 => '0', 18 => '0', others => '1');

      s_inCLK <= '0';
      wait for 50 ns;
      s_inCLK <= '1';
      wait for 50 ns;

      -- .........................................................................
      -- Checar.

      s_inA1  <= "0111";
      s_inA2  <= "1101";

      s_inA3  <= (others => '0');
      s_inWE3 <= '0';
      s_inWD3 <= (others => '0');

      s_inCLK <= '0';
      wait for 50 ns;
      s_inCLK <= '1';
      wait for 50 ns;

    end loop;

    wait;
  end process;
end architecture;
