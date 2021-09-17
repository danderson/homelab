{ config, pkgs, flakes, ... }:
{
  environment.homeBinInPath = true;
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit flakes; };
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
