{ pkgs, flakes, ... }: let
  fileserve = pkgs.buildGoModule {
    name = "fileserve";
    src = ./progs;
    subPackages = [ "fileserve" ];
    vendorHash = null;
  };
  directory = pkgs.buildGoModule {
    name = "directory";
    src = ./progs;
    subPackages = [ "directory" ];
    vendorHash = null;
  };
  layout = pkgs.buildGoModule {
    name = "layout";
    src = ./progs;
    subPackages = [ "layout" ];
    vendorHash = null;
  };
in {
  nixpkgs.overlays = [
    (final: prev: {
      my = {
        fileserve = fileserve;
        directory = directory;
        livemon = flakes.livemon.packages.x86_64-linux.livemon;
        layout = layout;
      };
    })
  ];
}
