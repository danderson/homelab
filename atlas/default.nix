{ lib, pkgs, ... }:
{
  imports = [
    ../lib
  ];

  my.cpu-vendor = "intel";
  my.harden = true;
  
  # hardware-configuration, but it's a little unusual because of the
  # VM setting. So it's not in its own file.
  fileSystems."/" = { device = "/dev/vda1"; fsType = "ext4"; };
  boot = {
    loader.grub.device = "/dev/vda";
    initrd.availableKernelModules = [ "virtio_net" "virtio_pci" "virtio_mmio" "virtio_blk" "virtio_scsi" "9p" "9pnet_virtio" ];
    initrd.kernelModules = [ "virtio_balloon" "virtio_console" "virtio_rng" ];
    initrd.postDeviceCommands = ''
      # Set the system time from the hardware clock to work around a
      # bug in qemu-kvm > 1.5.2 (where the VM clock is initialised
      # to the *boot time* of the host).
      hwclock -s
    '';
  };
  security.allowUserNamespaces = true;
  security.rngd.enable = lib.mkDefault false;

  environment.systemPackages = [pkgs.irssi];

  networking = {
    hostName = "atlas";
    nameservers = [
      "67.207.67.2"
      "67.207.67.3"
    ];
    defaultGateway = "157.245.176.1";
    defaultGateway6 = "2604:a880:2:d1::1";
    usePredictableInterfaceNames = lib.mkForce true;
    interfaces = {
      eth0 = {
        ipv4.addresses = [
          { address="157.245.188.241"; prefixLength=20; }
          { address="10.46.0.5"; prefixLength=16; }
        ];
        ipv6.addresses = [
          { address="2604:a880:2:d1::132:1001"; prefixLength=64; }
          { address="fe80::a4c0:27ff:fed3:ea17"; prefixLength=64; }
        ];
        ipv4.routes = [
          { address = "157.245.176.1"; prefixLength = 32; }
        ];
        ipv6.routes = [
          { address = "2604:a880:2:d1::1"; prefixLength = 32; }
        ];
      };
    };
  };
  services.udev.extraRules = ''
    ATTR{address}=="a6:c0:27:d3:ea:17", NAME="eth0"
  '';
  
  networking.firewall = {
    enable = true;
    allowPing = true;
    checkReversePath = "strict";
    allowedTCPPorts = [ 80 443 ];
    allowedUDPPortRanges = [ { from = 60000; to = 61000; } ];
  };
  
  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?
}
