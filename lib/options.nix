{ config, lib, ... }: {
  options.my = {
    cpu-vendor = lib.mkOption {
      type = lib.types.enum ["none" "intel" "amd"];
      default = "none";
    };

    kernel = lib.mkOption {
      type = lib.types.enum ["lts" "latest"];
      default = "lts";
    };

    bootloader = lib.mkOption {
      type = lib.types.enum ["systemd-boot" "grub"];
      default = "systemd-boot";
    };

    gpu = lib.mkOption {
      type = lib.types.enum ["none" "intel" "amd"];
      default = "none";
    };

    directory = lib.mkOption {
      type = lib.types.attrsOf lib.types.int;
      default = {};
    };

    tailscale = lib.mkOption {
      type = lib.types.enum ["off" "stable" "unstable"];
      default = if config.boot.isContainer then "off" else "stable";
    };

    fwupd = lib.mkOption {
      type = lib.types.enum [true false "framework"];
      default = false;
    };

    ddc = lib.mkEnableOption "Support configuring monitors with DDC";
    desktop = lib.mkEnableOption "Configure desktop/laptop GUI and services";
    zfs = lib.mkEnableOption "ZFS support";
    livemon = lib.mkEnableOption "Run Livemon on the system";
    jlink = lib.mkEnableOption "J-Link programmer hardware support";
    ulxs = lib.mkEnableOption "ULXS FPGA hardware support";
    gaming = lib.mkEnableOption "Videogames support";
    printing = lib.mkEnableOption "3D printing support";
    vms = lib.mkEnableOption "VM support (libvirtd)";
    docker = lib.mkEnableOption "Rootless docker";
    mdns = lib.mkEnableOption "mdns resolution";

    extraHomePkgs = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
    };
  };
}
