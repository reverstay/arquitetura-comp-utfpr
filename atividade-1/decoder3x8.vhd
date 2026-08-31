library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decoder3x8 is
    Port (
        A : in STD_LOGIC;
        B : in STD_LOGIC;
        C : in STD_LOGIC;
        Y : out STD_LOGIC_VECTOR(7 downto 0)
    );
end decoder3x8;

architecture LogicaBooleana of decoder3x8 is
begin

    -- Decoder 3x8 implementado com lógica booleana
    -- Cada saída corresponde a um mintermo das entradas A, B e C

    Y(0) <= (not A) and (not B) and (not C); -- 000
    Y(1) <= (not A) and (not B) and C;       -- 001
    Y(2) <= (not A) and B and (not C);       -- 010
    Y(3) <= (not A) and B and C;             -- 011
    Y(4) <= A and (not B) and (not C);       -- 100
    Y(5) <= A and (not B) and C;             -- 101
    Y(6) <= A and B and (not C);             -- 110
    Y(7) <= A and B and C;                   -- 111

end LogicaBooleana;
