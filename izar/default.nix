{ flakes, config, pkgs, ... }: {
  require = [
    ../lib
    ./hardware-configuration.nix
    ./sway.nix
    ./i3.nix
    flakes.nixos-hardware.nixosModules.lenovo-thinkpad-t495
  ];

  my.cpu-vendor = "amd";
  my.desktop = true;

  boot = {
    kernelModules = ["acpi_call"];
    extraModulePackages = [config.boot.kernelPackages.acpi_call];
    kernelParams = ["acpi_backlight=native"];
    loader.systemd-boot.enable = true;
  };

  networking = {
    hostName = "izar";
    hostId = "515b13ad";
    firewall.checkReversePath = "loose"; # TODO: why?
  };

  hardware.enableRedistributableFirmware = true;

  hardware.opengl.extraPackages = [ pkgs.amdvlk ];
  hardware.trackpoint.enable = true;

  services = {
    upower.enable = true;
    xserver.videoDrivers = ["amdgpu"];
    acpid.enable = true;
    colord.enable = true;
    fprintd.enable = true;
    fwupd.enable = true;
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "20.03"; # Did you read the comment?
}
