# homelab

These are the NixOS configurations for my home servers. I'm publishing them in the hopes that someone finds them useful, but they're not directly usable. For one they're custom to my machines and what I do with them. For another, some private files are encrypted.

Some signposts:
 - `lib/` contains shared NixOS configuration, as well as key-management.sh, which does secrets management outside of Nix.
 - `sirius-a/` is my router. DHCP, DNS, firewall, PPPd, etc.
 - `iris/` is my NAS. ZFS and some daemons on top of it.
 - `algol/` is a Linode VM I created for the [natprobe](https://github.com/danderson/natprobe) project. It's not terribly interesting and has a chance of going away soon.
 - `default.do` is the [redo](https://github.com/apenwarr/redo) configuration that lets me deploy configuration to my machines.
