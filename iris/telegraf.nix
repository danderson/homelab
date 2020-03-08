{ pkgs, ... }:
{
  services.telegraf = {
    enable = true;
    extraConfig = {
      agent = {
        interval = "1s";
        flush_interval = "1s";
      };
      inputs = {
        cpu = {};
        disk = {};
        diskio = {};
        dns_query = {
          servers = ["8.8.8.8" "192.168.17.1"];
          domains = ["google.com."];
        };
        ipmi_sensor = {
          interval = "10s";
          timeout = "5s";
          metric_version = 2;
        };
        mem = {};
        ping = {
          urls = ["8.8.8.8"];
        };
        system = {};
        temp = {};
        zfs = {};
      };

      outputs.prometheus_client = {
        listen = ":9273";
      };
    };
  };
  systemd.services.telegraf = {
    path = with pkgs; [ipmitool unixtools.ping];
    serviceConfig = {
      CapabilityBoundingSet = "CAP_NET_RAW";
      AmbientCapabilities = "CAP_NET_RAW";
      Group = "telegraf";
    };
  };
  services.udev.extraRules = ''KERNEL=="ipmi*", MODE="660", GROUP="telegraf"'';
  users.groups.telegraf = {};
}
