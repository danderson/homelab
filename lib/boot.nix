{ lib, ... }:
{
  boot.loader = {
    systemd-boot.configurationLimit = lib.mkDefault 5;
    efi.canTouchEfiVariables = lib.mkDefault true;
  };
}
