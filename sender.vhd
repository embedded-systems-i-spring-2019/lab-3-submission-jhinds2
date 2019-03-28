----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/20/2019 09:56:54 AM
-- Design Name: 
-- Module Name: sender - Behavioral
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

entity sender is
  Port ( rst, clk, en, btn, ready: in std_logic;
         send : out std_logic;
         char : out std_logic_vector(7 downto 0));
end sender;

architecture Behavioral of sender is

--create a array that to hold netID
type characters is array (0 to 5) of std_logic_vector(7 downto 0);
--initialize netID
signal netID : characters := (x"6A", x"74", x"68", x"31", x"34", x"30");
--declare states
type state_type is (idle, busyA, busyB, busyC);
--initialize to idle
signal state_reg : state_type := idle;
--counts from 0 to 5 (need 4 bits)
signal i : std_logic_vector(2 downto 0) := (others => '0');


begin

    --set registers
    process(clk)
    begin
        if(rising_edge(clk))then  
        
        if (en = '1') then 
            if(rst = '1') then
            --clear all outputs
            send <= '0';
            char <= (others => '0');
            i <= (others => '0');
            --go to idle
            state_reg <= idle;
            end if;
        
        case state_reg is
        --idle state
            when idle =>
                if(ready = '1' and btn = '1') then
                if(to_integer(unsigned(i)) < 6) then
                    send <= '1';
                    char <= netID(to_integer(unsigned(i)));
                    i <= std_logic_vector(unsigned(i) + 1);
                    state_reg <= busyA;
                elsif(to_integer(unsigned(i)) = 6) then
                    i <= (others => '0');
                    state_reg <= idle;
                end if;
                end if;
        --busyA state
            when busyA =>
                state_reg <= busyB;
        --busyB state
            when busyB =>
                send <= '0';
                state_reg <= busyC;
        --busyC state
            when busyC =>
                if(ready = '1' and btn = '0') then
                    state_reg <= idle;
                else
                    state_reg <= busyC;
                end if;
            when others => state_reg <= idle;
         end case;
         end if;
       end if;
   end process;

end Behavioral;
