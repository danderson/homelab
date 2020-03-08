# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      ./lib/basics.nix
      ./lib/networking.nix
      ./lib/nixConfig.nix
      ./lib/noXlibs.nix
      ./lib/services.nix
      ./lib/shell.nix
      ./lib/users.nix
      ./lib/utilities.nix

      ./boot.nix
      ./firewall.nix
      ./hardware-configuration.nix
      ./natprobe.nix
      ./networking.nix
    ];

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?

}
