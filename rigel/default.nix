{ flakes, pkgs, ... }: {
  require = [
    ../lib
    ./hardware-configuration.nix
    ./i3.nix
    ./private.nix
    ./tailscale.nix
  ];

  my.cpu-vendor = "amd";
  my.desktop = true;
  home-manager.users.dave.my.home-desk = true;

  boot = rec {
    kernelPackages = pkgs.linuxPackages_5_15;
    #kernelModules = ["i2c-dev" "i2c-i801"];
    #extraModulePackages = [kernelPackages.acpi_call kernelPackages.v4l2loopback];
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  networking.hostName = "rigel";
  networking.hostId = "1d358a90";

  environment.systemPackages = [ pkgs.barrier pkgs.mono pkgs.libgdiplus ];

  services.fwupd.enable = true;
  networking.firewall.allowedTCPPorts = [ 24800 ];
  networking.firewall.allowedUDPPorts = [ 24800 ];

  virtualisation.libvirtd = {
    enable = true;
    qemu.runAsRoot = false;
  };
  virtualisation.virtualbox.host = {
    enable = true;
    enableExtensionPack = true;
  };
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };

  # udev rule to allow the "dialout" group to speak to my Lattice FPGA
  # board over its USB-serial chip.
  services.udev.extraRules = ''
    # FPGA dev board
    SUBSYSTEM=="tty", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6015", MODE="664", GROUP="dialout"
    ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6015", MODE="664", GROUP="dialout"
  '';

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "21.11"; # Did you read the comment?
}
