{ lib, flakes, ... }:
{
  imports = [ flakes.nixos.nixosModules.notDetected ];

  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "ehci_pci" "mpt3sas" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/0058f49b-74cc-4263-96b0-4297d523ad03";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/5949-0094";
      fsType = "vfat";
    };

  swapDevices = [ ];

  nix.maxJobs = lib.mkDefault 28;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
