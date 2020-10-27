{ lib, ... }:
{
  require = [
    ./microcode.nix
    ./networking.nix
    ./tmp.nix
    ./timezone.nix
    ./nix.nix
    ./ssh.nix
    ./lldp.nix
    ./shell.nix
    ./users.nix
    ./utilities.nix
  ];
}
