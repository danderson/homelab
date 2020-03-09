{ lib, ... }: {
  networking = {
    hostName = "atlas";
    nameservers = [
      "67.207.67.2"
      "67.207.67.3"
    ];
    defaultGateway = "157.245.176.1";
    defaultGateway6 = "2604:a880:2:d1::1";
    usePredictableInterfaceNames = lib.mkForce true;
    interfaces = {
      eth0 = {
        ipv4.addresses = [
          { address="157.245.188.241"; prefixLength=20; }
{ address="10.46.0.5"; prefixLength=16; }
        ];
        ipv6.addresses = [
          { address="2604:a880:2:d1::132:1001"; prefixLength=64; }
{ address="fe80::a4c0:27ff:fed3:ea17"; prefixLength=64; }
        ];
        ipv4.routes = [ { address = "157.245.176.1"; prefixLength = 32; } ];
        ipv6.routes = [ { address = "2604:a880:2:d1::1"; prefixLength = 32; } ];
      };
      
    };
  };
  services.udev.extraRules = ''
    ATTR{address}=="a6:c0:27:d3:ea:17", NAME="eth0"
  '';
}
