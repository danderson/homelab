{
  description = "Personal NixOS configs";

  inputs = {
    nixos.url = github:NixOS/nixpkgs/nixos-20.09;
    nixos-small.url = github:NixOS/nixpkgs/nixos-20.09-small;
    nixos-unstable.url = github:NixOS/nixpkgs/nixos-unstable;
    nixos-hardware.url = github:NixOS/nixos-hardware;
    home-manager.url = github:nix-community/home-manager/release-20.09;
    nur.url = github:nix-community/NUR;
    my-fork.url = github:danderson/nixpkgs/influxdb2-svc;
  };

  outputs = { self, nixos, nixos-small, home-manager, nur, ... } @ flakes:
    let
      box = base: name: base.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({
            system.configurationRevision =
              if self ? rev
              then self.rev
              else "DIRTY";
          })
          home-manager.nixosModules.home-manager
          ({ nixpkgs.overlays = [ nur.overlay ]; })
          ./lib/home.nix
          (./. + "/${name}")
        ];
        specialArgs = { inherit flakes; };
      };
    in {
      nixosConfigurations = {
        acrux = box nixos-small "acrux";
        gacrux = box nixos-small "gacrux";
        vega = box nixos "vega";
        iris = box nixos-small "iris";
        atlas = box nixos-small "atlas";
        nixos = box nixos "nixos";
      };

      devShell.x86_64-linux = with nixos.legacyPackages.x86_64-linux; mkShell {
        buildInputs = [];
        shellHook = ''
        '';
      };
    };
}
