{ config, pkgs, lib, ... }: let
  lts = pkgs.linuxPackages;
  latestNoZFS = pkgs.linuxPackages_latest;
  latestZFS = config.boot.zfs.package.latestCompatibleLinuxPackages;
  latest = if config.my.zfs then latestZFS else latestNoZFS;
  wantLatest = config.my.kernel == "latest";
in {
  boot.kernelPackages = lib.mkDefault (if wantLatest then latest else lts);
}
