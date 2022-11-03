LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY tp1 IS
    PORT (
        din : IN STD_LOGIC; -- Entada
        clock : IN STD_LOGIC; -- Entada
        reset : IN STD_LOGIC; -- Entada

        prog : IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- Entada
        padrao : IN STD_LOGIC_VECTOR(7 DOWNTO 0); -- Entrada

        dout : OUT STD_LOGIC; -- Saída
        alarme : OUT STD_LOGIC; -- Saída

    );

END ENTITY;
ARCHITECTURE tp1 OF tp1 IS
    --implementação do reg_din SR
BEGIN

    TYPE STATE IS (IDLE, p1, p2, p3, BSC, PR, BLK, RESET); -- Etapas da máquina de estados

    SIGNAL EA : state; -- Estado atual
    SIGNAL EF : state; -- Estado futuro 

    --reg_din = escadinha deitada no inicio do circuito

    SIGNAL reg_din : STD_LOGIC_VECTOR(7 DOWNTO 0);

    -- implementação dos sinais possíveis
    SIGNAL P1 : STD_LOGIC_VECTOR(7 DOWNTO 0) := "--";
    SIGNAL P2 : STD_LOGIC_VECTOR(7 DOWNTO 0) := "--";
    SIGNAL P3 : STD_LOGIC_VECTOR(7 DOWNTO 0) := "--";

    SIGNAL C_P1 : STD_LOGIC := '0';
    SIGNAL C_P2 : STD_LOGIC := '0';
    SIGNAL C_P3 : STD_LOGIC := '0';

    SIGNAL valid_P1 : STD_LOGIC := '0';
    SIGNAL valid_P2 : STD_LOGIC := '0';
    SIGNAL valid_P3 : STD_LOGIC := '0';

    SIGNAL match_P1 : STD_LOGIC := '--';
    SIGNAL match_P2 : STD_LOGIC := '--';
    SIGNAL match_P3 : STD_LOGIC := '--';
    SIGNAL match : STD_LOGIC := '--';

    -- signal cont: std_logic_vector(1 downto 0) := "00";
    -- signal alarme_int: std_logic := '0';
    -- implementação dos registadores

    -- P1
BEGIN
    SR PROCESS (clock)
BEGIN
    IF clock'event AND clock = '1' THEN
        reg_din(7) <= din;
        reg_din(6 DOWNTO 0) <= reg_din(7 DOWNTO 1)
    END IF;
END PROCESS SR;

-- implementação de um flip flop do tipo 1
BEGIN
flip_flop : PROCESS (clock)
BEGIN
    IF clock'event AND clock = '1'THEN
        Q <= padrao; -- será que tem q declarar esse Q em algum lugar?
        EA <= NOT padrao;
    END IF;
END PROCESS flip_flop;

--implementação de um flip flop do tipo 2
BEGIN
flip_flop_mux : PROCESS (clock)
BEGIN
    IF clock'event AND clock = '1' THEN
        Q <= -- MUX 2:1 
            EA <= -- NOT MUX 2:1
        END IF;
    END PROCESS flip_flop_mux;

    -- implementação do mux 2:1
BEGIN
BEGIN
    mux : PROCESS (1, 0, EA) -- tem q conferir como coloca as entradas fixadas em um e zero bonitinho
    BEGIN
        IF EA = '0' THEN
            -- D <= 
