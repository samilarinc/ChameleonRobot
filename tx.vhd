library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity btTx is
  generic (
    clocksPerBits : integer := 115     -- Needs to be set correctly
    );
  port (
    clk       : in  std_logic;
    txDivisor     : in  std_logic;
    txBytesTransferred   : in  std_logic_vector(7 downto 0);
    txActivated : out std_logic;
    txSerialConnection : out std_logic;
    txFinished   : out std_logic
    );
end btTx;
 
 
architecture Behavioral of btTx is
 
  type txType is (idleSignal, startingBit, dataTransferred,
                     stopperBit, cleanAll);
  signal mainSignal : txType := idleSignal;
 
  signal newClock : integer range 0 to clocksPerBits-1 := 0;
  signal bitIndexer : integer range 0 to 7 := 0;  -- 8 Bits Total
  signal txData   : std_logic_vector(7 downto 0) := (others => '0');
  signal txDone   : std_logic := '0';
   
begin
 
   
proc1 : process (clk)
  begin
    if rising_edge(clk) then
         
      case mainSignal is
 
        when idleSignal =>
          txActivated <= '0';
          txSerialConnection <= '1';         -- Drive Line High for Idle
          txDone   <= '0';
          newClock <= 0;
          bitIndexer <= 0;
 
          if txDivisor = '1' then
            txData <= txBytesTransferred;
            mainSignal <= startingBit;
          else
            mainSignal <= idleSignal;
          end if;
 
           
        -- Send out Start Bit. Start bit = 0
        when startingBit =>
          txActivated <= '1';
          txSerialConnection <= '0';
 
          -- Wait clocksPerBits-1 clock cycles for start bit to finish
          if newClock < clocksPerBits-1 then
            newClock <= newClock + 1;
            mainSignal   <= startingBit;
          else
            newClock <= 0;
            mainSignal   <= dataTransferred;
          end if;
 
           
        -- Wait clocksPerBits-1 clock cycles for data bits to finish          
        when dataTransferred =>
          txSerialConnection <= txData(bitIndexer);
           
          if newClock < clocksPerBits-1 then
            newClock <= newClock + 1;
            mainSignal   <= dataTransferred;
          else
            newClock <= 0;
             
            -- Check if we have sent out all bits
            if bitIndexer < 7 then
              bitIndexer <= bitIndexer + 1;
              mainSignal   <= dataTransferred;
            else
              bitIndexer <= 0;
              mainSignal   <= stopperBit;
            end if;
          end if;
 
 
        -- Send out Stop bit.  Stop bit = 1
        when stopperBit =>
          txSerialConnection <= '1';
 
          -- Wait clocksPerBits-1 clock cycles for Stop bit to finish
          if newClock < clocksPerBits-1 then
            newClock <= newClock + 1;
            mainSignal   <= stopperBit;
          else
            txDone   <= '1';
            newClock <= 0;
            mainSignal   <= cleanAll;
          end if;
 
                   
        -- Stay here 1 clock
        when cleanAll =>
          txActivated <= '0';
          txDone   <= '1';
          mainSignal   <= idleSignal;
           
             
        when others =>
          mainSignal <= idleSignal;
 
      end case;
    end if;
  end process;
 
  txFinished <= txDone;
   
end Behavioral;