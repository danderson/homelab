{ config, pkgs, ... }:
{
  imports =
    [
      ./lib/basics.nix
      ./lib/networking.nix
      ./lib/nixConfig.nix
      ./lib/shell.nix
      ./lib/users.nix
      ./lib/utilities.nix

      ./boot.nix
      ./firewall.nix
      ./hardware-configuration.nix
      ./networking.nix
    ];

  system.autoUpgrade.enable = false;
  security.sudo.enable = true;
  powerManagement.cpuFreqGovernor = "powersave";
  services.xserver = {
    enable = true;
    libinput.enable = true;
    displayManager.lightdm.enable = true;
    desktopManager.mate.enable = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # environment.systemPackages = with pkgs; [
  #   wget vim
  # ];

  services.openssh.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?
}

