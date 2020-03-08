{ config, pkgs, lib, ... }:
let
  users = import ./users.nix;
in
{
  imports = [
    ./lib/basics.nix
    ./lib/networking.nix
    ./lib/nixConfig.nix
    ./lib/noXlibs.nix
    ./lib/services.nix
    ./lib/shell.nix
    ./lib/users.nix
    ./lib/utilities.nix

    ./boot.nix
    ./configuration.private.nix
    ./hardware-configuration.nix
    ./networking.nix
    ./telegraf.nix
  ];

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
    fwupd.enable = false; # Causes mass build of stuff.
  };

  # power.ups.enable = true

  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: {
      unstable = import <nixos-unstable> {
        config = config.nixpkgs.config;
      };
    };
  };

  networking.firewall.allowedTCPPorts = [3000];
  containers = {
    monitoring = {
      autoStart = true;
      bindMounts = {
        "/data/monitoring" = {
          hostPath = "/data/monitoring";
          isReadOnly = false;
        };
      };
      config = {
        imports = [
          ./lib/basics.nix
          ./lib/nixConfig.nix
          ./lib/shell.nix
          ./lib/utilities.nix
        ];

        services = {
          prometheus = {
            enable = true;
            globalConfig = {
              scrape_interval = "1s";
              scrape_timeout = "1s";
              evaluation_interval = "1s";
            };
            scrapeConfigs = [{
              job_name = "localhost";
              static_configs = [{
                targets = ["localhost:9273"];
                labels = { instance = "localhost"; };
              }];
            }];
          };
          grafana = {
            enable = true;
            addr = "";
            provision = {
              enable = true;
              datasources = [{
                name = "prometheus";
                type = "prometheus";
                url = "http://localhost:9090";
                isDefault = true;
              }];
            };
          };
        };
      };
    };
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?
}
