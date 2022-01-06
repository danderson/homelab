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
}
