{ flakes, pkgs, ... }:

{
  require = [
    ../lib
    ./hardware-configuration.nix
  ];

  my = {
    cpu-vendor = "amd";
    gpu = "amd";
    desktop = true;
    gaming = true;
    printing = true;
    ulxs = true;
    jlink = true;
    flipperZero = true;
    fwupd = true;
    tailscale = "unstable";
    layout = {};
  };

  networking.hostName = "orion";

  boot.initrd.luks.devices."luks-07c27445-7b46-4290-ade7-58de02a821ae".device = "/dev/disk/by-uuid/07c27445-7b46-4290-ade7-58de02a821ae";

  #services.xserver.enable = true;
  #services.xserver.displayManager.sddm.enable = true;
  #services.xserver.desktopManager.plasma5.enable = true;
  #services.xserver = {
  #  layout = "us";
  #  xkbVariant = "";
  #};

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
