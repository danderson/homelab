{ flakes, config, pkgs, ... }: {
  require = [
    ../lib
    ./hardware-configuration.nix
    flakes.nixos-hardware.nixosModules.lenovo-thinkpad-t495
  ];

  my.cpu-vendor = "amd";
  my.desktop = true;
  my.zfs = true;

  boot = {
    kernelModules = ["acpi_call"];
    extraModulePackages = [config.boot.kernelPackages.acpi_call];
    kernelParams = ["acpi_backlight=native"];
  };

  networking = {
    hostName = "izar";
    hostId = "515b13ad";
  };

  hardware.opengl.extraPackages = [ pkgs.amdvlk ];
  hardware.trackpoint.enable = true;

  #services.openiscsi.enable = true;
  #services.openiscsi.name = "iqn.2020-08.org.linux-iscsi.izar:izar";

  services = {
    upower.enable = true;
    xserver.videoDrivers = ["amdgpu"];
    acpid.enable = true;
    colord.enable = true;
    fprintd.enable = true;
    fwupd.enable = true;
  };

  home-manager.users.dave.my.monitors = {};

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "21.11"; # Did you read the comment?
}
