{ config, ... }:
{
  programs.alacritty.enable = config.my.gui-programs;
  programs.alacritty.settings = {
    env = {
      TERM = "xterm-256color";
    };
    background_opacity = 0.7;
    cursor = {
      style.blinking = "On";
      unfocused_hollow = true;
    };
  };
}
