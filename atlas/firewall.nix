{
  networking.firewall = {
    enable = true;
    allowPing = true;
    checkReversePath = "strict";
    allowedUDPPortRanges = [ { from = 60000; to = 61000; } ];
  };
}
