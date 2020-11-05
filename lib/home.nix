{ config, ... }:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.dave = {
      imports = [ ../home ];
      my.gui-programs = config.services.xserver.enable;
    };
  };
}
