{  
  networking.wireguard = {
    enable = true;
    interfaces.vpn = {
      ips = [ "192.168.17.65/26" ];
      listenPort = 51820;
      privateKeyFile = "/etc/keys/wireguard-privatekey";
      peers = [];
    };
  };
}
