{ flakes, pkgs, ... }: {
  require = [
    ../lib
    ./hardware-configuration.nix
    ./i3.nix
    ./private.nix
  ];

  my.cpu-vendor = "amd";
  my.desktop = true;
  my.ddc = true;

  boot.loader.systemd-boot.enable = true;

  networking = {
    hostName = "rigel";
    hostId = "1d358a90";
  };

  hardware.system76.enableAll = true;

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

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "21.11"; # Did you read the comment?
}
