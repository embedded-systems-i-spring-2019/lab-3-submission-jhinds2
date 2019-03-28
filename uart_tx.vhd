----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/20/2019 08:51:55 AM
-- Design Name: 
-- Module Name: uart_tx - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity uart_tx is
  Port ( clk, en, send, rst : in std_logic;
         char : in std_logic_vector(7 downto 0);
         ready, tx : out std_logic);
end uart_tx;

architecture Behavioral of uart_tx is

    --declare type
    type state_type is (idle, start, data);
    --initalize state to idle
    signal state_reg : state_type := idle;
    signal D : std_logic_vector(7 downto 0) := (others => '0');
    
    

begin


    --set registers
    process(clk)
    variable count : integer range 0 to 8;
    begin
    if(rising_edge(clk)) then
    
        if(rst = '1') then
        --reset data
            D <= (others => '0');
            ready <= '1';
            tx <= '1';
            count := 0;
        --go to idle
            state_reg <= idle;
        --if enabled    
        elsif(en = '1') then
        case state_reg is
        --idle state
            when idle =>
                ready <= '1';
                tx <= '1';
                 count := 0;
                if(send = '1') then
                    D <= char;
                    state_reg <= start;
                    ready <= '0';
                else
                    state_reg <= idle;
                end if;
        --start state
            when start =>
                ready <= '0';
                tx <= '0';
                state_reg <= data;
            when data =>
                if(count < 8) then
                    tx <= D(count);
                    count := count + 1;
                else
                --stop bit
                    tx <= '1'; 
                    state_reg <= idle; 
                      
                end if;
            when others => state_reg <= idle;
         end case;
         end if;
     end if;
   end process;
                   
end Behavioral;
