{ pkgs, ... }: {
  programs.sway = {
    enable = true;
    extraPackages = with pkgs; [ swaylock swayidle xwayland rxvt-unicode dmenu mako wl-clipboard alacritty ];
    extraSessionCommands = ''
      export SDL_VIDEODRIVER=wayland
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
      export _JAVA_AWT_WM_NONREPARENTING=1
      export SHLVL=0
    '';
    wrapperFeatures.gtk = true;
  };
  environment.systemPackages = [ pkgs.qt5.qtwayland ];
  services.xserver.displayManager.sessionPackages = [ pkgs.sway ];
}
