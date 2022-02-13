{ config, lib, pkgs, ... }: let
  fileserve = pkgs.buildGoModule {
    name = "fileserve";
    src = ./progs;
    subPackages = [ "fileserve" ];
    vendorSha256 = "sha256-pQpattmS9VmO3ZIQUFn66az8GSmB4IvYhTTCFn6SUmo=";
  };
  livemon = pkgs.buildGo117Module {
    name = "livemon";
    src = pkgs.fetchFromGitHub {
      owner = "danderson";
      repo = "livemon";
      rev = "0f360d63adf735dad4336cdc95bfbf9297d1bdb1";
      sha256 = "sha256-5PwsQXLIzZaISkUFKS0zdLzAuqU74gWkMk6tsusn040=";
    };
    vendorSha256 = "sha256-hw+vD9vo/lSHSVCMGdTFaO/dwAocAkcUyADANu12zjc=";
  };
in {
  nixpkgs.overlays = [
    (final: prev: {
      my = {
        fileserve = fileserve;
        livemon = livemon;
      };
    })
  ];

  systemd.services.livemon = lib.mkIf config.my.livemon {
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      ExecStart = "${pkgs.my.livemon}/bin/livemon daemon --addr=[::]:9843";
      StateDirectory = "livemon";
      RuntimeDirectory = "livemon";
    };
  };
}
