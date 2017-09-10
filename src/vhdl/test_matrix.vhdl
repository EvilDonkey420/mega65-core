use WORK.ALL;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.debugtools.all;

entity test_matrix is
end test_matrix;

architecture behavioral of test_matrix is

  signal pixel_x_640 : integer := 0;
  signal ycounter_in : unsigned(11 downto 0) := (others => '0');
  signal x_start : unsigned(11 downto 0) := to_unsigned(0,12);
  signal y_start : unsigned(11 downto 0) := to_unsigned(479-290,12);
  signal pixelclock : std_logic := '1';
  signal visual_keyboard_enable : std_logic := '1';
  signal key1 : unsigned(7 downto 0) := x"0f";
  signal key2 : unsigned(7 downto 0) := x"3c";
  signal key3 : unsigned(7 downto 0) := x"01";
  signal vgared_in : unsigned (7 downto 0) := x"a0";
  signal vgagreen_in : unsigned (7 downto 0) := x"a0";
  signal vgablue_in : unsigned (7 downto 0) := x"e0";
  signal vgared_out : unsigned (7 downto 0);
  signal vgagreen_out : unsigned (7 downto 0);
  signal vgablue_out : unsigned (7 downto 0);

  signal char_in : unsigned(7 downto 0) := x"00";
  signal char_valid : std_logic := '0';
  signal term_ready : std_logic;
  
begin
  kc0: entity work.matrix_compositor
    port map(
      display_shift_in => "000",
      shift_ready_in => '0',
      mm_displayMode_in => "10",
      monitor_char_in => char_in,
      monitor_char_valid => char_valid,
      pixel_y_scale_200 => to_unsigned(2,4),
      pixel_y_scale_400 => to_unsigned(1,4),
      terminal_emulator_ready => term_ready,
      pixel_x_640 => pixel_x_640,
      ycounter_in => ycounter_in,
      clk => pixelclock,
      pixelclock => pixelclock,
      matrix_mode_enable => '1',
      vgared_in => vgared_in,
      vgagreen_in => vgagreen_in,
      vgablue_in => vgablue_in,
      vgared_out => vgared_out,
      vgagreen_out => vgagreen_out,
      vgablue_out => vgablue_out
    );

  process
    procedure type_char(char : character) is
    begin
        report "Typing  " & character'image(char);
        wait for 40 ns;
        char_in <= to_unsigned(character'pos(char),8);
        char_valid <= '1';
        wait for 40 ns;
        char_valid <= '0';
        wait for 1 us;
    end procedure;      
    procedure type_text(text : string) is
    begin
      for i in text'range loop
        type_char(text(i));
      end loop;
    end procedure;
  begin
    wait for 1 us;
    type_text("line 0" & lf & cr);
    type_text("1" & lf & cr);
    type_text("2" & lf & cr);
    type_text("3" & lf & cr);
    type_text("4" & lf & cr);
    type_text("5" & lf & cr);
    type_text("6" & lf & cr);
    type_text("7" & lf & cr);
    type_text("8" & lf & cr);
    type_text("9" & lf & cr);
    type_text("line 10" & lf & cr);
    type_text("1" & lf & cr);
    type_text("2" & lf & cr);
    type_text("3" & lf & cr);
    type_text("4" & lf & cr);
    type_text("5" & lf & cr);
    type_text("6" & lf & cr);
    type_text("7" & lf & cr);
    type_text("8" & lf & cr);
    type_text("9" & lf & cr);
    type_text("line 20" & lf & cr);
    type_text("1" & lf & cr);
    type_text("2" & lf & cr);
    type_text("3" & lf & cr);
    type_text("4" & lf & cr);
    type_text("5" & lf & cr);
    type_text("6" & lf & cr);
    type_text("7" & lf & cr);
    type_text("8" & lf & cr);
    type_text("9" & lf & cr);
    type_text("line 30" & lf & cr);
    type_text("1" & lf & cr);
    type_text("2" & lf & cr);
    type_text("3" & lf & cr);
    type_text("4" & lf & cr);
    type_text("5" & lf & cr);
    type_text("6" & lf & cr);
    type_text("7" & lf & cr);
    type_text("8" & lf & cr);
    type_text("9" & lf & cr);

    wait for 1 sec;
  end process;

  process
  begin    
    for i in 1 to 20000000 loop
      pixelclock <= '1';
      wait for 10 ns;
      pixelclock <= '0';
      wait for 10 ns;
      pixelclock <= '1';
      wait for 10 ns;
      pixelclock <= '0';
      wait for 10 ns;
      pixelclock <= '1';
      wait for 10 ns;
      pixelclock <= '0';
      wait for 10 ns;
      if pixel_x_640 < 810 then
        pixel_x_640 <= pixel_x_640 + 1;
      else
        pixel_x_640 <= 0;
        if ycounter_in < 480 then
          ycounter_in <= ycounter_in + 1;
        else
          ycounter_in <= to_unsigned(0,12);
        end if;
      end if;
      report "PIXEL:" & integer'image(pixel_x_640)
        & ":" & integer'image(to_integer(ycounter_in))
        & ":" & to_hstring(vgared_out)
        & ":" & to_hstring(vgagreen_out)
        & ":" & to_hstring(vgablue_out);
    end loop;  -- i
    assert false report "End of simulation" severity note;
  end process;

end behavioral;