{ flakes, pkgs, ... }: {
  require = [
    ../lib
    ./hardware-configuration.nix
  ];

  my = {
    cpu-vendor = "intel";
    desktop = true;
  };

  boot.loader.systemd-boot.enable = true;

  networking = {
    hostName = "canopus";
    hostId = "02658bd1";
  };

  services = {
    upower.enable = true;
    acpid.enable = true;
    colord.enable = true;
    fprintd.enable = true;
    fwupd.enable = true;
  };

  services.logind.lidSwitchExternalPower = "ignore";

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "21.11"; # Did you read the comment?
}
