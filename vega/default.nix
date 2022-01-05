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

  my.cpu-vendor = "amd";
  my.desktop = true;
  my.ddc = true;

  boot.loader.systemd-boot.enable = true;

  networking = {
    hostName = "vega";
    hostId = "5c13d618";
  };

  services.fwupd.enable = true;

  virtualisation.libvirtd = {
    enable = true;
    qemu.runAsRoot = false;
  };
  virtualisation.virtualbox.host = {
    enable = true;
    enableExtensionPack = true;
  };
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };

  home-manager.users.dave.my.i3ExtraCommands = [
    "${pkgs.xorg.xrandr}/bin/xrandr --output DisplayPort-0 --primary --mode 2560x1440 --rate 75 --pos 2560x383 --rotate normal --output DisplayPort-1 --mode 2560x1440 --rate 75 --pos 0x383 --rotate normal --output DisplayPort-2 --mode 2560x1440 --rate 75 --pos 5120x1440 --rotate normal --output HDMI-A-0 --mode 2560x1440 --rate 75 --pos 5120x0 --rotate normal"
    "${pkgs.openrgb}/bin/openrgb -p magenta.orp"
    "${pkgs.openrgb}/bin/openrgb --gui --startminimized"
    "${pkgs.picom}/bin/picom -CGb"
    "${pkgs.nitrogen}/bin/nitrogen --restore"
  ];

  # udev rule to allow the "dialout" group to speak to my Lattice FPGA
  # board over its USB-serial chip.
  services.udev.extraRules = ''
    # FPGA dev board
    SUBSYSTEM=="tty", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6015", MODE="664", GROUP="dialout"
    ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6015", MODE="664", GROUP="dialout"
  '';

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "20.09"; # Did you read the comment?
}
