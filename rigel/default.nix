{ flakes, pkgs, ... }: {
  require = [
    ../lib
    ./hardware-configuration.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_5_17;

  my.cpu-vendor = "amd";
  my.desktop = true;
  my.ddc = true;

  networking = {
    hostName = "rigel";
    hostId = "1d358a90";
  };

  hardware.system76.enableAll = true;

  virtualisation.libvirtd = {
    enable = true;
    qemu.runAsRoot = false;
  };
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };

  home-manager.users.dave.my.i3Monitors = {
    left = "DisplayPort-1";
    mid = "DisplayPort-2";
    rightdown = "DisplayPort-0";
    rightup = "HDMI-A-0";
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "21.11"; # Did you read the comment?
}
