{ lib, pkgs, ... }: {
  options.my = {
    wmExtraCommands = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };

    layout = lib.mkOption {
      type = (pkgs.formats.json {}).type;
      default = {};
    };

    gui-programs = lib.mkEnableOption "GUI programs";
    gaming = lib.mkEnableOption "Gaming stuff";
    printing = lib.mkEnableOption "3D printing tools";
    extraPkgs = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
    };
  };
}
