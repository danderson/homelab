{ ... }: {
  imports = [
    ../lib
    ./hardware-configuration.nix
  ];

  boot.cleanTmpDir = true;
  networking = {
    hostName = "mimosa";
    hostId = "021e5cfc";
    interfaces.enp6s18.useDHCP = true;
    nameservers = ["8.8.8.8" "8.8.4.4"];
  };

  services = {
    tailscale.enable = true;
    qemuGuest.enable = true;
  };
}
