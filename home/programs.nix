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
    ffmpeg
    file
    fping
    gcc
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
    sshfs
    sysstat
    tcpdump
    tmux
    v4l-utils
    weechat
    wget
    whois
  ];
  gui-programs = with pkgs; [
    arandr
    ddcutil
    feh
    firefox
    gnome3.dconf-editor
    gimp
    google-chrome
    graphviz
    freecad
    nitrogen
    obs-studio
    openrgb
    pavucontrol
    pdftk
    steam
    virt-manager
    zoom-us
    super-slicer
    prusa-slicer
    xine-ui
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
