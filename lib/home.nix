{ config, pkgs, ... }:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users = {
      dave = {
        imports = [
          pkgs.nur.repos.rycee.hmModules.emacs-init
          ../home
        ];
        my.gui-programs = config.services.xserver.enable;
      };
      root = {
        imports = [
          pkgs.nur.repos.rycee.hmModules.emacs-init
          ../home
        ];
      };
    };
  };
}
