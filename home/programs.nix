{ config, pkgs, agenix, lib, flakes, ... }:
let
  s = pkgs;
  u = import flakes.nixos-unstable {
    system = pkgs.system;
    config.allowUnfree = true;
  };

  agenix = flakes.agenix.packages.x86_64-linux.agenix;
  weechat-with-matrix = pkgs.weechat.override {
    configure = { availablePlugins, ... }: {
      plugins = with availablePlugins; [
        (python.withPackages (_: [ pkgs.weechatScripts.weechat-matrix ]))
        lua
      ];
      scripts = [ pkgs.weechatScripts.weechat-matrix ];
    };
  };

  maybeList = toggle: list: if toggle then list else [];

  cli-programs = with s; [
    agenix
    bc
    conntrack-tools
    dmidecode
    dnsutils
    dstat
    edac-utils
    efibootmgr
    efivar
    ffmpeg
    file
    fping
    gcc
    git-crypt
    glances
    hdparm
    ipcalc
    ipmitool
    jq
    lftp
    lm_sensors
    lsof
    lsscsi
    mosh
    neofetch
    niv
    nix-diff
    nmap
    pciutils
    psmisc
    pwgen
    rename
    ripgrep
    sbcl
    smartmontools
    sshfs
    sysstat
    tcpdump
    tmux
    unzip
    v4l-utils
    weechat-with-matrix
    wget
    whois
    wireguard-tools

    u.go_1_20
    u.gopls
    u.gotools

    my.fileserve
  ];
  gui-programs = with s; [
    arandr
    barrier
    discord
    feh
    firefox-bin
    gimp
    gnome.gnome-screenshot
    gnome3.dconf-editor
    google-chrome
    graphviz
    grim
    nitrogen
    pavucontrol
    slurp
    virt-manager
    vlc
    wdisplays
    zoom-us
  ];
  gaming = with s; [
    lutris
    obs-studio
    # Steam is installed by NixOS via lib/steam.nix, because of NixOS
    # specific tweaks.
  ];
  printing = with u; [
    freecad
    plater
    solvespace
    openscad
    super-slicer
    prusa-slicer
  ];
  battlestation = with u; [
    openrgb
    ddcutil
  ];
in
{
  home.packages = lib.flatten [
    cli-programs
    (maybeList config.my.desktop gui-programs)
    (maybeList config.my.gaming gaming)
    (maybeList config.my.printing printing)
    (maybeList config.my.battlestation battlestation)
    config.my.homePkgs
  ];
  home.file = {
    "bin/needs-reboot" = {
      executable = true;
      text = builtins.readFile ./needs-reboot.sh;
    };
    "bin/delbr" = {
      executable = true;
      text = builtins.readFile ./delete-my-old-branches.sh;
    };
    "bin/rgb" = lib.mkIf config.my.battlestation {
      executable = true;
      text = builtins.readFile ./rgb.sh;
    };
    "bin/switch-desktop" = lib.mkIf config.my.battlestation {
      executable = true;
      source = pkgs.substituteAll {
        src = ./switch.sh;
        ddcutil = "${pkgs.ddcutil}/bin/ddcutil";
      };
    };
  };
  programs.lesspipe.enable = true;
  programs.dircolors.enable = true;
  programs.vscode = {
    enable = config.my.desktop;
    package = u.vscode.fhs;
  };
}
