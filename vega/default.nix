{ flakes, pkgs, ... }: {
  require = [
    ../lib
    ./hardware-configuration.nix
    ./i3.nix
    ./private.nix
    ./tailscale.nix
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
  home-manager.users.dave.my.home-desk = true;

  boot = rec {
    kernelPackages = pkgs.linuxPackages_5_14;
    kernelModules = ["i2c-dev" "i2c-i801"];
    extraModulePackages = [kernelPackages.acpi_call kernelPackages.v4l2loopback];
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    zfs.enableUnstable = true;
  };

  networking = {
    hostName = "vega";
    hostId = "5c13d618";
  };

  home-manager.users.dave.home.file = {
    "bin/tss" = {
      executable = true;
      text = builtins.readFile ./tailscale-switch-profile.sh;
    };
    "bin/delbr" = {
      executable = true;
      text = builtins.readFile ./delete-my-old-branches.sh;
    };
    "bin/layout" = {
      executable = true;
      text = builtins.readFile ./layout.sh;
    };
  };

  environment.systemPackages = [ pkgs.barrier pkgs.mono pkgs.libgdiplus ];

  services.fwupd.enable = true;
  networking.firewall.allowedTCPPorts = [ 24800 ];
  networking.firewall.allowedUDPPorts = [ 24800 ];

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

  # udev rule to allow the "dialout" group to speak to my Lattice FPGA
  # board over its USB-serial chip.
  services.udev.extraRules = ''
    # FPGA dev board
    SUBSYSTEM=="tty", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6015", MODE="664", GROUP="dialout"
    ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6015", MODE="664", GROUP="dialout"

    # RGB controllers
    KERNEL=="i2c-[0-99]*", TAG+="uaccess"
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", TAG+="uaccess"
  '';

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "20.09"; # Did you read the comment?
}
