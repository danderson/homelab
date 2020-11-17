{ config, lib, pkgs, flakes, ... } :
let
  unstable = flakes.nixos-unstable.legacyPackages.x86_64-linux;
  tailscale-bleeding = unstable.buildGoModule rec {
    pname = "tailscale";
    version = "1.2.8";
    tagHash = "37adb62a35d818f4af638924d3fc1526bdeaf215"; # from `git rev-parse v1.2.8`

    src = unstable.fetchFromGitHub {
      owner = "tailscale";
      repo = "tailscale";
      rev = "v${version}";
      sha256 = "0305n5gwp2w36z3yh0w8x3ma8a074zr913cx3y73szln56jz88hg";
    };

    nativeBuildInputs = [ unstable.makeWrapper ];

    CGO_ENABLED = 0;

    vendorSha256 = "01g3jkgl3jrygd154gmjm3dq13nkppd993iym7assdz8mr3rq31s";

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
