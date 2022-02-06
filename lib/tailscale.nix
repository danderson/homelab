{ config, lib, pkgs, flakes, ... } :
{
  config = lib.mkIf config.my.tailscale {
    services.tailscale.enable = true;
    services.tailscale.package = flakes.nixos-unstable.legacyPackages.x86_64-linux.tailscale;
    networking.firewall.allowedUDPPorts = [ 41641 ];
    systemd.services.tailscaled.path = [ pkgs.openresolv ];
    # scudo memory allocator segfaults unstable binaries for some
    # reason. https://github.com/NixOS/nixpkgs/issues/100799
    environment.memoryAllocator.provider = "libc";
  };
}
