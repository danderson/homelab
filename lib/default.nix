{ lib, flakes, ... }:
{
  require = [
    ./boot.nix
    ./cpufreq.nix
    ./ddc.nix
    ./desktop.nix
    ./directory.nix
    ./dns.nix
    ./firewall.nix
    ./lldp.nix
    ./microcode.nix
    ./monitoring.nix
    ./networking.nix
    ./nix.nix
    ./options.nix
    ./shell.nix
    ./ssh.nix
    ./tailscale.nix
    ./time.nix
    ./timezone.nix
    ./tmp.nix
    ./users.nix
    ./utilities.nix
    ./zfs.nix
  ];
}
