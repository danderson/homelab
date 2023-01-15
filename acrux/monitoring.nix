{ flakes, ... } : {
  fileSystems."/var/lib/prometheus2" =
    { device = "/data/monitoring/prometheus";
      options = [ "bind" ];
    };
  fileSystems."/var/lib/grafana" =
    { device = "/data/monitoring/grafana";
      options = [ "bind" ];
    };
  fileSystems."/var/lib/influxdb2" =
    { device = "/data/monitoring/influxdb";
      options = [ "bind" ];
    };

  services = {
    prometheus = {
      enable = true;
      scrapeConfigs = let
        hosts = [
          "acrux"
          "gacrux"
          "mimosa"
          "izar"
          "iris"
          "vega"
        ];
        hostScrape = host: type: port: {
          job_name = "${host}_${type}";
          static_configs = [{
            targets = ["${host}:${builtins.toString port}"];
            labels.host = host;
          }];
        };
        nodeScrape = host: hostScrape host "node" 9100;
        nodeConfigs = map nodeScrape hosts;
        zreplScrape = host: hostScrape host "zrepl" 9811;
        zreplConfigs = map zreplScrape ["iris" "acrux" "gacrux"];
        livemonScrape = host: hostScrape host "livemon" 9843;
        livemonConfigs = map livemonScrape ["acrux"];
      in
        nodeConfigs ++ zreplConfigs ++ livemonConfigs;
    };
    grafana = {
      enable = true;
      settings = {
        server = {
          http_port = 9000;
          http_addr = "0.0.0.0";
        };
        "auth.anonymous" = {
          enable = true;
          org_role = "Admin";
          org_name = "Main Org.";
        };
      };
    };

    influxdb2 = {
      enable = true;
      package = flakes.nixos-dave.legacyPackages.x86_64-linux.influxdb2-server;
    };
  };
}
