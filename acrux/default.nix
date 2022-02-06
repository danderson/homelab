{ config, pkgs, flakes, ... }:
{
  imports = [
    ../lib
    ./adguard.nix
    ./hardware-configuration.nix
    ./monitoring.nix
    ./private.nix
  ];

  my.cpu-vendor = "intel";

  boot.supportedFilesystems = ["zfs"];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "acrux"; # Define your hostname.
  networking.defaultGateway = "192.168.4.1";
  networking.nameservers = ["127.0.0.1:54"];
  networking.interfaces.eno1 = {
    useDHCP = false;
    ipv4 = {
      addresses = [
        {
          address = "192.168.4.2";
          prefixLength = 24;
        }
      ];
    };
  };
  networking.interfaces.enp2s0f0.ipv4.addresses = [{
    address = "10.0.0.1";
    prefixLength = 24;
  }];
  networking.interfaces.eno2.useDHCP = false;
  networking.interfaces.eno3.useDHCP = false;
  networking.interfaces.eno4.useDHCP = false;

  environment.systemPackages = with pkgs; [
    hdparm
    lsscsi
  ];

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

    paperless-ng = {
      enable = false;
      dataDir = "/data/paperless";
      passwordFile = "/etc/keys/paperless-admin-password";
      address = "0.0.0.0";
    };

  };
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

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      runAsRoot = false;
      swtpm.enable = true;
    };
  };
  fileSystems."/var/lib/libvirt/images" = {
    device = "/data/vms";
    options = [ "bind" ];
  };

  # Run in a container so it can get its own tailscale IP and hostname
  containers.paperless = {
    autoStart = true;
    ephemeral = true;
    privateNetwork = true;
    hostAddress = "192.168.254.10";
    localAddress = "192.168.254.11";
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

      imports = [
        ../lib
      ];

      services.paperless-ng = {
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
      my.tailscale = true;
      services.tailscale.interfaceName = "userspace-networking";
    };
  };

  # power.ups.enable = true # need to figure out out how

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?
}
