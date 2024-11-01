library IEEE;
use ieee.std_logic_1164.all;


entity estacionamento is
    generic ( max: natural );
    
    port (
        a, b: in std_logic;
        clock, reset: in std_logic;
        
        car_counterros: out natural;
        lotado: out std_logic
    );
end entity;

architecture behavioral of estacionamento is
    type gate_state is range 0 to 7;
    signal current_state, next_state: gate_state:=0;
    signal counter : natural:= 0;
begin 
    process(clock, reset)
    begin
        if reset='1' then
            current_state <= 7;
            lotado <= '0';
            car_counterros <= 0;
        end if;
        if rising_edge(clock) then
            current_state <= next_state;
            if(counter>=max)then
                lotado <= '1';
            else
                lotado <= '0';
            end if;
                car_counterros <= counter;        
        end  if;
    end process;

    process (a,b, current_state)
        variable car_counter : natural :=0;
    begin
        case current_state is
            when 0 =>
                if(a = '1' and b = '0') then
                    next_state<= 1;
                elsif(b = '1' and a = '0') then
                    next_state<= 2;
                end if;
    
            when 1=>
                if (b = '1' and a = '1') then
                    next_state<=3;
                else
                    next_state<=0;
                end if;
    
            when 2=>
                if (a = '1' and b = '1') then
                    next_state<=4;
                else
                    next_state<=0;
                end if;
    
            when 3=>
                if(a = '0' and b = '1') then
                    next_state<=5;
                else
                    next_state<=0;
                end if;
            when 4 =>
                if(b = '0' and a = '1') then
                    next_state<=6;
                else
                    next_state<=0;
                end if;
    
            when 5 =>
                if( a = '0' and b = '0') then
                    car_counter := car_counter + 1;
                    counter <= car_counter;
                    next_state <= 0;
                else
                    next_state<=0;
                end if;
    
            when 6 =>
                if( b = '0' and a = '0') then
                    car_counter := car_counter - 1;
                    counter<=car_counter;
                    next_state <= 0;
                else
                    next_state<=0;
                end if;
    
            when 7 => 
                 car_counter:=0;
                 counter <= 0;
                 next_state<=0;
    
        end case;
    end process;
end architecture;