{ config, lib, pkgs, ... }:
let
  wantMonitoring = !config.boot.isContainer && config.services.tailscale.enable;
in lib.mkIf wantMonitoring
{
  services.prometheus.exporters.node = {
    enable = true;
    enabledCollectors = [ "systemd" ];
  };

  age.secrets.telegraf = {
    file = ./secrets/secret1.age;
    owner = "telegraf";
  };
  services.telegraf = {
    enable = true;
    environmentFiles = [config.age.secrets.telegraf.path];
    extraConfig = {
      outputs.influxdb_v2 = {
        urls = ["http://acrux:8086"];
        token = "$INFLUX_TOKEN";
        organization = "Home";
        bucket = "home";
      };

      inputs = {
        cpu = {
          percpu = true;
          totalcpu = true;
          collect_cpu_time = false;
          report_active = false;
        };

        disk = {
          ignore_fs = ["tmpfs" "devtmpfs" "devfs" "iso9660" "overlay" "aufs" "squashfs"];
        };

        diskio = {};
        mem = {};
        net = {};
        processes = {};
        swap = {};
        system = {};

        zfs = lib.mkIf config.my.zfs {
          poolMetrics = true;
          datasetMetrics = true;
        };

        chrony = {};

        # TODO: DNS?
        # TODO: hddtemp?
        # TODO: ping? TCP/UDP?
        # TODO: plex?
        # TODO: prometheus for livemon?
        # TODO: rasdaemon?
        # TODO: sensors? ipmitool?
        # TODO: smartctl?
      };
    };
  };
  systemd.services.telegraf.path = [ pkgs.chrony ];
}
