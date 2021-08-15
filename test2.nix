let
  ns = import ./nix/sources.nix;
  pkgs = (import ns.nixos-2105) {};
in pkgs.freecad
