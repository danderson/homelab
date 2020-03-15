{
  services.coredns = {
    enable = true;
    config = ''
      .:53 {
        loadbalance round_robin

        cache

        hosts /dev/null {
          192.168.16.1 router.universe.tf
          192.168.17.1 router-mgmt.universe.tf
          192.168.17.129 router-servers.universe.tf

          192.168.17.2 unifi.universe.tf
          192.168.17.3 prod-01-ipmi.universe.tf
          192.168.17.4 prod-02-ipmi.universe.tf
          192.168.17.5 prod-03-ipmi.universe.tf
          192.168.17.6 nemesis-ipmi.universe.tf
          192.168.17.7 pdu.universe.tf
          192.168.17.8 router-ipmi.universe.tf
          192.168.17.9 nemesis.universe.tf
          192.168.17.10 switch-rack.universe.tf
          192.168.17.11 ap-rack.universe.tf
          192.168.17.12 iris-ipmi.universe.tf
          192.168.17.13 iris.universe.tf
          192.168.17.14 prod-01.universe.tf
          192.168.17.15 prod-02.universe.tf
          192.168.17.16 prod-03.universe.tf
          192.168.17.17 sirius-b.universe.tf
          192.168.17.18 sirius-a.universe.tf

          fallthrough
        }

        log
        forward . tls://8.8.8.8 tls://8.8.4.4 {
          tls_servername dns.google
          health_check 5s
        }
      }
    '';
  };
}
