{ pkgs, ... }:
let
  overlay = 
    self: super: {
      tailscale = self.buildGoModule rec {
        pname = "tailscale";
        # Tailscale uses "git describe" as version numbers. 0.100.0-153
        # means "tag v0.100.0 plus 153 commits", which corresponds to the
        # commit hash below.
        version = "0.100.0-153";

        src = self.fetchFromGitHub {
          owner = "tailscale";
          repo = "tailscale";
          rev = "c06d2a851325b7b1f3f0ef99fe794df023d6ff8f";
          sha256 = "1alvsbkpmkra26imhr2927jqwqxcp9id6y8l9mgxhyh3z7qzql8w";
        };

        nativeBuildInputs = [ self.makeWrapper ];

        CGO_ENABLED = 0;

        goPackagePath = "tailscale.com";
        modSha256 = "02p1ifs3db18aapn1pywamim6qry0k3bqpharsz4if05yhpcl09d";
        subPackages = [ "cmd/tailscale" "cmd/tailscaled" ];

        postInstall = ''
          wrapProgram $out/bin/tailscaled --prefix PATH : ${
            self.lib.makeBinPath [ self.iproute self.iptables ]
          }
        '';

        meta = with self.lib; {
          homepage = "https://tailscale.com";
          description = "The node agent for Tailscale, a mesh VPN built on WireGuard";
          platforms = platforms.linux;
          license = licenses.bsd3;
          maintainers = with maintainers; [ danderson mbaillie ];
        };

      };
    };
in
{
  nixpkgs.overlays = [ overlay ];

  services.tailscale.enable = true;
  environment.systemPackages = [ pkgs.tailscale ];
}
