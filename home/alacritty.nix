{ config, ... }:
{
  programs.alacritty.enable = config.my.gui-programs;
  programs.alacritty.settings = {
    env = {
      TERM = "xterm-256color";
      WINIT_X11_SCALE_FACTOR = "1.2";
    };
    background_opacity = 0.7;
    cursor = {
      style.blinking = "On";
      unfocused_hollow = true;
    };
  };
}
