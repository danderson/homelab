{ config, pkgs, lib, flakes, ... }: let
  cfg = config.my.archive;
  archivers = lib.filterAttrs (k: v: v > 0) cfg;
  totalArchivers = builtins.foldl' (x: y: x+y) 0 (builtins.attrValues archivers);
  wantArchive = totalArchivers > 0;
  betterName = name: if (name == "shortener") then "terroroftinytown-client" else name;
  mkArchiver = name: concurrency: lib.nameValuePair "archive-${name}" {
    image = "atdr.meo.ws/archiveteam/${betterName name}-grab";
    cmd = ["--concurrent" "${builtins.toString concurrency}" "dave"];
    extraOptions = ["--label=com.centurylinklabs.watchtower.enable=true"];
  };
  archiverConfigs = lib.mapAttrs' mkArchiver archivers;
  watchtower = {
      archive-watchtower = {
        volumes = ["/var/run/docker.sock:/var/run/docker.sock"];
        image = "containrrr/watchtower";
        cmd = ["--label-enable" "--cleanup" "--interval" "3600"];
      };
  };
in lib.mkIf wantArchive {
  virtualisation.oci-containers = {
    backend = "docker";
    containers = watchtower // archiverConfigs;
  };
}
