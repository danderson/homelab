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
    gpu = "amd";
    desktop = true;
    zfs = true;
    ddc = true;
    gaming = true;
    printing = true;
    ulxs = true;
    jlink = true;
    fwupd = true;
    tailscale = "unstable";
    homePkgs = with pkgs; [
      openrgb
      ddcutil
    ];
    wmCommands = [
      "${pkgs.openrgb}/bin/openrgb -p magenta.orp"
      "${pkgs.openrgb}/bin/openrgb --gui --startminimized"
    ];
    layout = {
      outputs = let
        screen = name: letter: x: y: {
          output = name;
          letter = letter;
          position.x = x;
          position.y = y;
          resolution.x = 2560;
          resolution.y = 1440;
        };
      in {
        mid = screen "DP-2" "u" 2560 510 // { primary = true; };
        left = screen "DP-1" "y" 0 510;
        rightdown = screen "DP-3" "i" 5120 1440;
        rightup = screen "HDMI-A-1" "o" 5120 0;
      };
      layouts = {
        code = {
          mid = ["1" "*"];
          left = ["3"];
          rightdown = ["2"];
          rightup = ["10"];
        };
        bug = {
          mid = ["2" "*"];
          left = ["3"];
          rightdown = ["1"];
          rightup = ["10"];
        };
        game = {
          mid = ["9"];
          left = ["3"];
          rightdown = ["2" "*"];
          rightup = ["10"];
        };
      };
    };
  };

  networking = {
    hostName = "vega";
    hostId = "5c13d618";
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "21.11"; # Did you read the comment?
}
