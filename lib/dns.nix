{ config, lib, ... }: {
  # NixOS containers try to use host resolv.conf by default. Prevent
  # it, since that doesn't work right in combo with resolved.
  networking.useHostResolvConf = false;
  services.resolved = {
    enable = true;
    dnssec = "false";
    llmnr = "false";
  };
  # In theory resolved can do mdns, but in practice two things break that:
  #  - CUPS still uses Avahi's dbus API to do mdns stuff, so if avahi isn't running
  #    you don't get printer/scanner discovery.
  #  - resolved permits per-interface mdns, and relies on the
  #    programming entity (networkd or networmanager usually) to
  #    enable mdns resolution on interfaces. NetworkManager supports
  #    enabling mdns resolution, but only through config file editing,
  #    none of the nice GUIs support it. So, more often than not,
  #    resolved gets told by networmanager to disable mdns resolution.
  #  - This also indirectly opens port 5353 in the NixOS firewall,
  #    which lets programs like airscan do their own mdns querying
  #    directly.
  services.avahi = lib.mkIf (config.my.mdns && !config.boot.isContainer) {
    enable = true;
    nssmdns = true;
  };
}
