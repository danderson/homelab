{ config, lib, ... }: {
  options.my = {
    cpu-vendor = lib.mkOption {
      type = lib.types.enum ["none" "intel" "amd"];
      default = "none";
    };

    ddc = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };

    desktop = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };

    mdns = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };

    zfs = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };

    directory = lib.mkOption {
      type = lib.types.attrsOf lib.types.int;
      default = {};
    };

    tailscale = lib.mkOption {
      type = lib.types.bool;
      default = !config.boot.isContainer;
    };

    livemon = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };
}
