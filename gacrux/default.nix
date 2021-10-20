{ config, flakes, pkgs, lib, ... }:
{
  imports = [
    ../lib
    ./hardware-configuration.nix
    ./private.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/vda";
  networking.hostName = "gacrux";
  networking.interfaces.enp1s0.useDHCP = true;
  networking.nameservers = ["8.8.8.8" "8.8.4.4"];

  boot.supportedFilesystems = ["zfs"];
  boot.zfs.extraPools = ["data"];
  boot.zfs.requestEncryptionCredentials = false;

  environment.systemPackages = [pkgs.irssi];

  services = {
    openssh.openFirewall = false;
    zfs = {
      autoScrub.enable = true;
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?
}
