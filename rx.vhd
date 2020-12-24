library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
 
entity btRx is
  generic (
    clocksPerBits : integer := 115
    );
  port (
    clk       : in  std_logic;
    rxSerialConnection : in  std_logic;
    rxDivisor     : out std_logic;
    rxBytesTransferred   : out std_logic_vector(7 downto 0)
    );
end btRx;
 
 
architecture Behavioral of btRx is
 
  type rxType is (idleSignal, startingBit, dataTransferred,
                     stopperBit, cleanAll);
  signal mainSignal : rxType := idleSignal;
 
  signal tempRxData : std_logic := '0';
  signal rxData   : std_logic := '0';
   
  signal clkCount : integer range 0 to clocksPerBits-1 := 0;
  signal bitIndexer : integer range 0 to 7 := 0;  -- 8 Bits Total
  signal rxBytes   : std_logic_vector(7 downto 0) := (others => '0');
  signal rxValidation     : std_logic := '0';
   
begin

  proc1 : process (clk)
  begin
    if rising_edge(clk) then
      tempRxData <= rxSerialConnection;
      rxData   <= tempRxData;
    end if;
  end process;
   
  proc2 : process (clk)
  begin
    if rising_edge(clk) then
         
      case mainSignal is
 
        when idleSignal =>
          rxValidation     <= '0';
          clkCount <= 0;
          bitIndexer <= 0;
 
          if rxData = '0' then       -- Start bit
            mainSignal <= startingBit;
          else
            mainSignal <= idleSignal;
          end if;
 
        when startingBit =>
          if clkCount = (clocksPerBits-1)/2 then
            if rxData = '0' then
              clkCount <= 0; 
              mainSignal   <= dataTransferred;
            else
              mainSignal   <= idleSignal;
            end if;
          else
            clkCount <= clkCount + 1;
            mainSignal   <= startingBit;
          end if;
 
        when dataTransferred =>
          if clkCount < clocksPerBits-1 then
            clkCount <= clkCount + 1;
            mainSignal   <= dataTransferred;
          else
            clkCount            <= 0;
            rxBytes(bitIndexer) <= rxData;
             
            if bitIndexer < 7 then
              bitIndexer <= bitIndexer + 1;
              mainSignal   <= dataTransferred;
            else
              bitIndexer <= 0;
              mainSignal   <= stopperBit;
            end if;
          end if;
 
 
        -- Stop bit = 1
        when stopperBit =>
          if clkCount < clocksPerBits-1 then
            clkCount <= clkCount + 1;
            mainSignal   <= stopperBit;
          else
            rxValidation     <= '1';
            clkCount <= 0;
            mainSignal   <= cleanAll;
          end if;
 
        when cleanAll =>
          mainSignal <= idleSignal;
          rxValidation   <= '0';
 
             
        when others =>
          mainSignal <= idleSignal;
 
      end case;
    end if;
  end process;
 
  rxDivisor   <= rxValidation;
  rxBytesTransferred <= rxBytes;
   
end Behavioral;