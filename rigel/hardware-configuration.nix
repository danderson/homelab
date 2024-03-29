# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/98e31363-57e5-4323-b337-422a0ae7d293";
      fsType = "btrfs";
    };

  boot.initrd.luks.devices."root".device = "/dev/disk/by-uuid/2b211f11-f146-49f8-b1b3-38c48c9170d1";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/2BA9-FF11";
      fsType = "vfat";
    };

  swapDevices = [ ];

  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
