{ lib, flakes, ... }:

{
  # Settings imported from qemu-guest.nix, which flakes can't
  # reference yet.
  boot.initrd.availableKernelModules = [ "virtio_net" "virtio_pci" "virtio_mmio" "virtio_blk" "virtio_scsi" "9p" "9pnet_virtio" "ahci" "xhci_pci" "sr_mod" ];
  boot.initrd.kernelModules = [ "virtio_balloon" "virtio_console" "virtio_rng" ];
  boot.initrd.postDeviceCommands =
    ''
      # Set the system time from the hardware clock to work around a
      # bug in qemu-kvm > 1.5.2 (where the VM clock is initialised
      # to the *boot time* of the host).
      hwclock -s
    '';
  security.rngd.enable = lib.mkDefault false;

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/cef90582-98f9-41f7-aaf7-33822ee28bc3";
      fsType = "ext4";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/761d652c-ea04-4606-894a-56f3f013e75d"; }
    ];

}
