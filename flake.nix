{
  description = "Personal NixOS configs";

  inputs = {
    nixos-old.url = github:NixOS/nixpkgs/nixos-23.05;
    nixos.url = github:NixOS/nixpkgs/nixos-23.11;
    nixos-unstable.url = github:NixOS/nixpkgs/nixos-unstable;
    nixos-dave.url = github:danderson/nixpkgs/templ-grammar;
    nixos-unstable-small.url = github:NixOS/nixpkgs/nixos-unstable-small;
    nixos-hardware.url = github:NixOS/nixos-hardware;
    templ = {
      url = github:a-h/templ;
      inputs.nixpkgs.follows = "nixos-unstable";
    };
    home-manager-old = {
      url = github:nix-community/home-manager/release-23.05;
      inputs.nixpkgs.follows = "nixos-old";
    };
    home-manager = {
      url = github:nix-community/home-manager/release-23.11;
      inputs.nixpkgs.follows = "nixos";
    };
    home-manager-unstable = {
      url = github:nix-community/home-manager/master;
      inputs.nixpkgs.follows = "nixos-unstable";
    };
    nur.url = github:nix-community/NUR;
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixos-unstable";
    };
    livemon = {
      url = "github:danderson/livemon";
      inputs.nixpkgs.follows = "nixos-unstable";
    };
    tailscale = {
      url = "github:tailscale/tailscale";
      inputs.nixpkgs.follows = "nixos-unstable";
    };
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay/master";
      inputs.nixpkgs.follows = "nixos-unstable";
    };

    combobulate = {
      url = "github:mickeynp/combobulate";
      flake = false;
    };
    templ-ts-mode = {
      url = "github:danderson/templ-ts-mode";
      inputs.nixpkgs.follows = "nixos-unstable";
      inputs.templ.follows = "templ";
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
              tailscale,
              emacs-overlay,
              templ,
              nixos-dave,
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
          ({
            nixpkgs.overlays = [
              nur.overlay
              emacs-overlay.overlay
              templ.overlays.default
            ];
          })
          ./lib/home.nix
          (./. + "/${name}")
        ];
        specialArgs = { inherit flakes; };
      };

    in {
      nixosConfigurations = {
        acrux = box nixos home-manager "acrux";
        gacrux = box nixos home-manager "gacrux";
        izar = box nixos home-manager "izar";
        iris = box nixos home-manager "iris";
        vega = box nixos home-manager "vega";
        rigel = box nixos home-manager "rigel";
        canopus = box nixos home-manager "canopus";
        betelgeuse = box nixos-old home-manager-old "betelgeuse";
        orion = box nixos home-manager "orion";
      };

      devShell.x86_64-linux = with nixos.legacyPackages.x86_64-linux; mkShell {
        buildInputs = [
          gnumake
        ];
        shellHook = ''
        '';
      };
    };
}
