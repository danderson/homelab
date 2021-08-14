{ config, flakes, pkgs, lib, ... }:
{
  imports = [
    ../lib
    ./hardware-configuration.nix
    ./private.nix
  ];

  nixpkgs.overlays = let
    u = flakes.nixos-unstable.legacyPackages.x86_64-linux;
    wm = u.weechatScripts.weechat-matrix.overrideAttrs (oldAttrs: rec {
      src = u.fetchFromGitHub {
        owner = "poljar";
        repo = "weechat-matrix";
        rev = "04be5a8764df750777fed065e0622298c9d7bc2f";
        hash = "sha256-V45WGnFIMm24QNMK7GnddHmR/FF0lpDWP6dQdAX3kuk=";
      };
    });
  in [(self: super: {
    weechat = u.weechat.override {
      configure = { availablePlugins, ... }: {
        plugins = with availablePlugins; [
          (python.withPackages (_: [ wm ]))
          lua
        ];
        scripts = [ wm ];
      };
    };
  })];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/vda";
  networking.hostName = "gacrux";
  networking.interfaces.enp1s0.useDHCP = true;
  networking.nameservers = ["8.8.8.8"];

  boot.supportedFilesystems = ["zfs"];

  environment.systemPackages = [pkgs.irssi];

  services = {
    openssh.openFirewall = false;
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
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?
}
