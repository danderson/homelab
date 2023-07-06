{ config, lib, pkgs, ... }: lib.mkIf config.my.nodeMonitoring {
  services.prometheus.exporters.node = {
    enable = true;
    enabledCollectors = [ "systemd" ];
  };
}
