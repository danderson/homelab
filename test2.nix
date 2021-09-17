let
  ns = import ./nix/sources.nix;
  pkgs = (import ns.nixos-2105) {};
in {
  keys = builtins.attrNames pkgs.freecad.stdenv;
  pkg = pkgs.freecad.stdenv;
}
