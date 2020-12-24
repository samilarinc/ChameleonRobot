library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity topModule is
  Port (    clk, rx, reset : in std_logic;
            tx, pwmSignal1, pwmSignal2, pwmSignal3, pwmSignal4 : out std_logic
       );
end topModule;

architecture Behavioral of topModule is
component btTop
port(   Clk, Rx : in std_logic;
        RxData:  out std_logic_vector(7 downto 0);
        Tx: out std_logic
);
end component;

component servo is
  Port ( clk           : in   STD_LOGIC;
         reset         : in   STD_LOGIC;
         rightCommand  : in   STD_LOGIC;
         pwmSignal     : out  STD_LOGIC;
         pwmSignal2    : out  STD_LOGIC
         );
end component;

component servo2 is
  Port ( clk           : in   STD_LOGIC;
         reset         : in   STD_LOGIC; 
         leftCommand   : in   STD_LOGIC;
         pwmSignal     : out  STD_LOGIC;
         pwmSignal2    : out  STD_LOGIC
         );
end component;

signal rightCommand : std_logic;
signal leftCommand : std_logic;
signal data : std_logic_vector(7 downto 0) := "10000000";

begin
rightCommand <= '1' when data = "11111111" else '0'; 
leftCommand <= '1' when data = "00000000" else '0';
btModule : btTop port map(
    clk => clk,
    rx => rx,
    tx => tx,
    RxData => data
);

servoModule1 : servo port map(
    clk => clk,
    reset => reset,
    rightCommand => rightCommand,
    pwmSignal => pwmSignal1,
    pwmSignal2 => pwmSignal2
);

servoModule2 : servo2 port map(
    clk => clk,
    reset => reset,
    leftCommand => leftCommand,
    pwmSignal => pwmSignal3,
    pwmSignal2 => pwmSignal4
);
end Behavioral;
