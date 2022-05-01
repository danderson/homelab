{ lib, ... }: {
  networking.firewall = {
    enable = true;
    allowPing = true;
    checkReversePath = lib.mkDefault "loose";
    trustedInterfaces = ["tailscale0"];
    logRefusedConnections = lib.mkDefault false;
  };
}
