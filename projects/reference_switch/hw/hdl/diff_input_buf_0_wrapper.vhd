-------------------------------------------------------------------------------
-- diff_input_buf_0_wrapper.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

library diff_input_buf_v1_00_a;
use diff_input_buf_v1_00_a.all;

entity diff_input_buf_0_wrapper is
  port (
    SINGLE_ENDED_INPUT : out std_logic;
    DIFF_INPUT_P : in std_logic;
    DIFF_INPUT_N : in std_logic
  );
end diff_input_buf_0_wrapper;

architecture STRUCTURE of diff_input_buf_0_wrapper is

  component diff_input_buf is
    port (
      SINGLE_ENDED_INPUT : out std_logic;
      DIFF_INPUT_P : in std_logic;
      DIFF_INPUT_N : in std_logic
    );
  end component;

begin

  diff_input_buf_0 : diff_input_buf
    port map (
      SINGLE_ENDED_INPUT => SINGLE_ENDED_INPUT,
      DIFF_INPUT_P => DIFF_INPUT_P,
      DIFF_INPUT_N => DIFF_INPUT_N
    );

end architecture STRUCTURE;

