{ config, pkgs, ... }:
{
  imports = [
    ../lib
    ./hardware-configuration.nix
    ./private.nix
    ./influxdb2.nix
  ];

  my.cpu-vendor = "intel";

  boot.supportedFilesystems = ["zfs"];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "acrux"; # Define your hostname.
  networking.defaultGateway = "192.168.1.254";
  networking.nameservers = ["192.168.1.254"];
  networking.interfaces.eno1 = {
    useDHCP = false;
    ipv4 = {
      addresses = [
        {
          address = "192.168.1.2";
          prefixLength = 24;
        }
      ];
    };
  };
  networking.interfaces.eno2.useDHCP = false;
  networking.interfaces.eno3.useDHCP = false;
  networking.interfaces.eno4.useDHCP = false;

  environment.systemPackages = with pkgs; [
    hdparm
    lsscsi
  ];

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
    influxdb2 = {
      enable = true;
      config = {
        bolt-path = "/data/monitoring/influxdb2/influxd.bolt";
        engine-path = "/data/monitoring/influxdb2/engine";
      };
    };
    #fwupd.enable = false; # Mass rebuild?
  };

  # power.ups.enable = true # need to figure out out how

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?
}
