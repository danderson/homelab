{ config, lib, ... }: let
  loader = config.my.bootloader;
  bareMetal = !config.boot.isContainer;
  useSDBoot = bareMetal && loader == "systemd-boot";
  useGrub = bareMetal && loader == "grub";
in {
  assertions = [
    {
      assertion = useGrub -> config.boot.loader.grub.device != "";
      message = ''
        You must specify the grub install device if using grub.
      '';
    }
  ];

  boot.loader = {
    systemd-boot.enable = useSDBoot;
    systemd-boot.configurationLimit = lib.mkDefault 5;
    efi.canTouchEfiVariables = lib.mkDefault true;

    grub.enable = useGrub;
    grub.version = 2;
  };
}
