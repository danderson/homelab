{config, lib, ...}: {
  config = lib.mkIf (!config.boot.isContainer) {
    services.lldpd.enable = true;
  };
}
