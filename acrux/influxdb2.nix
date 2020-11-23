{ config, lib, pkgs, flakes, ... }:

with lib;

let
  defaultBoltPath = "/var/lib/influxdb2/influxd.bolt";
  defaultEnginePath = "/var/lib/influxdb2/engine";

  toml = pkgs.formats.toml {};
  cfg = config.services.influxdb2;
  configFile = toml.generate "config.toml" cfg.config;
  # When using the default paths, create the directories
  # automatically. But if they're changed from the defaults, it's the
  # administrator's problem to make the directories exist.
  boltDir = if cfg.config.bolt-path == defaultBoltPath
            then ["d ${dirOf defaultBoltPath} 0770 ${cfg.user} ${cfg.group}"]
            else [];
  engineDir = if cfg.config.engine-path == defaultEnginePath
              then ["d ${defaultEnginePath} 0770 ${cfg.user} ${cfg.group}"]
              else [];
in
{
  meta.maintainers = with maintainers; [ danderson ];

  options = {
    services.influxdb2 = {
      enable = mkEnableOption "InfluxDB";

      user = mkOption {
        default = "influxdb";
        description = "User account under which influxdb runs";
        type = types.str;
      };

      group = mkOption {
        default = "influxdb";
        description = "Group under which influxdb runs";
        type = types.str;
      };

      dataDir = mkOption {
        default = "/var/db/influxdb2";
        description = "Data directory for influxd data files.";
        type = types.path;
      };

      config = mkOption {
        default = {
          bolt-path = defaultBoltPath;
          engine-path = defaultEnginePath;
        };
        description = "Configuration options for influxdb";
        type = toml.type;
      };

      openFirewall = mkOption {
        type = types.bool;
        default = true;
        description = "Open ports in the firewall for InfluxDB.";
      };
    };
  };

  config = mkIf config.services.influxdb2.enable {
    systemd.tmpfiles.rules = boltDir ++ engineDir;

    systemd.services.influxdb2 = {
      description = "InfluxDB Server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      environment = {
        INFLUXD_CONFIG_PATH = configFile;
      };
      serviceConfig = {
        ExecStart = "${flakes.my-fork.legacyPackages.x86_64-linux.influxdb2}/bin/influxd";
        StateDirectory = cfg.dataDir;
        StateDirectoryMode = 0770;
        User = cfg.user;
        Group = cfg.group;
      };
    };

    users.users = optionalAttrs (cfg.user == "influxdb") {
      influxdb = {
        uid = config.ids.uids.influxdb;
        description = "Influxdb daemon user";
      };
    };

    users.groups = optionalAttrs (cfg.group == "influxdb") {
      influxdb.gid = config.ids.gids.influxdb;
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ 8686 ];
    };
  };
}
