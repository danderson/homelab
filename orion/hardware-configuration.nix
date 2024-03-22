# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/668532c5-e9e9-47b5-9ca4-03eb9a5d68ad";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."luks-297c2419-f490-4e90-a653-a109bebf0de4".device = "/dev/disk/by-uuid/297c2419-f490-4e90-a653-a109bebf0de4";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/925C-5D6F";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/9388e57f-0ccf-4a10-ba8f-da928220fd2c"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp4s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}