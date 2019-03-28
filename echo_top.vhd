----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/20/2019 12:53:09 PM
-- Design Name: 
-- Module Name: echo_top - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity echo_top is
  Port (TXD, clk, btn : in std_logic;
        char_in : in std_logic_vector(7 downto 0);
        CTS, RTS, RXD : out std_logic);
end echo_top;

architecture Behavioral of echo_top is

--declare components

--UART--------------------------------------------------------------------
component uart 
    port(
    clk, en, send, rx, rst      : in std_logic;
    charSend                    : in std_logic_vector (7 downto 0);
    ready, tx, newChar          : out std_logic;
    charRec                     : out std_logic_vector (7 downto 0)
);
end component;

--debounce----------------------------------------------------------------
component debounce 
        Port (clk: in std_logic;
        btn: in std_logic;
        dbnc: out std_logic);
end component;

--clock div---------------------------------------------------------------
component clk_div
    port (
    clk : in std_logic;
    div : out std_logic);
end component;

--sender------------------------------------------------------------------
component echo
  Port (clk, en, ready, newChar : in std_logic;
        charIn : in std_logic_vector(7 downto 0);
        send : out std_logic;
        charOut : out std_logic_vector(7 downto 0));
end component;

--end components----------------------------------------------------------


--intermediate signals
signal u1_out, u3_out, u4_send, u5_ready : std_logic;
signal u4_char : std_logic_vector(7 downto 0);

begin

--set these to ground
RTS <= '0';
CTS <= '0';

--port maps
u1: debounce port map(btn => btn,
                      clk => clk,
                      dbnc => u1_out);
                                           
u3: clk_div port map(clk => clk,
                     div => u3_out);
                     
u4: echo port map(  clk => clk,
                    newChar => u1_out,
                    charin => char_in,
                    en => u3_out,
                    ready => u5_ready,
                    charOut => u4_char,
                    send => u4_send);
                    
u5: uart port map(charSend => u4_char,
                  clk => clk,
                  en => u3_out,
                  rst => '0',
                  rx => TXD,
                  send => u4_send,
                  ready => u5_ready,
                  tx => RXD);


end Behavioral;
