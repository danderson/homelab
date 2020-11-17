{config, lib, ...}:
{
  config = lib.mkIf (!config.boot.isContainer) {
    services.openssh.enable = true;
  };
}
