{ config, pkgs, ... }:
{
  imports =
    [
      <nixos-hardware/lenovo/thinkpad/t495>

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

  boot = {
    kernelModules = [ "acpi_call" ];
    extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];
  };
  boot.kernelParams = [ "acpi_backlight=native" ];

  nix.allowedUsers = [ "@wheel" ];

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
    # TODO: alacritty
    brightnessctl
    # audio
    pavucontrol

    google-chrome # TODO: move into home-manager

    home-manager
  ];
  #environment.sessionVariables.TERMINAL = "alacritty";

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

  hardware.bluetooth.enable = true;
  programs = {
    iftop.enable = true;
    iotop.enable = true;
    less.enable = true;
    mosh.enable = true;
    mtr.enable = true;
    ssh.startAgent = true;
    usbtop.enable = true;
  };

  services = {
    upower.enable = true; # also enabled by gnome, but y'know
    openssh.enable = true;
    xserver = {
      enable = true;
      libinput.enable = true;

      desktopManager.gnome3.enable = true;
      displayManager.gdm.enable = true;
      enableCtrlAltBackspace = true;
      videoDrivers = [ "amdgpu" ];
    };
    tlp.enable = true;
    acpid.enable = true;
    colord.enable = true;
    emacs.enable = true;
    fprintd.enable = true;
    fwupd.enable = true;
    geoip-updater.enable = true;
    redshift.enable = true;
  };
  
  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "20.03"; # Did you read the comment?
}
