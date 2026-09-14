-- UTFPR - DAELN
-- Professores Rafael E. de Goes e Juliano Mourao Vieira
-- Disciplina de Arquitetura e Organizacao de Computadores
-- versao 1.1 - 2019-10-22
-- versão 2.0 - 2022-03-11 - adaptação para a placa DE10-Lite
-- versão 2.1 - limpeza para circuito combinacional apenas
-- versão 3.0 - Equipe 03 - tarefa 1: logica alterada (LEDs = f(chaves, botoes))
--
-- Mapeamento (botoes KEY0/KEY1 sao ativos em nivel baixo):
--   LED0 = SW0 and SW1
--   LED1 = SW0 or  SW1
--   LED2 = SW0 xor SW1
--   LED3 = not SW2
--   LED4 = SW3 nand SW4
--   LED5 = SW5 nor  SW6
--   LED6 = maioria(SW7, SW8, SW9)
--   LED7 = paridade de SW9..SW0 (1 se numero impar de chaves ligadas)
--   LED8 = SW8 and KEY0 pressionado
--   LED9 = SW9 or  KEY1 pressionado
--   HEX2..HEX0 : quantidade de chaves ligadas (0 a 10);
--                com KEY1 pressionado mostra SW7..SW0 em decimal (0 a 255)
--   HEX3       : '-' enquanto KEY0 estiver pressionado
--   HEX5, HEX4 : SW7..SW4 e SW3..SW0 em hexadecimal

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity toplevel is
    -- sinais que sao usados no toplevel, mapeados no hardware da placa
    -- (substituem o que vinha do testbench)
    port (
        --- clock master da placa ligado na FPGA
        CLK_H_HW : in std_logic;                 -- PIN_N14 (50 MHz)

        -- sinais que sao a interface de teste no HW fisico
        RST_HW : in std_logic;               -- KEY0 PIN_B8
        KEY1_HW:    in std_logic;            -- KEY1 PIN_A7

        SWITCH_HW : in unsigned (9 downto 0);  --SW9 a SW0  (PINS F15, B14, A14, A13, B12, A12, C12, D12, C11, C10)
        LED_HW        : out unsigned (9 downto 0);    -- LED9..LED0 (PINS B11, A11, D14, E14, C13, D13, B10, A10, A9, A8)

        -- displays da placa conectados na FPGA
        HEX0_HW: out std_logic_vector(6 downto 0);   -- display 7 segmentos (LSd)
        HEX1_HW: out std_logic_vector(6 downto 0);   -- display 7 segmentos
        HEX2_HW: out std_logic_vector(6 downto 0);   -- display 7 segmentos
        HEX3_HW: out std_logic_vector(6 downto 0);   -- display 7 segmentos
        HEX4_HW: out std_logic_vector(6 downto 0);   -- display 7 segmentos
        HEX5_HW: out std_logic_vector(6 downto 0)    -- display 7 segmentos (MSd)
    );
end entity;

architecture arch of toplevel is
    component displays is
        port(
            dado_in   : in unsigned (7 downto 0);
            neg_in    : in std_logic;
            hex4_in   : in unsigned (3 downto 0);
            hex5_in   : in unsigned (3 downto 0);
            disp0_out : out std_logic_vector(6 downto 0);
            disp1_out : out std_logic_vector(6 downto 0);
            disp2_out : out std_logic_vector(6 downto 0);
            disp3_out : out std_logic_vector(6 downto 0);
            disp4_out : out std_logic_vector(6 downto 0);
            disp5_out : out std_logic_vector(6 downto 0)
        );
    end component;

    signal key0, key1   : std_logic;              -- botoes em logica positiva
    signal chaves_on    : unsigned(7 downto 0);   -- quantidade de chaves ligadas
    signal mostra_disp  : unsigned(7 downto 0);   -- numero a mostrar no display

begin
    display: displays port map (
            dado_in   => mostra_disp,
            neg_in    => key0,
            hex4_in   => SWITCH_HW(3 downto 0),
            hex5_in   => SWITCH_HW(7 downto 4),
            disp0_out => HEX0_HW,
            disp1_out => HEX1_HW,
            disp2_out => HEX2_HW,
            disp3_out => HEX3_HW,
            disp4_out => HEX4_HW,
            disp5_out => HEX5_HW);

    key0 <= not RST_HW;
    key1 <= not KEY1_HW;

    -- contagem das chaves ligadas
    process (SWITCH_HW)
        variable cont : unsigned(7 downto 0);
    begin
        cont := (others => '0');
        for i in SWITCH_HW'range loop
            if SWITCH_HW(i) = '1' then
                cont := cont + 1;
            end if;
        end loop;
        chaves_on <= cont;
    end process;

    mostra_disp <= SWITCH_HW(7 downto 0) when key1 = '1' else chaves_on;

    -- leds da placa: funcoes logicas das chaves e dos botoes
    LED_HW(0) <= SWITCH_HW(0) and SWITCH_HW(1);
    LED_HW(1) <= SWITCH_HW(0) or  SWITCH_HW(1);
    LED_HW(2) <= SWITCH_HW(0) xor SWITCH_HW(1);
    LED_HW(3) <= not SWITCH_HW(2);
    LED_HW(4) <= SWITCH_HW(3) nand SWITCH_HW(4);
    LED_HW(5) <= SWITCH_HW(5) nor  SWITCH_HW(6);
    LED_HW(6) <= (SWITCH_HW(7) and SWITCH_HW(8)) or
                 (SWITCH_HW(7) and SWITCH_HW(9)) or
                 (SWITCH_HW(8) and SWITCH_HW(9));
    LED_HW(7) <= chaves_on(0);
    LED_HW(8) <= SWITCH_HW(8) and key0;
    LED_HW(9) <= SWITCH_HW(9) or  key1;

end architecture ;
