{config, lib, ...}:
{
  options = {
    my.mdns = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = {
    networking.useHostResolvConf = false;
    services.resolved = {
      enable = true;
      dnssec = "false";
      llmnr = lib.boolToString config.my.mdns;
    };
    services.avahi = {
      enable = config.my.mdns;
      nssmdns = true;
    };
  };
}
