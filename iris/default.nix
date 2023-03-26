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

  my = {
    cpu-vendor = "intel";
    zfs = true;
    # Ended up on the latest kernel becauze zfs at some point, not
    # willing to downgrade it right now.
    kernel = "latest";
  };

  boot = {
    kernelModules = ["sg"];
    zfs.extraPools = ["data"];
  };

  networking = {
    hostName = "iris";
    hostId = "2a939c2d";
    #defaultGateway = "192.168.4.1";
    nameservers = ["8.8.8.8"];

    interfaces.eno1 = {
      useDHCP = true;
    };
    #interfaces.eno1.ipv4.addresses = [{
    #  address = "192.168.4.3";
    #  prefixLength = 24;
    #}];
    interfaces.enp6s0f1.ipv4.addresses = [{
      address = "10.0.0.2";
      prefixLength = 24;
    }];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    systemPackages = with pkgs; [
      hdparm
      lsscsi
    ];
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "21.11"; # Did you read the comment?
}
