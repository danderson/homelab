{ lib, flakes, ... }:
{
  require = [
    ./hardened.nix
    ./lldp.nix
    ./microcode.nix
    ./networking.nix
    ./nix.nix
    ./shell.nix
    ./ssh.nix
    ./timezone.nix
    ./tmp.nix
    ./users.nix
    ./utilities.nix
  ];
}
