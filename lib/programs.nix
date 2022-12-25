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
      rev = "3ca7dbe92730456416abd482397c4a97d46ca94a";
      sha256 = "sha256-6eeUAdJTDmnoNNGQ1hfjuM4EzIGm+XyPuwzlauUQVEM=";
    };
    vendorSha256 = "sha256-++SNlauqfk3RkwlocO3Yc7Hl/fxscLWwlMIL906A/n4=";
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
