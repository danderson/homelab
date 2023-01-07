{ config, pkgs, lib, ... }: let
  hasFwupd = config.services.fwupd.enable;
  isFramework = config.my.fwupd == "framework";
  # Framework ships updates through LVFS, but only the testing track
  # because they require some manual futzing with config due to an
  # incompatibility between LVFS and framework's BIOS vendor.
  frameworkCapsuleConfig = lib.mkForce {
    source = pkgs.writeText "uefi_capsule.conf" ''
      [uefi_capsule]
      OverrideESPMountPoint=${config.boot.loader.efi.efiSysMountPoint}
      DisableCapsuleUpdateOnDisk=true
    '';
  };
in {
  services.udisks2.enable = lib.mkIf hasFwupd true;
  services.fwupd.enable = lib.mkDefault (config.my.fwupd != false);
  services.fwupd.extraRemotes = lib.mkIf isFramework ["lvfs-testing"];
  environment.etc."fwupd.uefi_capsule.conf" = lib.mkIf isFramework frameworkCapsuleConfig;
}
