{ pkgs, ... }: {
  boot = {
    kernelPackages = pkgs.linuxPackages_5_4;
    supportedFilesystems = ["zfs"];
    zfs.requestEncryptionCredentials = true;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
}
