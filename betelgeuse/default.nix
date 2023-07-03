{ pkgs, ... }:
let
  users = import ./users.nix;
in
{
  imports = [
    ../lib

    ./hardware-configuration.nix
  ];

  my = {
    cpu-vendor = "intel";
    bootloader = "grub";
    archive = {
      "shortener" = 2;
      "reddit" = 8;
      "imgur" = 4;
      "issuu" = 0;
      "telegram" = 2;
      "github" = 2;
      "pastebin" = 2;
      "mediafire" = 2;
    };
  };

  boot.loader.grub.device = "/dev/vda";

  networking = {
    hostName = "betelgeuse";

    interfaces.enp1s0 = {
      useDHCP = true;
    };
  };

  services.journald.extraConfig = "Storage=volatile";
  services.tailscale.interfaceName = "userspace-networking";

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "23.05"; # Did you read the comment?
}
