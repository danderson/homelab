{ config, lib, pkgs, ... }: let
  zfs = if config.my.zfs then [ "zfs" ] else [];
in lib.mkIf config.my.nodeMonitoring {
  services.prometheus.exporters.node = {
    enable = true;
    enabledCollectors = [ "systemd" ] ++ zfs;
  };
}
