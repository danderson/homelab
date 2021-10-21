{ pkgs, ... }:
let
  users = import ./users.nix;
in
{
  imports = [
    ../lib

    ./private.nix
    ./hardware-configuration.nix
  ];

  my.cpu-vendor = "intel";
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_4_19;
    supportedFilesystems = ["zfs"];
    zfs.requestEncryptionCredentials = false;
    kernelModules = ["sg"];
  };

  networking = {
    hostName = "iris";
    hostId = "2a939c2d";
    defaultGateway = "192.168.4.1";
    nameservers = ["192.168.4.2"];

    interfaces.eno1.ipv4.addresses = [{
      address = "192.168.4.3";
      prefixLength = 24;
    }];
    interfaces.enp6s0f1.ipv4.addresses = [{
      address = "192.168.5.3";
      prefixLength = 24;
    }];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    systemPackages = with pkgs; [
      hdparm
      lsscsi
    ];
  };

  services = {
    zfs = {
      autoScrub.enable = true;
      autoSnapshot = {
        enable = false;
        frequent = 4;
        hourly = 2;
        daily = 7;
        monthly = 12;
      };
    };
  };
  systemd.services.clean-snapshots = let
    cleaner = pkgs.writeScript "clean-snapshots.rb" ''
#!${pkgs.ruby}/bin/ruby -I${pkgs.zfstools}/lib

require 'zfstools'
require 'zfstools/dataset'

interval=ARGV[0]
keep=ARGV[1].to_i
pool=nil

datasets = {
  'included' => Zfs::Dataset.list(nil, []),
  'excluded' => [],
}

cleanup_expired_snapshots(pool, datasets, interval, keep, true)
    '';
  in {
    script = ''
      ${cleaner} frequent 4
      ${cleaner} hourly 2
      ${cleaner} daily 7
      ${cleaner} monthly 12
    '';
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?
}
