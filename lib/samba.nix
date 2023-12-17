{lib, config, ...}: let
  wantSamba = (builtins.length (builtins.attrNames config.my.sambaShares)) > 0;
in lib.mkIf wantSamba {
  services.samba = {
    enable = true;
    openFirewall = true;
    securityType = "user";
    extraConfig = ''
      use sendfile = yes

      vfs objects = fruit streams_xattr
      fruit:aapl = yes
      fruit:model = MacSamba
      fruit:resource = xattr
      fruit:delete_empty_adfiles = yes
    '';
    shares = config.my.sambaShares;
  };
  services.samba-wsdd = {
    enable = true;
    # TODO: 23.11 supports openFirewall, remove the manual firewall
    # thing below.
  };
  networking.firewall = {
    allowedTCPPorts = [ 5357 ];
    allowedUDPPorts = [ 3702 ];
  };
}
