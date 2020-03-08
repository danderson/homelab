{
  networking.firewall = {
    enable = true;
    allowPing = true;
    checkReversePath = "strict";
    allowedUDPPorts = [
      # One more random port in the IANA "Dynamic Ports"
	    # range.
	    60000

	    # QUIC
	    80 443

	    # VPN protocols.

	    # IKE (IPSec)
	    500
	    # L2TP over UDP
	    1701
	    # IPSec ESP over UDP
	    4500
	    # PPTP
	    1723
	    # OpenVPN
	    1194
	    # Wireguard
	    51820

	    # VOIP protocols.

	    # STUN
	    3478
	    # SIP cleartext
	    5060
	    # SIP TLS
	    5061
    ];
  };
}
