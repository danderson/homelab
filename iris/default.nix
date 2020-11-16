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
    nameservers = [ "8.8.8.8" ];

    interfaces.eno1.ipv4.addresses = [{
      address = "192.168.17.13";
      prefixLength = 26;
    }];
    interfaces.wlp0s20u3.useDHCP = true;

    wireless = {
      enable = true;
    };
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
      autoScrub.enable = true;
      autoSnapshot = {
        enable = true;
        frequent = 4;
        hourly = 2;
        daily = 7;
        monthly = 12;
      };
    };
    openssh.ports = [22];
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?
}
