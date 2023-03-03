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

    u.go_1_19
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
    nitrogen
    pavucontrol
    virt-manager
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
    # Build broken in unstable 2022-12-10
    s.openscad
    s.super-slicer
    s.prusa-slicer
  ];
in
{
  home.packages = lib.flatten [
    cli-programs
    (maybeList config.my.desktop gui-programs)
    (maybeList config.my.gaming gaming)
    (maybeList config.my.printing printing)
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
    "bin/tss" = {
      executable = true;
      text = builtins.readFile ./tailscale-switch-profile.sh;
    };
    "bin/rgb" = lib.mkIf config.my.desktop {
      executable = true;
      text = builtins.readFile ./rgb.sh;
    };
  };
  programs.lesspipe.enable = true;
  programs.dircolors.enable = true;
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhs;
  };
}
