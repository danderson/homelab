{ pkgs, ... }: {
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs.linuxPackages_4_19;
    supportedFilesystems = ["zfs"];
    kernelModules = ["sg"];
  };
}
