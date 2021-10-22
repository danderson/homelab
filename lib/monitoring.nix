{ config, lib, ... }:
{
  services.prometheus.exporters.node = lib.mkIf (!config.boot.isContainer) {
    enable = true;
    enabledCollectors = [ "systemd" ];
  };
}
