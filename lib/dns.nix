{
  # NixOS containers try to use host resolv.conf by default. Prevent
  # it, since that doesn't work right in combo with resolved.
  networking.useHostResolvConf = false;
  services.resolved = {
    enable = true;
    dnssec = "false";
    llmnr = "false";
  };
}
