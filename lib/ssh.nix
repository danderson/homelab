{ config, lib, ... }: lib.mkIf (!config.boot.isContainer) {
  services.openssh.enable = true;
}
