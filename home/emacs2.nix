{ pkgs, lib, ...}: let
    emacs = pkgs.emacsWithPackagesFromUsePackage {
        config = ./emacs/init.el;
        extraEmacsPackages = epkgs: [
            epkgs.use-package
        ];
        alwaysEnsure = true;
    };
in {
    home.packages = [ emacs ];
    home.file.".emacs.d/init.el".text = builtins.readFile ./emacs/init.el;
    home.file.".emacs.d/early-init.el".text = builtins.readFile ./emacs/early-init.el;
}
