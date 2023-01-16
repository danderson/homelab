{ lib, pkgs, ... }: {
  options.my = lib.mkOption {
    type = lib.types.anything;
  };
}
