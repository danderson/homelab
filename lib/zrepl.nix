{ flakes, ... }: {
  # Use unstable zrepl everywhere, because during release upgrades I
  # often end up with the primary NAS on an older release and the
  # backup targets on the newer one - which can cause backups to stall
  # due to version mismatches.
  nixpkgs.overlays = [
    (final: prev: {
      zrepl = flakes.nixos-unstable.legacyPackages.x86_64-linux.zrepl;
    })
  ];
}
