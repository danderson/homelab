{
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
          "mimosa"
          "izar"
          "iris"
          "vega"
        ];
        nodeScrape = host: {
          job_name = "${host}_node";
          static_configs = [{
            targets = ["${host}:9100"];
          }];
        };
      in
        map nodeScrape hosts;
    };
    grafana = {
      enable = true;
      addr = "0.0.0.0";
      port = 9000;
      auth.anonymous = {
        enable = true;
        org_role = "Admin";
      };
    };
  };
}
