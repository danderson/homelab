{ config, lib, pkgs, flakes, ... } :
let
  firewallOn = config.networking.firewall.enable;
  rpfMode = config.networking.firewall.checkReversePath;
  rpfIsStrict = rpfMode == true || rpfMode == "strict";
in
{
  config = lib.mkIf config.my.tailscale {
    warnings = lib.optional (firewallOn && rpfIsStrict) "Strict reverse path filtering breaks Tailscale exit node use and some subnet routing setups. Consider setting `networking.firewall.checkReversePath` = 'loose'";

    services.tailscale.enable = true;
    services.tailscale.package = flakes.nixos-unstable.legacyPackages.x86_64-linux.tailscale;
    networking.firewall.allowedUDPPorts = [ 41641 ];
    systemd.services.tailscaled.path = [ pkgs.openresolv ];
    # scudo memory allocator segfaults unstable binaries for some
    # reason. https://github.com/NixOS/nixpkgs/issues/100799
    environment.memoryAllocator.provider = "libc";
    systemd.services.tailscaled.stopIfChanged = false;
  };
}
