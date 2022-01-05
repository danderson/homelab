{ config, lib, pkgs, flakes, ... } :
{
  config = lib.mkIf (!config.boot.isContainer) {
    services.tailscale.enable = true;
    services.tailscale.package = flakes.nixos-unstable.legacyPackages.x86_64-linux.tailscale;
    systemd.services.tailscaled.path = [ pkgs.openresolv ];
    # scudo memory allocator segfaults unstable binaries for some
    # reason. https://github.com/NixOS/nixpkgs/issues/100799
    environment.memoryAllocator.provider = "libc";
  };
}
