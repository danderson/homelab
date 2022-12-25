{ config, lib, pkgs, ... }: let
  portString = name: port: "${builtins.toString port}:${name}";
  directoryStr = lib.mapAttrsToList portString config.my.directory;
  mapStr = lib.concatStringsSep "," directoryStr;
in {
  config = lib.mkIf (lib.length (lib.attrNames config.my.directory) != 0) {
    systemd.services.directory = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = ''${pkgs.my.directory}/bin/directory -map="${mapStr}"'';
      };
    };
  };
}
