{ pkgs, lib, ...}: let
  emacs = pkgs.emacsWithPackagesFromUsePackage {
    package = pkgs.emacsUnstable;
    config = ./emacs/init.el;
    extraEmacsPackages = epkgs: with epkgs; [
      use-package
      diminish

      base16-theme
      beacon
      vertico
      orderless
      marginalia
      consult
      consult-flycheck
      corfu
      exec-path-from-shell
      eglot
      flycheck
      magit
      dockerfile-mode
      go-mode
      graphviz-dot-mode
      js
      json-mode
      lua-mode
      markdown-mode
      nix-mode
      protobuf-mode
      python
      rust-mode
      scad-mode
      slime
      systemd
      terraform-mode
      web-mode
      yaml-mode
      envrc
    ];
    alwaysEnsure = true;
  };
in {
  home.packages = [ emacs ];
  home.file.".emacs.d/init.el".text = builtins.readFile ./emacs/init.el;
  home.file.".emacs.d/early-init.el".text = builtins.readFile ./emacs/early-init.el;
}
