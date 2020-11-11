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
      bc
      conntrack-tools
      dmidecode
      dstat
      efibootmgr
      efivar
      file
      fping
      git-crypt
      go
      ipcalc
      ipmitool
      jq
      lftp
      lm_sensors
      lsof
      mosh
      nix-diff
      nmap
      pciutils
      psmisc
      pwgen
      rename
      screen
      smartmontools
      sysstat
      tcpdump
      wget
    ] ++ gui;
    programs.lesspipe.enable = true;
    programs.dircolors.enable = true;
  };
}
