--------------------------------------
-- Biblioteca
--------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;

--------------------------------------
-- Entidade
--------------------------------------
ENTITY tp1 IS
    PORT (
        din : IN STD_LOGIC; -- Entada
        clock : IN STD_LOGIC; -- Entada
        reset : IN STD_LOGIC; -- Entada

        prog : IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- Entada
        padrao : IN STD_LOGIC_VECTOR(7 DOWNTO 0); -- Entrada

        dout : OUT STD_LOGIC; -- Saída
        alarme : OUT STD_LOGIC -- Saída

    );

END ENTITY;

--------------------------------------
-- Arquitetura
--------------------------------------

ARCHITECTURE tp1 OF tp1 IS

    TYPE STATE IS (IDLE, SP1, SP2, SP3, BSC, PER, BLK, RST); -- Etapas da máquina de estados

    SIGNAL EA : state; -- Estado atual
    SIGNAL EF : state; -- Estado futuro 
    SIGNAL reg_din : STD_LOGIC_VECTOR(7 DOWNTO 0);

    SIGNAL P1 : STD_LOGIC_VECTOR(7 DOWNTO 0) := "00000000";
    SIGNAL P2 : STD_LOGIC_VECTOR(7 DOWNTO 0) := "00000000";
    SIGNAL P3 : STD_LOGIC_VECTOR(7 DOWNTO 0) := "00000000";

    SIGNAL C_P1 : STD_LOGIC := '0';
    SIGNAL C_P2 : STD_LOGIC := '0';
    SIGNAL C_P3 : STD_LOGIC := '0';

    SIGNAL valid_P1 : STD_LOGIC := '0';
    SIGNAL valid_P2 : STD_LOGIC := '0';
    SIGNAL valid_P3 : STD_LOGIC := '0';

    SIGNAL match_P1 : STD_LOGIC := '0';
    SIGNAL match_P2 : STD_LOGIC := '0';
    SIGNAL match_P3 : STD_LOGIC := '0';
    SIGNAL match : STD_LOGIC := '0';

    SIGNAL cont : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
    SIGNAL alarme_int : STD_LOGIC := '0';

    -- CLOCK -------------------------------------------------------------------------------------------------------

BEGIN
    PROCESS (clock)
    BEGIN
        IF clock'event AND clock = '1' THEN
            reg_din(7) <= din;
            reg_din(6 DOWNTO 0) <= reg_din(7 DOWNTO 1);
        END IF;
    END PROCESS;

    -- MÁQUINA DE ESTADOS -------------------------------------------------------------------------------------------------------

    PROCESS (reset, clock)
    BEGIN
        IF reset = '1' THEN
            EA <= IDLE;
        ELSIF rising_edge(clock) THEN
            EA <= EF;
        END IF;
    END PROCESS;

    PROCESS (reset, clock)
    BEGIN
        IF reset = '1' THEN
            cont <= "00";
        ELSIF rising_edge(clock) THEN
            IF EA = PER THEN
                cont <= cont + 1;
            ELSE
                cont <= "00";
            END IF;
        END IF;
    END PROCESS;

    PROCESS(EA, match, prog, cont)
    BEGIN
    CASE EA IS
        WHEN IDLE => -- prog {1,2,3} programando {p1, p2, p3} 
            IF prog = "001" THEN
                EF <= SP1;
            ELSIF prog = "010" THEN
                EF <= SP2;
            ELSIF prog = "011" THEN
                EF <= SP3;
            ELSIF prog = "100" THEN
                EF <= BSC;
            END IF;
        
        WHEN SP1 =>
            IF prog = "000" THEN
                EF <= IDLE;
            END IF;
        
        WHEN SP2 =>
            IF prog = "000" THEN
                EF <= IDLE;
            END IF;

        WHEN SP3 =>
            IF prog = "000" THEN
                EF <= IDLE;
            END IF;
            ---------------------------------------------------

        WHEN BSC => -- quando estiver no busca
            IF match = '1' THEN -- se deu match vai pro PER
                EF <= PER;

            ELSIF prog = "101" THEN -- se o prog = 5, vai pro BLK
                EF <= BLK;

            ELSIF prog = "111" THEN -- se o prog = 7, vai pro RESET
                EF <= RST;
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
                EF <= RST;
            END IF;

        WHEN RST => -- quando estiver no reset
            IF prog = "000" THEN -- se prog = 0, vai para o IDLE
                EF <= IDLE;
            END IF;
    END CASE;
    END PROCESS;

-- REGISTRADORES ---------------------------------------------------

PROCESS (clock, reset) --reg_din
BEGIN
    IF reset = '1' THEN
        reg_din <= (OTHERS => '0');
    ELSIF rising_edge(clock) THEN
        reg_din(7) <= din;
        reg_din(6) <= reg_din(7);
        reg_din(5) <= reg_din(6);
        reg_din(4) <= reg_din(5);
        reg_din(3) <= reg_din(4);
        reg_din(2) <= reg_din(3);
        reg_din(1) <= reg_din(2);
        reg_din(0) <= reg_din(1);
    END IF;
END PROCESS;

---------------------------------------------------

PROCESS (clock, reset) -- P1
BEGIN
    IF reset = '1' THEN
        P1 <= (OTHERS => '0');
    ELSIF rising_edge(clock) THEN
        IF EA = SP1 THEN
            P1 <= padrao;
        END IF;
    END IF;
END PROCESS;

---------------------------------------------------

PROCESS (clock, reset) -- P2
BEGIN
    IF reset = '1' THEN
        P2 <= (OTHERS => '0');
    ELSIF rising_edge(clock) THEN
        IF EA = SP2 THEN
            P2 <= padrao;
        END IF;
    END IF;
END PROCESS;

---------------------------------------------------

PROCESS (clock, reset) -- P3
BEGIN
    IF reset = '1' THEN
        P3 <= (OTHERS => '0');
    ELSIF rising_edge(clock) THEN
        IF EA = SP3 THEN
            P3 <= padrao;
        END IF;
    END IF;
END PROCESS;

---------------------------------------------------

PROCESS (clock, reset) -- valid_P1
BEGIN
    IF reset = '1' THEN
        valid_P1 <= '0';
    ELSIF rising_edge(clock) THEN
        IF EA = SP1 THEN
            valid_P1 <= '1';
        ELSIF EA = RST THEN
            valid_P1 <= '0';
        END IF;
    END IF;
END PROCESS;

---------------------------------------------------

PROCESS (clock, reset) -- valid_P2
BEGIN
    IF reset = '1' THEN
        valid_p2 <= '0';
    ELSIF rising_edge(clock) THEN
        IF EA = SP2 THEN
            valid_p2 <= '1';
        ELSIF EA = RST THEN
            valid_p2 <= '0';
        END IF;
    END IF;
END PROCESS;

---------------------------------------------------

PROCESS (clock, reset) -- valid_P3
BEGIN
    IF reset = '1' THEN
        valid_p3 <= '0';
    ELSIF rising_edge(clock) THEN
        IF EA = SP3 THEN
            valid_p3 <= '1';
        ELSIF EA = RST THEN
            valid_p3 <= '0';
        END IF;
    END IF;
END PROCESS;

---------------------------------------------------

PROCESS (clock, reset) -- alarme_int
BEGIN
    IF reset = '1' THEN
        alarme_int <= '0';
    ELSIF rising_edge(clock) THEN
        IF match = '1' THEN
            alarme_int <= '1';
        ELSIF cont = "11" THEN
            alarme_int <= '0';
        ELSIF EA = BLK THEN
            alarme_int <= '1';
        ELSIF EA = BSC THEN
            alarme_int <= '0';
        ELSIF EA = RST THEN
            alarme_int <= '0';
        END IF;
    END IF;
END PROCESS;

-- CIRUITOS ---------------------------------------------------

C_p1 <= '1' WHEN reg_din = p1
    ELSE
    '0';
C_p2 <= '1' WHEN reg_din = p2
    ELSE
    '0';
C_p3 <= '1' WHEN reg_din = p3
    ELSE
    '0';

match_P1 <= C_P1 AND valid_P1;
match_P2 <= C_P2 AND valid_P2;
match_P3 <= C_P3 AND valid_P3;
match <= (match_P1 OR match_P2 OR match_P3);
alarme <= alarme_int;
dout <= din AND (NOT alarme_int);

END ARCHITECTURE;
