{ config, lib, pkgs, ... }: let
  fileserve = pkgs.buildGoModule {
    name = "fileserve";
    src = ./progs;
    subPackages = [ "fileserve" ];
    vendorSha256 = "sha256-pQpattmS9VmO3ZIQUFn66az8GSmB4IvYhTTCFn6SUmo=";
  };
in {
  nixpkgs.overlays = [
    (final: prev: {
      my = {
        fileserve = fileserve;
      };
    })
  ];
}
