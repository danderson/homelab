{ config, pkgs, flakes, ... }: {
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
        my.printing = config.my.printing;
        my.gaming = config.my.gaming;
        my.extraPkgs = config.my.extraHomePkgs;
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
