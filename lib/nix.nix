{ flakes, pkgs, ... }: {
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
    settings = {
      sandbox = true;
      trusted-users = ["dave"];
      auto-optimise-store = true;
      substituters = [
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
    gc = {
      automatic = true;
      dates = "03:15";
      options = "--delete-older-than 90d";
    };
    optimise = {
      automatic = true;
      dates = ["03:45"];
    };
    registry = {
      nixos.flake = flakes.nixos;
      nixos-unstable.flake = flakes.nixos-unstable;
    };
  };

  nixpkgs.config.allowUnfree = true;
}
