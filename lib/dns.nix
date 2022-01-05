{config, lib, ...}:
{
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
