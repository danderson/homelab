{ pkgs, ... }:
let repo = "/home/dave/tail/corp/out/native/oss/cmd"; in
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

    environment = {
      #TS_DEBUG_CONTROL_FLAGS = "v6-overlay";
    };
    serviceConfig = {
      ExecStart = "${repo}/tailscaled/tailscaled --port 41641";

      RuntimeDirectory = "tailscale";
      RuntimeDirectoryMode = 755;

      StateDirectory = "tailscale";
      StateDirectoryMode = 750;

      CacheDirectory = "tailscale";
      CacheDirectoryMode = 750;

      Restart = "on-failure";
    };
  };
  home-manager.users.dave.home.sessionPath = ["${repo}/tailscale"];
}
