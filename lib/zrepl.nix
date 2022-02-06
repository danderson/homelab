{ flakes, ... }: {
  # zrepl 0.5.0 is only in unstable, as of 2022-02, but has way better
  # sync performance. Pull it into all machines that use it.
  nixpkgs.overlays = [
    (final: prev: {
      zrepl = flakes.nixos-unstable.legacyPackages.x86_64-linux.zrepl;
    })
  ];
}
