{ config, lib, pkgs, flakes, ... } :
let
  unstable = flakes.nixos-unstable.legacyPackages.x86_64-linux;
  tailscale-bleeding = unstable.buildGoModule rec {
    pname = "tailscale";
    version = "1.3.269";
    tagHash = "303786c5e0cd67e4036ac5c0845c6a09eb72df84";

    src = unstable.fetchFromGitHub {
      owner = "tailscale";
      repo = "tailscale";
      rev = "da4ec54756d1f8970679872d093fe9fc0c2df417";
      sha256 = "1ih4nififccdgxj42ppj0hdyk2hvbc7iqlbywnmnjsqkbnj2sn3f";
    };

    nativeBuildInputs = [ unstable.makeWrapper ];

    CGO_ENABLED = 0;

    vendorSha256 = "0hg7w86xmplhj2g5mywjcmdkb9z6blz1j97hyi9wksm1s8wv3cpr";

    doCheck = false;

    subPackages = [ "cmd/tailscale" "cmd/tailscaled" ];

    preBuild = ''
      export buildFlagsArray=(
        -tags="xversion"
        -ldflags="-X tailscale.com/version.Long=${version} -X tailscale.com/version.Short=${version} -X tailscale.com/version.GitCommit=${tagHash}"
      )
    '';

    postInstall = ''
      wrapProgram $out/bin/tailscaled --prefix PATH : ${
        lib.makeBinPath [ unstable.iproute unstable.iptables ]
      }
      sed -i -e "s#/usr/sbin#$out/bin#" -e "/^EnvironmentFile/d" ./cmd/tailscaled/tailscaled.service
      install -D -m0444 -t $out/lib/systemd/system ./cmd/tailscaled/tailscaled.service
    '';
  };
in
{
  options = {
    my.disable-system-tailscale = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf (!config.boot.isContainer) {
    nixpkgs.overlays = [(final: prev: {
      tailscale = tailscale-bleeding;
    })];
    services.tailscale.enable = !config.my.disable-system-tailscale;
    environment.systemPackages = lib.mkIf (!config.my.disable-system-tailscale) [ pkgs.tailscale ];
    systemd.services.tailscale.path = [ pkgs.openresolv ];
    # scudo memory allocator segfaults unstable binaries for some
    # reason. https://github.com/NixOS/nixpkgs/issues/100799
    environment.memoryAllocator.provider = "libc";
  };
}
