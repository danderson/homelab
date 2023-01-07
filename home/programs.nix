{ config, pkgs, agenix, lib, flakes, ... }:
let
  unstable = import flakes.nixos-unstable {
    system = pkgs.system;
    config.allowUnfree = true;
  };
  unstable-small = flakes.nixos-unstable-small.legacyPackages.x86_64-linux;
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
  cli-programs = with pkgs; [
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
    my.fileserve
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
    unstable.go_1_19
    unstable.gopls
    unstable.gotools
    unzip
    v4l-utils
    weechat-with-matrix
    wget
    whois
    wireguard-tools
  ];
  gui-programs = with pkgs; [
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
    unstable.vscode-fhs
    zoom-us
  ];
  gaming = with pkgs; [
    unstable.lutris
    obs-studio
    # Steam is installed by NixOS via lib/steam.nix, because of NixOS
    # specific tweaks.
  ];
  printing = let
  s = pkgs;
  u = unstable;
  in [
    u.freecad
    u.flatpak
    u.plater
    u.solvespace
    # Build broken in unstable 2022-12-10
    s.openscad
    s.super-slicer
    s.prusa-slicer
  ];
in
{
  options = {
    my.gui-programs = lib.mkEnableOption "GUI programs";
    my.gaming = lib.mkEnableOption "Gaming stuff";
    my.printing = lib.mkEnableOption "3D printing tools";
    my.extraPkgs = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
    };
  };

  config = {
    home.packages = lib.flatten [
      cli-programs
      (maybeList config.my.gui-programs gui-programs)
      (maybeList config.my.gaming gaming)
      (maybeList config.my.printing printing)
      config.my.extraPkgs
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
      "bin/rgb" = lib.mkIf config.my.gui-programs {
        executable = true;
        text = builtins.readFile ./rgb.sh;
      };
    };
    programs.lesspipe.enable = true;
    programs.dircolors.enable = true;
  };
}
