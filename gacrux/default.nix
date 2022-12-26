{ config, flakes, pkgs, lib, ... }:
{
  imports = [
    ../lib
    ./hardware-configuration.nix
    ./private.nix
  ];

  my = {
    bootloader = "grub";
    zfs = true;
    # Ended up on the latest kernel becauze zfs at some point, not
    # willing to downgrade it right now.
    kernel = "latest";
  };
  boot.loader.grub.device = "/dev/vda";

  networking = {
    hostName = "gacrux";
    interfaces.enp1s0.useDHCP = true;
    nameservers = ["8.8.8.8" "8.8.4.4"];
  };

  # The ZFS pool isn't used by local mounts, have to import it
  # explicitly and not try to decrypt it.
  boot.zfs.extraPools = [ "data" ];
  boot.zfs.requestEncryptionCredentials = false;

  # Accessible over Tailscale and other private means only.
  services.openssh.openFirewall = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}
