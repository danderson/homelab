{ lib, flakes, ... }:
{
  require = [
    ./desktop.nix
    ./dns.nix
    ./firewall.nix
    ./hardened.nix
    ./lldp.nix
    ./microcode.nix
    ./networking.nix
    ./nix.nix
    ./shell.nix
    ./ssh.nix
    ./tailscale.nix
    ./telegraf.nix
    ./time.nix
    ./timezone.nix
    ./tmp.nix
    ./users.nix
    ./utilities.nix
  ];
}
