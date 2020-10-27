{ pkgs, ... }:
let
  users = import ./users.nix;
in
{
  imports = [
    ../lib

    ./private.nix
    ./hardware-configuration.nix
    ./telegraf.nix
    ./tailscale.nix
  ];

  my.cpu-vendor = "intel";
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_4_19;
    supportedFilesystems = ["zfs"];
    kernelModules = ["sg"];
  };

  networking = {
    hostName = "iris";
    hostId = "2a939c2d";
    #defaultGateway = "192.168.17.1";
    nameservers = [ "8.8.8.8" ];

    interfaces.eno1.ipv4.addresses = [{
      address = "192.168.17.13";
      prefixLength = 26;
    }];
    interfaces.wlp0s20u3.useDHCP = true;

    wireless = {
      enable = true;
    };
  };
  
  powerManagement.cpuFreqGovernor = "performance";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    systemPackages = with pkgs; [
      hdparm
      lsscsi
    ];
  };

  programs = {
    iotop.enable = true;
    iftop.enable = true;
    mosh.enable = true;
    mtr.enable = true;
    zsh.enable = true;
  };

  services = {
    zfs = {
      autoScrub.enable = true;
      autoSnapshot = {
        enable = true;
        frequent = 4;
        hourly = 2;
        daily = 7;
        monthly = 12;
      };
    };
    openssh.ports = [22];
    fwupd.enable = false; # Causes mass build of stuff.
  };

  # power.ups.enable = true

  networking.firewall.allowedTCPPorts = [3000];
  # containers = {
  #   monitoring = {
  #     autoStart = false;
  #     bindMounts = {
  #       "/data/monitoring" = {
  #         hostPath = "/data/monitoring";
  #         isReadOnly = false;
  #       };
  #     };
  #     config = {
  #       imports = [
  #         ../lib
  #       ];

  #       services = {
  #         prometheus = {
  #           enable = true;
  #           globalConfig = {
  #             scrape_interval = "1s";
  #             scrape_timeout = "1s";
  #             evaluation_interval = "1s";
  #           };
  #           scrapeConfigs = [{
  #             job_name = "localhost";
  #             static_configs = [{
  #               targets = ["localhost:9273"];
  #               labels = { instance = "localhost"; };
  #             }];
  #           }];
  #         };
  #         grafana = {
  #           enable = true;
  #           addr = "";
  #           provision = {
  #             enable = true;
  #             datasources = [{
  #               name = "prometheus";
  #               type = "prometheus";
  #               url = "http://localhost:9090";
  #               isDefault = true;
  #             }];
  #           };
  #         };
  #       };
  #     };
  #   };
  # };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?
}
