let
  ns = import ./nix/sources.nix;
  nur = final: prev: {
    nur = import ns.nur {
      nurpkgs = prev;
      pkgs = prev;
    };
  };
  mkModule = unusedKey: { nixpkgs, hm }: {
    pkgs = (import ns.nixos-2105) {
      config = {};
      overlays = [ nur ];
    };
    os = config: import nixpkgs + "/nixos" {
      configuration = [
        ({ nixpkgs.overlays = [ nur ]; })
        (import hm)
        config
      ];
    };
  };

  groups = {
    stable = {
      nixpkgs = ns.nixos-2105;
      hm = ns.hm-2105;
    };
    unstable = {
      nixpkgs = ns.nixos-unstable;
      hm = ns.hm-unstable;
    };
  };
in builtins.mapAttrs mkModule groups
