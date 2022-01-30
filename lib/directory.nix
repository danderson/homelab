{ config, lib, pkgs, ... }: let
  directory = pkgs.buildGoModule {
    name = "directory";
    src = ./progs;
    subPackages = [ "directory" ];
    vendorSha256 = "sha256-pQpattmS9VmO3ZIQUFn66az8GSmB4IvYhTTCFn6SUmo=";
  };

  services = lib.concatStringsSep "," (lib.attrValues (lib.mapAttrs (name: port: "${builtins.toString port}:${name}") config.my.directory));
in {
  config = lib.mkIf (lib.length (lib.attrNames config.my.directory) != 0) {
    systemd.services.directory = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = ''${directory}/bin/directory -map="${services}"'';
      };
    };
  };
}
