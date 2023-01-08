{ config, flakes, pkgs, lib, ... }: {
  require = [
    ../lib
    ./hardware-configuration.nix
    flakes.nixos-hardware.nixosModules.framework
  ];

  my = {
    cpu-vendor = "intel";
    gpu = "intel";
    desktop = true;
    zfs = true;
    fwupd = "framework";
  };

  networking = {
    hostName = "canopus";
    hostId = "02658bd1";
  };

  services = {
    upower.enable = true;
    acpid.enable = true;
    colord.enable = true;
    fprintd.enable = true;
  };

  home-manager.users.dave.my.layout = {
    outputs.laptop = {
      output = "eDP-1";
      position.x = 0;
      position.y = 0;
      resolution.x = 2256;
      resolution.y = 1504;
      refreshRate = 60;
    };
    layouts = {
      code = { laptop = ["1" "*"]; };
      bug = { laptop = ["2" "*"]; };
    };
  };

  # Stay running with lid closed on AC power.
  services.logind.lidSwitchExternalPower = "ignore";

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "21.11"; # Did you read the comment?
}
