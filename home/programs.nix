{ config, pkgs, agenix, lib, flakes, ... }:
let
  unstable = flakes.nixos-unstable.legacyPackages.x86_64-linux;
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
  cli-programs = with pkgs; [
    agenix
    bc
    conntrack-tools
    discord
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
    ripgrep
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
    wireguard
  ];
  gui-programs = with pkgs; [
    arandr
    barrier
    ddcutil
    feh
    firefox
    gnome3.dconf-editor
    gimp
    google-chrome
    gnome.gnome-screenshot
    graphviz
    unstable.freecad
    nitrogen
    obs-studio
    openrgb
    unstable.openscad
    pavucontrol
    plater
    unstable.solvespace
    steam
    virt-manager
    zoom-us
    unstable.super-slicer
    unstable.prusa-slicer
    xine-ui
  ];
in
{
  options = {
    my.gui-programs = lib.mkEnableOption "GUI programs";
  };

  config = {
    home.packages = cli-programs ++ (if config.my.gui-programs then gui-programs else []);
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
      "bin/layout" = lib.mkIf config.my.gui-programs {
        executable = true;
        text = builtins.readFile ./layout.sh;
      };
    };
    programs.lesspipe.enable = true;
    programs.dircolors.enable = true;
  };
}
