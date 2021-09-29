{ config, pkgs, lib, flakes, ... }:
let
  unstable = flakes.nixos-unstable.legacyPackages.x86_64-linux;
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
    unstable.go_1_17
    unstable.goimports
    unstable.gopls
    ipcalc
    ipmitool
    jq
    lftp
    lm_sensors
    lsof
    mosh
    neofetch
    niv
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
    unzip
    v4l-utils
    weechat
    wget
    whois
    wireguard
  ];
  gui-programs = with pkgs; [
    arandr
    unstable.cura
    ddcutil
    feh
    firefox
    gnome3.dconf-editor
    gimp
    google-chrome
    gnome.gnome-screenshot
    graphviz
    freecad
    nitrogen
    obs-studio
    openrgb
    pavucontrol
    pdftk
    plater
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
