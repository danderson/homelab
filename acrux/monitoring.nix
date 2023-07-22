{ flakes, ... } : {
  fileSystems."/var/lib/prometheus2" =
    { device = "/data/monitoring/prometheus";
      options = [ "bind" ];
    };
  fileSystems."/var/lib/grafana" =
    { device = "/data/monitoring/grafana";
      options = [ "bind" ];
    };

  services = {
    prometheus = {
      enable = true;
      scrapeConfigs = let
        hosts = [
          "acrux"
          "gacrux"
          "iris"
          "betelgeuse"
          "vega"
        ];
        zreplHosts = [
          "acrux"
          "gacrux"
          "iris"
        ];
      in [
        {
          job_name = "node-exporter";
          static_configs = [{
            targets = map (h: "${h}:9100") hosts;
          }];
        }
        {
          job_name = "zrepl";
          static_configs = [{
            targets = map (h: "${h}:9811") zreplHosts;
          }];
        }
      ];
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
  };
}
