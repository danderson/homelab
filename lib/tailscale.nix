{ config, lib, flakes, pkgs, ... } :{
  options = {
    my.disable-system-tailscale = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };
  config = {
    nixpkgs.overlays = [(final: prev: {
      tailscale = flakes.nixos-unstable.legacyPackages.x86_64-linux.tailscale;
    })];
    services.tailscale.enable = !config.my.disable-system-tailscale;
    environment.systemPackages = lib.mkIf (!config.my.disable-system-tailscale) [ pkgs.tailscale ];
  };
}
