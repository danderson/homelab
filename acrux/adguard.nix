{
  services.adguardhome.enable = true;
  networking.firewall.extraCommands = ''
    ip46tables -t nat -A PREROUTING -p udp --dport 53 -j DNAT --to :54
    ip46tables -t nat -A PREROUTING -p tcp --dport 53 -j DNAT --to :54
  '';
  networking.firewall.extraStopCommands = ''
    ip46tables -t nat -D PREROUTING -p udp --dport 53 -j DNAT --to :54 2>/dev/null || true
    ip46tables -t nat -D PREROUTING -p tcp --dport 53 -j DNAT --to :54 2>/dev/null || true
  '';
}
