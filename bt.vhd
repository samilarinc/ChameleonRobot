library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
 
entity btTop is
port(   Clk, Rx : in std_logic;
        RxData:  out std_logic_vector(7 downto 0);
        Tx: out std_logic
);
end btTop;
 
architecture Behavioral of btTop is
 
--component btTx is
--  generic (
--    clocksPerBits : integer := 115     -- Needs to be set correctly
--    );
--  port (
--    clk       : in  std_logic;
--    txDivisor     : in  std_logic;
--    txBytesTransferred   : in  std_logic_vector(7 downto 0);
--    txActivated : out std_logic;
--    txSerialConnection : out std_logic;
--    txFinished   : out std_logic
--    );
--end component;
 
component btRx is
  generic (
    clocksPerBits : integer := 115     -- Needs to be set correctly
    );
  port (
    clk       : in  std_logic;
    rxSerialConnection : in  std_logic;
    rxDivisor     : out std_logic;
    rxBytesTransferred   : out std_logic_vector(7 downto 0)
    );
end component;
 
   
  -- Basys3 clock hýzý = 100 MHz 
  -- BT modulu 115200 baud rate
  -- 10000000 / 115200 = 87
  constant clocksPerBits : integer := 87;
 
--  constant bitPeriod : time := 8680 ns;
   
--  signal txDivisor     : std_logic                    := '0';
--  signal txBytesTransferred   : std_logic_vector(7 downto 0) := (others => '0');
--  signal txSerialConnection : std_logic;
--  signal txFinished   : std_logic;
 

begin
 
--    --testBench sonuçlarýný görmek için
--  txModule : btTx
--    generic map (
--      clocksPerBits => clocksPerBits
--      )
--    port map (
--      clk        => clk,
--      txDivisor    => txDivisor,
--      txBytesTransferred   => txBytesTransferred,
--      txActivated => open,
--      txSerialConnection => txSerialConnection,
--      txFinished   => txFinished
--      );
 
  -- Instantiate UART Receiver
rxModule : btRx
    generic map (
      clocksPerBits => clocksPerBits
      )
    port map (
      clk       => clk,
      rxSerialConnection => rx,
      rxDivisor => tx,
      rxBytesTransferred   => RxData
      );
 
   
end Behavioral;