{
  description = "Personal NixOS configs";

  inputs = {
    nixos.url = github:NixOS/nixpkgs/nixos-20.03;
    nixos-small.url = github:NixOS/nixpkgs/nixos-20.03-small;
    nixos-unstable.url = github:NixOS/nixpkgs/nixos-unstable;
    nixos-hardware.url = github:NixOS/nixos-hardware;
  };

  outputs = { self, nixos, nixos-small, ... } @ flakes:
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
          (./. + "/${name}")
        ];
        specialArgs = { inherit flakes; };
      };
    in {
      nixosConfigurations = {
        acrux = box nixos-small "acrux";
        vega = box nixos "vega";
        iris = box nixos-small "iris";
        atlas = box nixos-small "atlas";
      };

      devShell.x86_64-linux = with nixos.legacyPackages.x86_64-linux; mkShell {
        buildInputs = [];
        shellHook = ''
        '';
      };
    };
}
