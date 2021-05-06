{config, lib, ...}:
{
  options = {
    my.mdns = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = {
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
