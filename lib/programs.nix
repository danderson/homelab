{ config, lib, pkgs, ... }: let
  fileserve = pkgs.buildGoModule {
    name = "fileserve";
    src = ./progs;
    subPackages = [ "fileserve" ];
    vendorSha256 = "sha256-pQpattmS9VmO3ZIQUFn66az8GSmB4IvYhTTCFn6SUmo=";
  };
  livemon = pkgs.buildGo119Module {
    name = "livemon";
    src = pkgs.fetchFromGitHub {
      owner = "danderson";
      repo = "livemon";
      rev = "6c14d61dffea58b3c81368ea76a4de4e51ec881a";
      sha256 = "sha256-gFjt78iXMdkUQiMeCl42YS0GynYH9E2Ts5bHth5yffU=";
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
