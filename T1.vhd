LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY tp1 IS
    PORT (
        din : IN STD_LOGIC;
        prog : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        clock : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        dout : OUT STD_LOGIC;
        alarme : OUT STD_LOGIC;
    );
END ENTITY;

    LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY tp1 IS
    PORT (
        din : IN STD_LOGIC; -- Entada
        clock : IN STD_LOGIC; -- Entada
        reset : IN STD_LOGIC; -- Entada
        prog : IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- Entada
        padrao: IN std_logic_vector(7 DOWNTO 0); -- Entrada
        dout : OUT STD_LOGIC; -- Saída
        alarme : OUT STD_LOGIC; -- Saída
        
    );
END ENTITY;

TYPE STATE IS (IDLE, p1, p2, p3, BSC, PR, BLK, RESET); -- Etapas da máquina de estados

signal EA: state; -- Estado atual
signal EF: state; -- Estado futuro 

--reg_din = escadinha deitada no inicio do circuito

signal reg_din : std_logic_vector(7 downto 0);

-- implementação dos sinais possíveis
signal P1: std_logic_vector(7 downto 0):= "--";
signal P2: std_logic_vector(7 downto 0):= "--";
signal P3: std_logic_vector(7 downto 0):= "--";

signal C_P1: std_logic := '0';
signal C_P2: std_logic := '0';
signal C_P3: std_logic := '0';

signal valid_P1: std_logic := '0';
signal valid_P2: std_logic := '0';
signal valid_P3: std_logic := '0';

signal match_P1: std_logic := '--';
signal match_P2: std_logic := '--';
signal match_P3: std_logic := '--';
signal match: std_logic := '--';

-- signal cont: std_logic_vector(1 downto 0) := "00";
-- signal alarme_int: std_logic := '0';


-- implementação dos registadores

-- P1
PROCESS() -- O que colocar nos parâmetros do process?
begin
    







    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    -----------------------------------
ARCHITECTURE tp1 OF tp1 IS
    SIGNAL reg_din : STD_LOGIC_VECTOR(7 DOWNTO 0);

BEGIN

    SR : PROCESS (clock)
    BEGIN
        IF clock'event AND clock = '1' then
            reg_din(7) <= din;

            reg_din(6 downto 0) <= reg_din(7 downto 1);
    

            end if;
        END PROCESS SR:;

        TYPE state IS()
