{
  networking = {
    useDHCP = false;
    domain = "universe.tf";
    iproute2.enable = true; # Copy iproute2 config files to /etc
  };
}
