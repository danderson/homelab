{ pkgs, lib, ...}: let
in {
    programs.emacs.enable = true;
    home.file.".emacs.d/init.el".text = builtins.readFile ./emacs/init.el;
    home.file.".emacs.d/early-init.el".text = builtins.readFile ./emacs/early-init.el;
}