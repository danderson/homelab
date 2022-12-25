{ flakes, ... }: {
  nixpkgs.overlays = [
    (final: prev: {
      zrepl = flakes.nixos-unstable.legacyPackages.x86_64-linux.zrepl;
    })
  ];
}
