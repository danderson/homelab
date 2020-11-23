{ config, lib, pkgs, ... }: lib.mkIf (!config.boot.isContainer) {
  systemd.services.telegraf.path = [pkgs.ping pkgs.smartmontools pkgs.lm_sensors];
  services.telegraf = {
    enable = true;
    extraConfig = {
      agent = {
        interval = "10s";
        collection_jitter = "1s";
        logtarget = "stderr";
      };

      outputs = {
        influxdb_v2 = {
          urls = ["http://acrux:8086"];
          token = "WrMOtblhbeLUmKbVqEd7SJ5oif8uyADDlfEEw5KfRxZZp6MpEL1VmhBxjnk6yo3ql1IJjqTDGa7iE06D9BS75A==";
          organization = "Home";
          bucket = "Home";
        };
      };

      inputs = {
        cpu = {
          percpu = true;
          totalcpu = true;
        };
        disk = {};
        diskio = {
          device_tags = ["ID_FS_LABEL" "ID_SERIAL_SHORT"];
        };
        kernel = {};
        mem = {};
        processes = {};
        system = {};
        dns_query = {
          servers = ["8.8.8.8"];
          domains = ["google.com"];
        };
        internal = {
          collect_memstats = true;
        };
        interrupts = {
          cpu_as_tag = true;
        };
        kernel_vmstat = {};
        linux_sysctl_fs = {};
        net = {};
        netstat = {};
        sensors = {};
        smart = {};
        temp = {};
      };
    };
  };
}
