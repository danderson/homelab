{
  networking = {
    hostName = "iris";
    hostId = "2a939c2d";
    defaultGateway = "192.168.17.1";
    nameservers = [ "192.168.17.1" ];

    interfaces.eno1.ipv4.addresses = [{
      address = "192.168.17.13";
      prefixLength = 26;
    }];
  };
}
