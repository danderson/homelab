{ config, pkgs, flakes, ... }:
{
  imports = [
    ../lib
    ./adguard.nix
    ./garden.nix
    ./hardware-configuration.nix
    ./monitoring.nix
    ./private.nix
  ];

  my = {
    cpu-vendor = "intel";
    zfs = true;
    vms = true;
    mdns = true; # So airscan works
    nodeMonitoring = true;
  };

  boot.zfs.extraPools = [ "data" ];

  networking = {
    hostName = "acrux";
    defaultGateway = "192.168.4.1";
    nameservers = ["8.8.8.8"];
    interfaces.eno1 = {
      useDHCP = false;
      ipv4 = {
        addresses = [{
          address = "192.168.4.2";
          prefixLength = 22;
        }];
      };
    };
    interfaces.enp5s0f1.ipv4.addresses = [{
      address = "10.0.0.1";
      prefixLength = 24;
    }];
    interfaces.eno2.useDHCP = false;
    interfaces.eno3.useDHCP = false;
    interfaces.eno4.useDHCP = false;
  };

  fileSystems."/var/lib/libvirt/images" = {
    device = "/data/vms";
    options = [ "bind" ];
  };

  # Run in a container so it can get its own tailscale IP and hostname
  # Host system still gets a paperless user/group so ls makes sense.
  users = {
    users.paperless = {
      group = "paperless";
      uid = config.ids.uids.paperless;
      home = "/data/paperless";
    };
    groups.paperless = {
      gid = config.ids.gids.paperless;
    };
  };
  containers.paperless = {
    autoStart = true;
    ephemeral = true;
    privateNetwork = true;
    hostAddress = "192.168.254.10";
    localAddress = "192.168.254.11";
    forwardPorts = [
      {
        containerPort = 28981;
        hostPort = 28981;
        protocol = "tcp";
      }
    ];
    bindMounts = {
      "/data/paperless" = {
        hostPath = "/data/paperless";
        isReadOnly = false;
      };
      "/etc/keys/paperless-admin-password" = {
        hostPath = "/etc/keys/paperless-admin-password";
        isReadOnly = true;
      };
      "/var/lib/tailscale" = {
        hostPath = "/var/lib/tailscale/paperless";
        isReadOnly = false;
      };
    };
    config = {
      # Inject the flakes parameter into the container's evaluation
      # environment. Because of the way declarative containers work,
      # they don't get evaluated with the full module context of their
      # parent, and don't provide a handy place to inject
      # this. Fortunately, doing the obvious thing of "smash the value
      # into the module by hand" seems to work correctly, muahahah.
      _module.args.flakes = flakes;
      system.stateVersion = "21.11";

      imports = [
        flakes.agenix.nixosModules.age
        ../lib
      ];

      services.paperless = {
        enable = true;
        dataDir = "/data/paperless";
        passwordFile = "/etc/keys/paperless-admin-password";
      };
      networking.firewall.extraCommands = ''
        iptables -t nat -A OUTPUT -d 127.0.0.1 -p tcp --dport 80 -j DNAT --to 127.0.0.1:28981
      '';
      networking.firewall.extraStopCommands = ''
        iptables -t nat -D OUTPUT -d 127.0.0.1 -p tcp --dport 80 -j DNAT --to 127.0.0.1:28981
      '';
      my.tailscale = "stable";
      services.tailscale.interfaceName = "userspace-networking";
    };
  };

  services.dockerRegistry = {
    enable = false;
    enableDelete = true;
    enableGarbageCollect = true;
    listenAddress = "::";
    storagePath = "/data/docker";
  };

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
    dataDir = "/fast/postgres";
    extraPlugins = with pkgs.postgresql_16.pkgs; [ postgis ];
    settings = {
      # ZFS guarantees pages are never partially written, no need for
      # postgres to be defensive.
      full_page_writes = false;
    };
    authentication = ''
      host all all 100.107.212.49/32 trust
      local osm osm trust
    '';
    enableTCPIP = true;
    ensureDatabases = [ "osm" ];
    ensureUsers = [
      {
        name = "osm";
        ensureDBOwnership = true;
        ensureClauses.login = true;
      }
    ];
  };

  # power.ups.enable = true # need to figure out out how

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}
