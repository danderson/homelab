{ pkgs, ... }:
let
  repo = "/home/dave/tail/corp";
  build = "${repo}/out/native/oss/cmd";
in
{
  my.disable-system-tailscale = true;
  systemd.services.tailscaled = {
    after = [ "network-pre.target" ];
    wants = [ "network-pre.target" ];
    wantedBy = [ "multi-user.target" ];

    unitConfig = {
      StartLimitIntervalSec = 0;
      StartLimitBurst = 0;
    };

    path = [ pkgs.openresolv pkgs.iptables pkgs.iproute ];

    serviceConfig = {
      ExecStartPre = "${build}/tailscaled/tailscaled --cleanup";
      ExecStart = "${build}/tailscaled/tailscaled --port 41641";
      ExecStopPost = "${build}/tailscaled/tailscaled --cleanup";
      EnvironmentFile = "-/home/dave/tail/env";

      RuntimeDirectory = "tailscale";
      RuntimeDirectoryMode = 755;

      StateDirectory = "tailscale";
      StateDirectoryMode = 750;

      CacheDirectory = "tailscale";
      CacheDirectoryMode = 750;

      Restart = "on-failure";
    };
  };
  home-manager.users.dave.home.sessionPath = ["${build}/tailscale"];
}
