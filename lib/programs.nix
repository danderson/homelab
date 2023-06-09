{ pkgs, flakes, ... }: let
  fileserve = pkgs.buildGoModule {
    name = "fileserve";
    src = ./progs;
    subPackages = [ "fileserve" ];
    vendorSha256 = null;
  };
  directory = pkgs.buildGoModule {
    name = "directory";
    src = ./progs;
    subPackages = [ "directory" ];
    vendorSha256 = null;
  };
  layout = pkgs.buildGoModule {
    name = "layout";
    src = ./progs;
    subPackages = [ "layout" ];
    vendorSha256 = null;
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
