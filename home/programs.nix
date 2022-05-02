{ config, pkgs, agenix, lib, flakes, ... }:
let
  unstable = flakes.nixos-unstable.legacyPackages.x86_64-linux;
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
    unstable.go_1_18
    unstable.gotools
    unstable.gopls
    ipcalc
    ipmitool
    jq
    lftp
    lm_sensors
    lsof
    mosh
    my.fileserve
    my.livemon
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
    discord
    feh
    unstable-small.firefox-bin
    gnome3.dconf-editor
    gimp
    google-chrome
    gnome.gnome-screenshot
    graphviz
    nitrogen
    openrgb
    pavucontrol
    virt-manager
    zoom-us
    xine-ui
  ];
  gaming = with pkgs; [
    unstable.lutris-free
    obs-studio
    steam
  ];
  printing = with unstable; [
    freecad
    openscad
    pkgs.plater
    solvespace
    super-slicer
    prusa-slicer
  ];
in
{
  options = {
    my.gui-programs = lib.mkEnableOption "GUI programs";
    my.gaming = lib.mkEnableOption "Gaming stuff";
    my.printing = lib.mkEnableOption "3D printing tools";
  };

  config = {
    home.packages = lib.flatten [
      cli-programs
      (maybeList config.my.gui-programs gui-programs)
      (maybeList config.my.gaming gaming)
      (maybeList config.my.printing printing)
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
      "bin/layout" = lib.mkIf config.my.gui-programs {
        executable = true;
        text = builtins.readFile ./layout.sh;
      };
      "bin/rgb" = lib.mkIf config.my.gui-programs {
        executable = true;
        text = builtins.readFile ./rgb.sh;
      };
      ".config/dave/layout_config.sh" = lib.mkIf config.my.gui-programs {
        text = ''
          mid="${config.my.i3Monitors.mid}"
          left="${config.my.i3Monitors.left}"
          rightdown="${config.my.i3Monitors.rightdown}"
          rightup="${config.my.i3Monitors.rightup}"
        '';
      };
    };
    programs.lesspipe.enable = true;
    programs.dircolors.enable = true;
  };
}
