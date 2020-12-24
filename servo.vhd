library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity  servo is
  Port ( clk           : in   STD_LOGIC;
         reset         : in   STD_LOGIC; 
         rightCommand  : in   STD_LOGIC;
         pwmSignal     : out  STD_LOGIC;
         pwmSignal2    : out  STD_LOGIC
         );
end  servo;

architecture Behavioral of servo is

constant speed             :   integer :=        500;
constant period            :   integer :=    1000000;
constant max_duty          :   integer :=     250000;  
constant min_duty          :   integer :=      50000;  
  
signal pwm                 :   std_logic;
signal pwmTemp             :   std_logic;
signal pwm2                :   std_logic;
signal pwmTemp2            :   std_logic;
signal flag                :   std_logic;
signal lenSignal           :   integer :=            150000;
signal lenSignalTemp       :   integer :=            150000;
signal lenSignal2          :   integer :=            150000;
signal lenSignalTemp2      :   integer :=            150000;
signal counter             :   integer :=            0;
signal counterTemp         :   integer :=            0;
signal state               :   integer :=            0;
signal resetter            :   integer :=            0;

constant legBack           :   integer :=        50000;
constant legFront          :   integer :=       200000;
constant kneeUp            :   integer :=        72000;
constant kneeDown          :   integer :=       175000;

begin
process(clk, reset)
  begin
    if reset = '1' then 
        pwm <= '0';
        pwm2 <= '0';
        counter <= 0;
        lenSignal <= 0;
        
    elsif clk='1' and clk'event then
        pwm <= pwmTemp;
        pwm2 <= pwmTemp2;
        counter <= counterTemp;
        lenSignal <= lenSignalTemp;
        lenSignal2 <= lenSignalTemp2;
      end if;
      
  end process;

counterTemp <= 0 when counter = period else counter + 1;
flag <= '1' when counter = 0 else '0';

process(rightCommand, flag, lenSignal)
  begin
    lenSignalTemp <= lenSignal;
    lenSignalTemp2 <= lenSignal2;
    if flag='1' and rightCommand = '1' then
        if state = 0 then
                if lenSignal > legBack then
                    lenSignalTemp <= lenSignal - speed;      
                else
                    resetter <= resetter + 1;
                  end if;
       elsif state = 1 then
                if lenSignal2 > kneeUp then
                    lenSignalTemp2 <= lenSignal2 - speed;  
                else
                    resetter <= resetter + 1;
                  end if;
      elsif state = 2 then
                if lenSignal < legFront then
                    lenSignalTemp <= lenSignal + speed;  
                else
                    resetter <= resetter + 1;
                  end if;
      elsif state = 3 then
               if lenSignal2 < kneeDown then
                    lenSignalTemp2 <= lenSignal2 + speed;
                else
                    resetter <= 0;
                  end if;
      else
                if lenSignal2 < kneeDown then
                    lenSignalTemp2 <= lenSignal2 + speed;
                else
--                    state <= 0;
                    resetter <= resetter;
                  end if;
         end if;
      end if; 
end process;

--status <= state;
pwmSignal <= pwm;
pwmSignal2 <= pwm2;
pwmTemp <= '1' when counter < lenSignal else '0';
pwmTemp2 <= '1' when counter < lenSignal2 else '0';
state <= resetter;

end Behavioral;