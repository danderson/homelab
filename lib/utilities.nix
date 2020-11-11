{ config, pkgs, ... }:
{
  # Things that require setcap wrappers. Everything else is in ../home
  programs = {
    iotop.enable = true;
    iftop.enable = true;
    mtr.enable = true;
    wireshark = {
      enable = config.services.xserver.enable;
      package = pkgs.wireshark-qt;
    };
  };
}
