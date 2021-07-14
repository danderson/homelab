{
  description = "Personal NixOS configs";

  inputs = {
    nixos-prev.url = github:NixOS/nixpkgs/nixos-20.09;
    nixos.url = github:NixOS/nixpkgs/nixos-21.05;
    nixos-unstable.url = github:NixOS/nixpkgs/nixos-unstable;
    nixos-hardware.url = github:NixOS/nixos-hardware;
    home-manager.url = github:nix-community/home-manager/release-21.05;
    home-manager-prev.url = github:nix-community/home-manager/release-20.09;
    home-manager-unstable.url = github:nix-community/home-manager/master;
    nur.url = github:nix-community/NUR;
    my-fork.url = github:danderson/nixpkgs/influxdb2-svc;
  };

  outputs = { self, nixos-prev, nixos, nixos-unstable, home-manager-prev, home-manager, home-manager-unstable, nur, ... } @ flakes:
    let
      box = base: homeBase: name: base.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({
            system.configurationRevision =
              if self ? rev
              then self.rev
              else "DIRTY";
          })
          homeBase.nixosModules.home-manager
          ({ nixpkgs.overlays = [ nur.overlay ]; })
          ./lib/home.nix
          (./. + "/${name}")
        ];
        specialArgs = { inherit flakes; };
      };
    in {
      nixosConfigurations = {
        acrux = box nixos-prev home-manager-prev "acrux";
        gacrux = box nixos-prev home-manager-prev "gacrux";
        izar = box nixos-prev home-manager-prev "izar";
        iris = box nixos-prev home-manager-prev "iris";
        atlas = box nixos home-manager "atlas";
        vega = box nixos-unstable home-manager-unstable "vega";
      };

      devShell.x86_64-linux = with nixos.legacyPackages.x86_64-linux; mkShell {
        buildInputs = [];
        shellHook = ''
        '';
      };
    };
}
