{ config, lib, ... }: let
  vm = config.my.vms;
  docker = config.my.docker;
in {
  virtualisation.docker.rootless = lib.mkIf docker {
    enable = true;
    setSocketVariable = true;
    # rootless docker seems to default to pointing at a non-existent
    # DNS server (possibly the one that exists in non-rootless
    # configs?). I'm fine defaulting to public DNS.
    daemon.settings.dns = [ "8.8.8.8" "8.8.4.4" ];
  };

  security.polkit.enable = lib.mkIf vm true;
  virtualisation.libvirtd = lib.mkIf vm {
    enable = true;
    qemu = {
      runAsRoot = false;
      swtpm.enable = true;
    };
  };
}
