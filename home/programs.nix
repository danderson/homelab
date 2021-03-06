{ config, pkgs, lib, ... }:
let
  cli-programs = with pkgs; [
    bc
    conntrack-tools
    dmidecode
    dnsutils
    dstat
    efibootmgr
    efivar
    file
    fping
    git-crypt
    go
    goimports
    gopls
    ipcalc
    ipmitool
    jq
    lftp
    lm_sensors
    lsof
    mosh
    neofetch
    nix-diff
    nmap
    pciutils
    psmisc
    pwgen
    rename
    smartmontools
    sysstat
    tcpdump
    tmux
    v4l-utils
    wget
    whois
  ];
  gui-programs = with pkgs; [
    feh
    gnome3.dconf-editor
    gimp
    google-chrome
    graphviz
    obs-studio
    pavucontrol
    pdftk
    steam
  ];
in
{
  options = {
    my.gui-programs = lib.mkEnableOption "GUI programs";
  };

  config = {
    home.packages = cli-programs ++ (if config.my.gui-programs then gui-programs else []);
    programs.lesspipe.enable = true;
    programs.dircolors.enable = true;
  };
}
