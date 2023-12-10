{ config, pkgs, lib, ... }: let
  lts = pkgs.linuxPackagesFor (pkgs.linux_6_1.override {
    argsOverride = rec {
      src = pkgs.fetchurl {
        url = "mirror://kernel/linux/kernel/v6.x/linux-${version}.tar.xz";
        sha256 = "sha256-QZ5izWxCOeaVC2iNueh1PrHpnCFtwyBPeTI5ij/vGgw=";
      };
      version = "6.1.66";
      modDirVersion = "6.1.66";
    };
  });
  #pkgs.linuxPackages;
  latestNoZFS = pkgs.linuxPackages_latest;
  latestZFS = config.boot.zfs.package.latestCompatibleLinuxPackages;
  latest = if config.my.zfs then latestZFS else latestNoZFS;
  wantLatest = config.my.kernel == "latest";
  # Slightly more preferred than mkDefault, but less than everything
  # else.  nixos-hardware sometimes lib.mkDefaults things, and usually
  # I want my opinion to win.
  mkMyDefault = lib.mkOverride 999;
in {
  boot.kernelPackages = mkMyDefault (if wantLatest then latest else lts);
}
