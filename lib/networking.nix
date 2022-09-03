{
  networking = {
    useDHCP = false;
    domain = "universe.tf";
    iproute2.enable = true; # Copy iproute2 config files to /etc
    tempAddresses = "disabled";
  };
  boot.kernel.sysctl = {
    # Generate stable, but per-boot random SLAAC addresses, don't use EUI64.
    "net.ipv6.conf.all.addr_gen_mode" = 3;
  };
  # If NetworkManager is in use, NetworkManager-wait-online ends up
  # stuck and delays rebuilds for 30s.
  # https://github.com/NixOS/nixpkgs/issues/180175
  systemd.services.NetworkManager-wait-online.enable = false;
}
