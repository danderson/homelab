{ config, ... }:
{
  programs.alacritty.enable = config.my.desktop;
  programs.alacritty.settings = {
    env = {
      TERM = "xterm-256color";
      WINIT_X11_SCALE_FACTOR = "1.2";
    };
    window.opacity = 0.7;
    cursor = {
      style.blinking = "On";
      unfocused_hollow = true;
    };
  };
}
