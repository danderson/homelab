{ pkgs, ... }: {
  boot = {
    kernelPackages = pkgs.linuxPackages_5_4;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
}
