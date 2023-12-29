{ config, pkgs, lib, ... }:
with lib; let
  cfg = config.my.automounts;
  automountSecret = "/etc/automount.creds";
in {
  options = {
    my.automounts = {
      enable = mkEnableOption (mdDoc "Enable my automounts");
      mounts = mkOption {
        type = types.attrsOf types.str;
        default = {};
      };
      secret = mkOption {
        type = types.path;
      };
    };
  };

  config = mkIf cfg.enable {
    age.secrets.automount = {
      file = cfg.secret;
      path = automountSecret;
      owner = "root";
      group = "root";
    };

    environment.systemPackages = [ pkgs.cifs-utils ];

    fileSystems = let
      mnt = dst: src: {
        device = "${src}";
        fsType = "smb3";
        options = [
          "_netdev"
          "x-systemd.automount"
          "noauto"
          "x-systemd.idle-timeout=60"
          "x-systemd.mount-timeout=5s"
          "credentials=/etc/samba.creds"
          "uid=1000"
          "gid=100"
          "ro"
          "dir_mode=0555"
          "file_mode=0444"
        ];
      };
    in attrsets.mapAttrs mnt cfg.mounts;
  };
}
