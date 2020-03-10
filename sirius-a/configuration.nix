{
  imports = [
    ./lib/basics.nix
    ./lib/intel.nix
    ./lib/networking.nix
    ./lib/nixConfig.nix
    ./lib/noXlibs.nix
    ./lib/services.nix
    ./lib/shell.nix
    ./lib/users.nix
    ./lib/utilities.nix

    ./boot.nix
    ./dhcp.nix
    ./dns.nix
    ./firewall.nix
    ./hardware-configuration.nix
    ./networking.nix
    ./sysctls.nix
    ./vpn.nix
  ];

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?
}
