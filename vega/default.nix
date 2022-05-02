{ flakes, pkgs, ... }: {
  require = [
    ../lib
    ./hardware-configuration.nix
    ./private.nix
  ];

  # zpool create -O recordsize=128K -O compression=on -O atime=off -O xattr=sa -O encryption=aes-256-gcm -O keyformat=passphrase -o ashift=12 -m none data /dev/disk/by-partuuid/...
  # zfs create -o mountpoint=none data/local
  # zfs create -o mountpoint=legacy data/local/root
  # zfs create -o mountpoint=legacy data/local/nix
  # zfs create -o mountpoint=legacy data/local/etc.nixos
  # zfs create -o mountpoint=none data/safe
  # zfs create -o mountpoint=legacy data/safe/home
  # zfs create -o mountpoint=legacy data/safe/persist

  # OpenRGB which LED controls are wired up to what:
  #  - HyperX Fury RGB: all zones, entire device -> top of RAM sticks
  #  - Asus ROG Crosshair (motherboard)
  #    - Zone: Aura Mainboard
  #      - LEDs 1-7: mobo accent lights
  #      - RGB Header 1-2: not connected
  #    - Zone: Aura addressable 1: not connected
  #    - Zone: Aura addressable 2: chassis lights
  #      - 36 LEDs connected, rest do nothing.
  #      - Don't enable: 1,2,7,8,9,34,35 (they're at a blinding position)
  #  - Asus ROG Aura addressable: not connected

  my = {
    cpu-vendor = "amd";
    desktop = true;
    ddc = true;
    gaming = true;
    printing = true;
    ulxs = true;
    jlink = true;
    extraHomePkgs = with pkgs; [
      openrgb
      ddcutil
    ];
  };

  networking = {
    hostName = "vega";
    hostId = "5c13d618";
  };

  services.fwupd.enable = true;

  virtualisation.libvirtd = {
    enable = true;
    qemu.runAsRoot = false;
  };
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };

  networking.firewall.allowedTCPPorts = [ 24800 ]; # Barrier

  home-manager.users.dave.my.i3ExtraCommands = [
    "${pkgs.xorg.xrandr}/bin/xrandr --output DisplayPort-0 --primary --mode 2560x1440 --rate 75 --pos 2560x383 --rotate normal --output DisplayPort-1 --mode 2560x1440 --rate 75 --pos 0x383 --rotate normal --output DisplayPort-2 --mode 2560x1440 --rate 75 --pos 5120x1440 --rotate normal --output HDMI-A-0 --mode 2560x1440 --rate 75 --pos 5120x0 --rotate normal"
    "${pkgs.openrgb}/bin/openrgb -p magenta.orp"
    "${pkgs.openrgb}/bin/openrgb --gui --startminimized"
    "${pkgs.picom}/bin/picom -CGb"
    "${pkgs.nitrogen}/bin/nitrogen --restore"
  ];
  home-manager.users.dave.my.i3Monitors = {
    left = "DisplayPort-1";
    mid = "DisplayPort-0";
    rightdown = "DisplayPort-2";
    rightup = "HDMI-A-0";
  };

  services.livemon = {
    enable = true;
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "20.09"; # Did you read the comment?
}
