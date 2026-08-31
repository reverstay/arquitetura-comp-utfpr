library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_decoder is
end tb_decoder;

architecture Simulacao of tb_decoder is

    signal A : STD_LOGIC := '0';
    signal B : STD_LOGIC := '0';
    signal C : STD_LOGIC := '0';
    signal Y : STD_LOGIC_VECTOR(7 downto 0);

begin

    DUT: entity work.decoder3x8
        port map (
            A => A,
            B => B,
            C => C,
            Y => Y
        );

    processo_estimulos: process
    begin
        -- ABC = 000 -> Y0
        A <= '0'; B <= '0'; C <= '0';
        wait for 10 ns;

        -- ABC = 001 -> Y1
        A <= '0'; B <= '0'; C <= '1';
        wait for 10 ns;

        -- ABC = 010 -> Y2
        A <= '0'; B <= '1'; C <= '0';
        wait for 10 ns;

        -- ABC = 011 -> Y3
        A <= '0'; B <= '1'; C <= '1';
        wait for 10 ns;

        -- ABC = 100 -> Y4
        A <= '1'; B <= '0'; C <= '0';
        wait for 10 ns;

        -- ABC = 101 -> Y5
        A <= '1'; B <= '0'; C <= '1';
        wait for 10 ns;

        -- ABC = 110 -> Y6
        A <= '1'; B <= '1'; C <= '0';
        wait for 10 ns;

        -- ABC = 111 -> Y7
        A <= '1'; B <= '1'; C <= '1';
        wait for 10 ns;

        wait;
    end process;

end Simulacao;
