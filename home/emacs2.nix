{ pkgs, lib, ...}: let
  is2305 = builtins.hasAttr "emacs29" pkgs;
  emacs = pkgs.emacsWithPackagesFromUsePackage {
    package = if is2305 then pkgs.emacs29 else pkgs.emacsUnstable;
    config = ./emacs/init.el;
    extraEmacsPackages = epkgs: with epkgs; [
      use-package
      diminish
      (if is2305 then treesit-grammars.with-all-grammars else null)
    ];
    alwaysEnsure = true;
  };
in {
  home.packages = [ emacs ];
  home.file.".emacs.d/init.el".text = builtins.readFile ./emacs/init.el;
  home.file.".emacs.d/early-init.el".text = builtins.readFile ./emacs/early-init.el;
}
