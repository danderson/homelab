{
  services.ferm = {
    enable = true;
    config = ''
      @def &PORT_FORWARD($domain, $proto, $port, $dest, $dport) = {
        domain $domain table filter chain PORT-FORWARDS interface ppp0 proto $proto dport $dport daddr $dest ACCEPT;
        domain $domain table nat chain PORT-FORWARDS interface ppp0 proto $proto dport $port DNAT to "$dest:$dport";
      }
      
      @def $DEV_LAN = eno2;
      @def $DEV_MANAGEMENT = management;
      @def $DEV_IOT = iot;
      @def $DEV_WAN = ppp0;
      @def $DEV_VPN = vpn;
      @def $DEV_SERVERS = servers;
      
      domain ip {
        chain INPUT {
          mod state state (ESTABLISHED RELATED) ACCEPT;
          mod state state INVALID DROP;
          mod mark mark 1 DROP;
      
          # New connections only.
          interface lo ACCEPT;
          proto icmp ACCEPT;
          proto tcp dport 22 ACCEPT;
          proto udp dport 51820 ACCEPT; # Wireguard
      
          interface $DEV_LAN {
            proto (tcp udp) dport 53 ACCEPT;
            proto udp dport 67 ACCEPT;
          }
      
          interface $DEV_MANAGEMENT {
            proto (tcp udp) dport 53 ACCEPT;
            proto udp dport 67 ACCEPT;
          }
      
          interface $DEV_IOT {
            proto (tcp udp) dport 53 ACCEPT;
            proto udp dport 67 ACCEPT;
          }
      
          interface $DEV_SERVERS {
            proto (tcp udp) dport 53 ACCEPT;
            proto udp dport 67 ACCEPT;
          }

          interface $DEV_VPN {
            proto (tcp udp) dport 53 ACCEPT;
          }
        }
      
        chain OUTPUT policy ACCEPT;
      
        chain FORWARD {
          proto tcp tcp-flags (SYN RST) SYN TCPMSS clamp-mss-to-pmtu;
      
          mod state state (ESTABLISHED RELATED) ACCEPT;
          mod state state INVALID DROP;
      
          proto icmp ACCEPT;
      
          interface $DEV_LAN ACCEPT; # LAN to *
          interface $DEV_VPN ACCEPT;
          interface $DEV_MANAGEMENT outerface $DEV_WAN ACCEPT;
          interface $DEV_IOT outerface $DEV_WAN ACCEPT; # IoT to internet
          interface $DEV_SERVERS outerface $DEV_WAN ACCEPT;
          jump PORT-FORWARDS;
      
          policy DROP;
        }
      
        chain PORT-FORWARDS;
      
        table mangle {
          chain PREROUTING {
            # Mark SSH traffic coming from the internet to be dropped if
            # it's using the standard port.
            interface $DEV_WAN proto tcp dport 22 MARK set-mark 1;
          }
        }
        table nat {
          chain PREROUTING {
            interface $DEV_WAN proto tcp dport 22244 REDIRECT to-ports 22;
            jump PORT-FORWARDS;
          }
          chain POSTROUTING outerface $DEV_WAN MASQUERADE;
      
          chain PORT-FORWARDS;
        }
      }
      
      &PORT_FORWARD(ip, tcp, 32400, 192.168.17.13, 32400);

      domain ip6 {
        chain INPUT DROP;
        chain FORWARD DROP;
      }
    '';
  };
}
