{
  services.dhcpd4 = {
    enable = true;
    interfaces = [];
    extraConfig = ''
      default-lease-time 1800;
      max-lease-time 7200;
      option ntp-servers 216.239.35.0,216.239.35.4,216.239.35.8,216.239.35.12; # time{1..4}.google.com
      option domain-name "universe.tf";
      ddns-update-style none;

      subnet 192.168.16.0 netmask 255.255.255.0 {
        range 192.168.16.40 192.168.16.191;
        option subnet-mask 255.255.255.0;
        option routers 192.168.16.1;
        option domain-name-servers 192.168.16.1;
      }

      subnet 192.168.17.0 netmask 255.255.255.192 {
        range 192.168.17.20 192.168.17.59;
        option subnet-mask 255.255.255.192;
        option routers 192.168.17.1;
        option domain-name-servers 192.168.17.1;
      }

      subnet 192.168.17.128 netmask 255.255.255.192 {
        range 192.168.17.140 192.168.17.180;
        option subnet-mask 255.255.255.192;
        option routers 192.168.17.129;
        option domain-name-servers 192.168.17.129;
      }

      subnet 192.168.18.0 netmask 255.255.255.192 {
        range 192.168.18.10 192.168.18.50;
        option subnet-mask 255.255.255.192;
        option routers 192.168.18.1;
        option domain-name-servers 192.168.18.1;
      }
    '';

    machines = [
      # LAN
      
      
      # Management
      { ipAddress = "192.168.17.2";  ethernetAddress = "f0:9f:c2:1f:b7:c2"; hostName = "unifi"; }
      { ipAddress = "192.168.17.3";  ethernetAddress = "ac:1f:6b:64:9b:2b"; hostName = "prod-01-ipmi"; }
      { ipAddress = "192.168.17.4";  ethernetAddress = "ac:1f:6b:64:9b:42"; hostName = "prod-02-ipmi"; }
      { ipAddress = "192.168.17.5";  ethernetAddress = "ac:1f:6b:64:9b:40"; hostName = "prod-03-ipmi"; }
      { ipAddress = "192.168.17.6";  ethernetAddress = "18:03:73:f7:84:45"; hostName = "nemesis-ipmi"; }
      { ipAddress = "192.168.17.7";  ethernetAddress = "00:c0:b7:76:44:b8"; hostName = "pdu"; }
      { ipAddress = "192.168.17.8";  ethernetAddress = "d4:ae:52:c6:c1:85"; hostName = "router-ipmi"; }
      { ipAddress = "192.168.17.9";  ethernetAddress = "18:03:73:f7:84:3d"; hostName = "nemesis"; }
      { ipAddress = "192.168.17.10"; ethernetAddress = "f0:9f:c2:63:43:b8"; hostName = "switch-rack"; }
      { ipAddress = "192.168.17.11"; ethernetAddress = "f0:9f:c2:23:2b:47"; hostName = "ap-rack"; }
      { ipAddress = "192.168.17.12"; ethernetAddress = "0c:c4:7a:46:a2:49"; hostName = "iris-ipmi"; }
      { ipAddress = "192.168.17.13"; ethernetAddress = "0c:c4:7a:46:a3:ce"; hostName = "iris"; }
      { ipAddress = "192.168.17.14"; ethernetAddress = "ac:1f:6b:64:a3:0a"; hostName = "prod-01"; }
      { ipAddress = "192.168.17.15"; ethernetAddress = "ac:1f:6b:64:a3:94"; hostName = "prod-02"; }
      { ipAddress = "192.168.17.16"; ethernetAddress = "ac:1f:6b:64:a3:88"; hostName = "prod-03"; }

      # Servers
    ];
  };
}
