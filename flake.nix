{
  description = "Personal NixOS configs";

  inputs = {
    nixos-old.url = github:NixOS/nixpkgs/nixos-22.05;
    nixos.url = github:NixOS/nixpkgs/nixos-22.11;
    nixos-unstable.url = github:NixOS/nixpkgs/nixos-unstable;
    nixos-dave.url = github:danderson/nixpkgs/danderson/influx2.4;
    nixos-unstable-small.url = github:NixOS/nixpkgs/nixos-unstable-small;
    nixos-hardware.url = github:NixOS/nixos-hardware;
    home-manager-old = {
      url = github:nix-community/home-manager/release-22.05;
      inputs.nixpkgs.follows = "nixos-old";
    };
    home-manager = {
      url = github:nix-community/home-manager/release-22.11;
      inputs.nixpkgs.follows = "nixos";
    };
    home-manager-unstable = {
      url = github:nix-community/home-manager/master;
      inputs.nixpkgs.follows = "nixos-unstable";
    };
    nur.url = github:nix-community/NUR;
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixos";
    };
    livemon = {
      url = "github:danderson/livemon";
      inputs.nixpkgs.follows = "nixos";
    };
  };

  outputs = { self,
              nur,
              agenix,
              livemon,
              nixos-old,
              home-manager-old,
              nixos,
              home-manager,
              nixos-unstable,
              nixos-unstable-small,
              home-manager-unstable,
              ... } @ flakes:
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
          agenix.nixosModules.age
          homeBase.nixosModules.home-manager
          livemon.nixosModules.livemon
          ({ nixpkgs.overlays = [ nur.overlay ]; })
          ./lib/home.nix
          (./. + "/${name}")
        ];
        specialArgs = { inherit flakes; };
      };
    in {
      nixosConfigurations = {
        acrux = box nixos-old home-manager-old "acrux";
        gacrux = box nixos home-manager "gacrux";
        #mimosa = box nixos-old home-manager-old-old "mimosa";
        izar = box nixos home-manager "izar";
        iris = box nixos home-manager "iris";
        vega = box nixos home-manager "vega";
        rigel = box nixos-old home-manager-old "rigel";
        canopus = box nixos-old home-manager-old "canopus";
      };

      devShell.x86_64-linux = with nixos.legacyPackages.x86_64-linux; mkShell {
        buildInputs = [];
        shellHook = ''
        '';
      };
    };
}
