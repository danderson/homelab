{
  boot.kernel.sysctl = {
    "net.ipv6.conf.all.use_tempaddr" = 0;
    "net.ipv6.conf.default.use_tempaddr" = 0;
    "net.ipv6.conf.eth0.use_tempaddr" = 0;
    "net.ipv6.conf.all.autoconf" = 0;
    "net.ipv6.conf.default.autoconf" = 0;
    "net.ipv6.conf.eth0.autoconf" = 0;
    "net.ipv6.conf.all.accept_ra" = 0;
    "net.ipv6.conf.default.accept_ra" = 0;
    "net.ipv6.conf.eth0.accept_ra" = 0;
  };
  
  networking = {
    # Linode doesn't like predictable interface names. There's just
    # one ethernet interface, and it seems to move from slot to slot
    # occasionally.
    usePredictableInterfaceNames = false;
    useDHCP = false;
    hostName = "algol";
    hostId = "e16fb8e9";
    defaultGateway = "74.207.247.1";
    #defaultGateway6 = "fe80::1";
    nameservers = ["173.230.145.5"];

    interfaces.eth0 = {
      preferTempAddress = false;
      ipv4.addresses = [
        {
          address = "74.207.247.216";
          prefixLength = 24;
        }
        {
          address = "96.126.103.66";
          prefixLength = 24;
        }
      ];

      ipv6.addresses = [
        {
          address = "2600:3c01::f03c:92ff:febb:26fb";
          prefixLength = 128;
        }
        {
          address = "2600:3c01:e000:0371::1";
          prefixLength = 128;
        }
      ];

      ipv6.routes = [
        {
          address = "::";
          prefixLength = 0;
          via = "fe80::1";
        }
      ];
    };
  };
}
