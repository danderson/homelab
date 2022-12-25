{ config, lib, pkgs, flakes, ... } : {
  config = lib.mkIf (config.my.tailscale != "off") {
    services.tailscale = let
      pkg = if config.my.tailscale == "stable"
            then flakes.nixos-unstable.legacyPackages.x86_64-linux.tailscale
            else flakes.tailscale.packages.x86_64-linux.tailscale;
    in {
      enable = true;
      package = pkg;
    };
  };
}
