{ config, lib, ... }: {
  nix = {
    autoOptimiseStore = true;
    useSandbox = true;
    gc = {
      automatic = true;
      dates = "03:15";
      options = "--delete-older-than 30d";
    };
  };

  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: {
      unstable = import <nixos-unstable> {
        config = config.nixpkgs.config;
      };
    };
  };
  
  system.autoUpgrade.enable = lib.mkDefault true;
}
