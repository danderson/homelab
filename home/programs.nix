{ config, pkgs, lib, ... }:
{
  options = {
    my.gui-programs = lib.mkEnableOption "GUI programs";
  };

  config = let
    gui = if config.my.gui-programs
          then with pkgs; [
            feh
            gnome3.dconf-editor
            gimp
            google-chrome
            graphviz
            pavucontrol
            pdftk
            steam
          ]
          else [];
  in {
    home.packages = with pkgs; [
      file
      fping
      git-crypt
      go
      ipcalc
      lftp
      mosh
      nmap
      pwgen
    ] ++ gui;
    programs.lesspipe.enable = true;
    programs.dircolors.enable = true;
  };
}
