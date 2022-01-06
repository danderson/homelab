{ config, lib, ... }:
{
  boot.loader = {
    systemd-boot.configurationLimit = lib.mkDefault 5;
    efi.canTouchEfiVariables = if config.boot.loader.systemd-boot.enable then lib.mkDefault true else lib.mkDefault false;
  };
}
