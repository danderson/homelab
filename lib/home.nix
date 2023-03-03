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
          flakes.vscode-server.nixosModules.home
          ../home
        ];
        my = config.my;
      };
      root = {
        imports = [
          pkgs.nur.repos.rycee.hmModules.emacs-init
          flakes.vscode-server.nixosModules.home
          ../home
        ];
        my = config.my;
      };
    };
  };
}
