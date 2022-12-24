{ flakes, config, pkgs, ... }: {
  require = [
    ../lib
    ./hardware-configuration.nix
  ];

  my.cpu-vendor = "amd";
  my.desktop = true;
  my.ddc = true;

  networking = {
    hostName = "rigel";
    hostId = "1d358a90";
  };

  hardware.system76.enableAll = true;

  virtualisation.libvirtd = {
    enable = true;
    qemu.runAsRoot = false;
  };
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };

  home-manager.users.dave.my.monitors = {
    left = {
      type = "DisplayPort";
      num = 2;
      x = 0;
      y = 383;
      res = "2560x1440";
    };
    mid = {
      type = "DisplayPort";
      num = 3;
      x = 2560;
      y = 383;
      res = "2560x1440";
    };
    rightdown = {
      type = "DisplayPort";
      num = 1;
      x = 5120;
      y = 1440;
      res = "2560x1440";
    };
    rightup = {
      type = "HDMI";
      num = 1;
      x = 5120;
      y = 0;
      res = "2560x1440";
    };
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "21.11"; # Did you read the comment?
}
