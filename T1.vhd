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
