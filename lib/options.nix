{ config, lib, ... }: {
  options.my = {
    cpu-vendor = lib.mkOption {
      type = lib.types.enum ["none" "intel" "amd"];
      default = "none";
    };

    bootloader = lib.mkOption {
      type = lib.types.enum ["systemd-boot" "grub"];
      default = "systemd-boot";
    };

    directory = lib.mkOption {
      type = lib.types.attrsOf lib.types.int;
      default = {};
    };

    tailscale = lib.mkOption {
      type = lib.types.bool;
      default = !config.boot.isContainer;
    };

    ddc = lib.mkEnableOption "Support configuring monitors with DDC";
    desktop = lib.mkEnableOption "Configure desktop/laptop GUI and services";
    mdns = lib.mkEnableOption "Use local dynamic DNS (mdns, llmnr)";
    zfs = lib.mkEnableOption "ZFS support";
    livemon = lib.mkEnableOption "Run Livemon on the system";
    jlink = lib.mkEnableOption "J-Link programmer hardware support";
    ulxs = lib.mkEnableOption "ULXS FPGA hardware support";
    gaming = lib.mkEnableOption "Videogames support";
    printing = lib.mkEnableOption "3D printing support";

    extraHomePkgs = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
    };
  };
}
