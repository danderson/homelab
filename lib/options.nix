{ lib, ... }: {
  options.my = {
    cpu-vendor = lib.mkOption {
      type = lib.types.enum ["none" "intel" "amd"];
      default = "none";
    };

    desktop = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };

    mdns = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };
}
