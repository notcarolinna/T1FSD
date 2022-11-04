-- A partir da 189 tem coisa nova ;)

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY tp1 IS
    PORT (
        din : IN STD_LOGIC; -- Entada
        clock : IN STD_LOGIC; -- Entada
        reset : IN STD_LOGIC; -- Entada
        a : IN STD_LOGIC; -- Entrada
        b : IN STD_LOGIC; -- Entrada

        prog : IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- Entada
        padrao : IN STD_LOGIC_VECTOR(7 DOWNTO 0); -- Entrada

        dout : OUT STD_LOGIC; -- Saída
        alarme : OUT STD_LOGIC; -- Saída

    );

END ENTITY;
ARCHITECTURE tp1 OF tp1 IS
BEGIN

    TYPE STATE IS (IDLE, p1, p2, p3, BSC, PR, BLK, RESET); -- Etapas da máquina de estados

    SIGNAL EA : state; -- Estado atual
    SIGNAL EF : state; -- Estado futuro 
    SIGNAL reg_din : STD_LOGIC_VECTOR(7 DOWNTO 0);

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

BEGIN
    SR PROCESS (clock)
BEGIN
    IF clock'event AND clock = '1' THEN
        reg_din(7) <= din;
        reg_din(6 DOWNTO 0) <= reg_din(7 DOWNTO 1)
    END IF;
END PROCESS SR;

-- MÁQUINA DE ESTADOS -------------------------------------------------------------------------------------------------------

PROCESS ()
BEGIN
    CASE EA IS

        WHEN IDLE => -- prog {1,2,3} programando {p1, p2, p3} 
            IF prog = "001" THEN
                EF <= p1;
            ELSIF prog = "010" THEN
                EF = p2;
            ELSIF prog = "011" THEN
                EF <= p3;
            ELSIF prog = "100" THEN
                EF <= BSC;
            END IF;

            ---------------------------------------------------

        WHEN BSC => -- quando estiver no busca
            IF match = '1' THEN -- se deu match vai pro PER
                EF <= PER;

            ELSIF prog = "101" THEN -- se o prog = 5, vai pro BLK
                EF <= BLK;

            ELSIF prog = "111" THEN -- se o prog = 7, vai pro RESET
                EF <= RESET;
            END IF;

            ---------------------------------------------------

        WHEN PER => -- quando estiver no perigo
            IF cont = "11" THEN -- se o cont = 3, volta pro busca
                EF <= BSC;
            END IF;

            ---------------------------------------------------

        WHEN BLK => -- quando estiver bloqueado
            IF prog = "110" THEN -- se o prog = 6, volta para a busca
                EF <= BSC;
            ELSIF prog = "111" THEN -- se o prog = 7, vai pro reset
                EF <= RESET;
            END IF;

            ---------------------------------------------------

        WHEN RESET => -- quando estiver no reset
            IF prog = "000" THEN -- se prog = 0, vai para o IDLE
                EF <= IDLE;
            END IF;

            -- implementação de um flip flop do tipo 1 -----------------------------------------------------------------------------------

        BEGIN
            flip_flop : PROCESS (clock)
            BEGIN
                IF clock'event AND clock = '1'THEN
                    P1 <= padrao;
                    EA <= NOT padrao;
                END IF;
            END PROCESS flip_flop;

        BEGIN
            flip_flop : PROCESS (clock)
            BEGIN
                IF clock'event AND clock = '1'THEN
                    P2 <= padrao;
                    EA <= NOT padrao;
                END IF;
            END PROCESS flip_flop;

        BEGIN
            flip_flop : PROCESS (clock)
            BEGIN
                IF clock'event AND clock = '1'THEN
                    P3 <= padrao;
                    EA <= NOT padrao;
                END IF;
            END PROCESS flip_flop;

            --implementação de um flip flop do tipo 2 --------------------------------------------------------------------------------------

        BEGIN
            flip_flop_mux : PROCESS (clock)
            BEGIN
                IF clock'event AND clock = '1' THEN
                    valid_P1 <= ;-- MUX 2:1 
                    EA <= ;-- NOT MUX 2:1
                END IF;
            END PROCESS flip_flop_mux;

        BEGIN
            flip_flop_mux : PROCESS (clock)
            BEGIN
                IF clock'event AND clock = '1' THEN
                    valid_P2 <= ; -- MUX 2:1 
                    EA <= ;-- NOT MUX 2:1
                END IF;
            END PROCESS flip_flop_mux;

        BEGIN
            flip_flop_mux : PROCESS (clock)
            BEGIN
                IF clock'event AND clock = '1' THEN
                    valid_P3 <= ; -- MUX 2:1 
                    EA <= ;-- NOT MUX 2:1
                END IF;
            END PROCESS flip_flop_mux;

            ---------------------------------------------------

            -- implementação do mux 2:1 ------------------------------------------------------------------------------------------------------
        BEGIN
            mux : PROCESS (a, b, EA) -- tem q conferir como coloca as entradas fixadas em um e zero bonitinho
            BEGIN
                a <= '1';
                b <= '0';
                IF EA = '1'THEN
                    -- D <= a;
                ELSIF EA = '0' THEN
                    -- D  <= b;
                END IF;
            END PROCESS mux;

            -- Implementação de registradores -----------------------------------------------------

            -- rising_edge é uma subida de clock.

            PROCESS () -- Confirma se aqui dentro realmente vai o clock e reset
            BEGIN
                IF reset = '1' THEN
                    P1 <= (); -- tb n sei oq vai aqui dentro
                ELSIF rising_edge(clock) THEN
                    IF EA = p1 THEN
                        P1 <= ; -- provavelmente aqui dentro vai um padrão, tenta perguntar pra alguém tomaz
                    END IF;
                END IF;
            END PROCESS;

            -- No caso será necessário implementar a mesma coisa pro p2 e p3, só que eu acho que tem algo errado
            -- no sentido de ter o P1 e p1 (maiúsculo e minúsculo), pois as chances de entrarem em conflito e confundirem são altas
            -- pergunta pro marlon se nosso feto está de fato certo, apesar de que pra mim não tem chance de erro.

            -- A implementação de um valid_x é bem semelhante com a dos registradores normais, só muda o segundo elsif
            -- e o que vai do lado do reset.
