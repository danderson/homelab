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

    jlink = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };

    ulxs = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };

    gaming = lib.mkEnableOption "Videogames support";
    printing = lib.mkEnableOption "3D printing support";
  };
}
