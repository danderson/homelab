{config, lib, ...}:
{
  config = lib.mkIf (!config.boot.isContainer) {
    services.openssh = {
      enable = true;
      ports = lib.mkDefault [42222];
    };
  };
}