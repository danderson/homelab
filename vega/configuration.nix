{ config, pkgs, ... }:
{
  imports =
    [
      <nixos-hardware/lenovo/thinkpad/e495>

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

  boot.kernelParams = [ "acpi_backlight=native" ];
  hardware.enableRedistributableFirmware = true;
  documentation.dev.enable = true;
  # Graphics
  fonts = {
    enableDefaultFonts = true;
    fontconfig.penultimate.enable = true;
    # Give fonts to 32-bit binaries too (e.g. steam).
    fontconfig.cache32Bit = true;
    fonts = with pkgs; [
        google-fonts liberation_ttf opensans-ttf roboto roboto-mono
    ];
  };
  services.xserver = {
    enable = true;
    libinput.enable = true;
    displayManager.lightdm.enable = true;
    desktopManager.mate.enable = true;
  };
  hardware.cpu.amd.updateMicrocode = true;
  hardware.mcelog.enable = true;
  hardware.opengl = {
    enable = true;
    driSupport32Bit = true; # Maybe for steam?
    s3tcSupport = true;
    # TODO: figure out VDPAU support.
    #extraPackages = with pkgs; [ vdpauinfo libvdpau-va-gl ];
  };
  environment.systemPackages = with pkgs; [
    # graphics
    alacritty
    brightnessctl
    # audio
    pavucontrol
  ];
  environment.sessionVariables.TERMINAL = "alacritty";

  networking.hostName = "vega";
  networking.iproute2.enable = true;

  # Audio
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;
  users.users.dave.extraGroups = ["audio" "video"];
  nixpkgs.config.pulseaudio = true;

  hardware.trackpoint = {
    enable = true;
  };
  hardware.u2f.enable = true;
  location.provider = "geoclue2";

  system.autoUpgrade.enable = false;
  security.sudo.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # environment.systemPackages = with pkgs; [
  #   wget vim
  # ];

  services.openssh.enable = true;

  hardware.bluetooth.enable = true;
  services.upower.enable = true;
  programs.mosh.enable = true;
  
  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?
}

