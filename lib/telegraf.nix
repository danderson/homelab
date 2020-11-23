{ config, lib, ... }: {
  services.telegraf = lib.mkIf (!config.boot.isContainer) {
    enable = true;
  };
}
