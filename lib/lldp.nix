{ config, lib, ... }: lib.mkIf (!config.boot.isContainer) {
  services.lldpd.enable = true;
}
