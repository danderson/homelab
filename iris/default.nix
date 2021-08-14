{ pkgs, ... }:
let
  users = import ./users.nix;
in
{
  imports = [
    ../lib

    ./private.nix
    ./hardware-configuration.nix
  ];

  my.cpu-vendor = "intel";
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_4_19;
    supportedFilesystems = ["zfs"];
    kernelModules = ["sg"];
  };

  networking = {
    hostName = "iris";
    hostId = "2a939c2d";
    defaultGateway = "192.168.1.254";
    nameservers = ["192.168.1.254"];

    interfaces.eno1.ipv4.addresses = [{
      address = "192.168.1.3";
      prefixLength = 24;
    }];
  };

  powerManagement.cpuFreqGovernor = "performance";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    systemPackages = with pkgs; [
      hdparm
      lsscsi
    ];
  };

  services = {
    zfs = {
      autoScrub.enable = false;
      autoSnapshot = {
        enable = false;
        frequent = 4;
        hourly = 2;
        daily = 7;
        monthly = 12;
      };
    };
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?
}
