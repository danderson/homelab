{ pkgs, lib, ...}: let
  emacs = pkgs.emacsWithPackagesFromUsePackage {
    package = pkgs.emacsUnstable;
    config = ./emacs/init.el;
    extraEmacsPackages = epkgs: with epkgs; [
      use-package
      diminish
    ];
    alwaysEnsure = true;
  };
in {
  home.packages = [ emacs ];
  home.file.".emacs.d/init.el".text = builtins.readFile ./emacs/init.el;
  home.file.".emacs.d/early-init.el".text = builtins.readFile ./emacs/early-init.el;
}
