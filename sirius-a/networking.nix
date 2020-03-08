{ config, ... }:
let
  hashes = import /etc/keys.nix;
in
{
  networking = {
    hostName = "sirius-a";
    hostId = "2eaa4dd6";
    nameservers = ["8.8.8.8"];

    vlans = {
    #   backup = {
    #     id = 2000;
    #     interface = "eno1";
    #   };

      management = {
        id = 1;
        interface = "eno2";
      };

      iot = {
        id = 10;
        interface = "eno2";
      };

      servers = {
        id = 200;
        interface = "eno2";
      };
    };

    interfaces = {
      eno1 = {
        useDHCP = false;
      };

      eno2 = {
        useDHCP = false;
        ipv4.addresses = [
          {
            address = "192.168.16.1";
            prefixLength = 24;
          }
          {
            address = "192.168.16.2";
            prefixLength = 24;
          }
        ];
      };

      management = {
        useDHCP = false;
        ipv4.addresses = [
          {
            address = "192.168.17.1";
            prefixLength = 26;
          }
          {
            address = "192.168.17.18";
            prefixLength = 26;
          }
        ];
      };
      
      iot = {
        useDHCP = false;
        ipv4.addresses = [
          {
            address = "192.168.18.1";
            prefixLength = 26;
          }
          {
            address = "192.168.18.2";
            prefixLength = 26;
          }
        ];
      };

      servers = {
        useDHCP = false;
        ipv4.addresses = [
          {
            address = "192.168.17.129";
            prefixLength = 26;
          }
          {
            address = "192.168.17.130";
            prefixLength = 26;
          }
        ];
      };
    };
  };

  environment.etc = {
    "ppp/peers/centurylink-user".source = "/etc/keys/centurylink-user";
    "ppp/chap-secrets".source = "/etc/keys/centurylink-creds";
  };
  services.pppd.enable = true;
  services.pppd.peers.centurylink = {
    config = ''
      plugin rp-pppoe.so eno1
      call centurylink-user
      noipdefault
      persist
      defaultroute
      #replacedefaultroute
      hide-password
      noauth
      lcp-echo-interval 5
      lcp-echo-failure 20
    '';
    autostart = true;
  };
  systemd.services.pppd-centurylink.restartTriggers = [
    hashes."centurylink-user"
    hashes."centurylink-creds"
  ];
}
