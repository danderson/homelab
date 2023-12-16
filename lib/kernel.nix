{ config, pkgs, lib, ... }: let
  lts =  pkgs.linuxPackages;
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
