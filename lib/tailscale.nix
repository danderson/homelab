{ config, lib, flakes, ... } : let
  want = config.my.tailscale != "off";
  pkg = if config.my.tailscale == "stable"
        then flakes.nixos-unstable.legacyPackages.x86_64-linux.tailscale
        else flakes.tailscale.packages.x86_64-linux.tailscale;
in lib.mkIf want {
  services.tailscale = {
    enable = true;
    package = pkg;
  };
}
