{ flakes, config, pkgs, ... }: {
  require = [
    ../lib
    ./hardware-configuration.nix
    ./private.nix
    flakes.nixos-hardware.nixosModules.lenovo-thinkpad-t495
  ];

  my = {
    cpu-vendor = "amd";
    gpu = "amd";
    desktop = true;
    zfs = true;
    tailscale = "unstable";
    layout = {};
  };

  networking = {
    hostName = "izar";
    hostId = "515b13ad";
  };

  services = {
    upower.enable = true;
    acpid.enable = true;
    colord.enable = true;
    fprintd.enable = true;
    fwupd.enable = true;
  };

  # Stay running with lid closed on AC power.
  services.logind.lidSwitchExternalPower = "ignore";

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "21.11"; # Did you read the comment?
}
