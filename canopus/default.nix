{ flakes, pkgs, ... }: {
  require = [
    ../lib
    ./hardware-configuration.nix
    ./sway.nix
    ./i3.nix
  ];

  my.cpu-vendor = "intel";
  my.desktop = true;

  boot = rec {
    kernelPackages = pkgs.linuxPackages_5_15;
    loader.systemd-boot.enable = true;
  };

  networking = {
    hostName = "canopus";
    hostId = "02658bd1";
  };

  environment.systemPackages = with pkgs; [ zoom-us ffmpeg ];

  services = {
    upower.enable = true;
    acpid.enable = true;
    colord.enable = true;
    fprintd.enable = true;
    fwupd.enable = true;
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "21.11"; # Did you read the comment?
}
