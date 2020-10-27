{config, lib, flakes, pkgs, ...}:
{
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
    autoOptimiseStore = true;
    useSandbox = true;
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

  nixpkgs.config = {
    allowUnfree = true;
  };
}
