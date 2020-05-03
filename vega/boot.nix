{ pkgs, ... }: {
  boot = {
    kernelPackages = pkgs.linuxPackages_5_4;
    supportedFilesystems = ["zfs"];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
}
