{
  description = "Personal NixOS configs";

  inputs = {
    nixos.url = github:NixOS/nixpkgs/nixos-21.05;
    nixos-unstable.url = github:NixOS/nixpkgs/nixos-unstable;
    nixos-hardware.url = github:NixOS/nixos-hardware;
    home-manager.url = github:nix-community/home-manager/release-21.05;
    home-manager-unstable.url = github:nix-community/home-manager/master;
    nur.url = github:nix-community/NUR;
  };

  outputs = { self, nixos, nixos-unstable, home-manager, home-manager-unstable, nur, ... } @ flakes:
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
        acrux = box nixos home-manager "acrux";
        gacrux = box nixos home-manager "gacrux";
        mimosa = box nixos home-manager "mimosa";
        izar = box nixos home-manager "izar";
        iris = box nixos home-manager "iris";
        vega = box nixos home-manager "vega";
      };

      devShell.x86_64-linux = with nixos.legacyPackages.x86_64-linux; mkShell {
        buildInputs = [];
        shellHook = ''
        '';
      };
    };
}
