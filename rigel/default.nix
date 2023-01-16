{ flakes, config, pkgs, ... }: {
  require = [
    ../lib
    ./hardware-configuration.nix
    flakes.nixos-hardware.nixosModules.system76
  ];

  my = {
    cpu-vendor = "amd";
    gpu = "amd";
    desktop = true;
    ddc = true;
    layout = {
      outputs = {
        left = {
          output = "DP-2";
          letter = "y";
          position = { x = 0; y = 383; };
          resolution = { x = 2560; y = 1440; };
        };
        mid = {
          output = "DP-3";
          letter = "u";
          position = { x = 2560; y = 383; };
          resolution = { x = 2560; y = 1440; };
        };
        rightdown = {
          output = "DP-1";
          letter = "i";
          position = { x = 5120; y = 1440; };
          resolution = { x = 2560; y = 1440; };
        };
        rightup = {
          output = "HDMI-A-1";
          letter = "o";
          position = { x = 5120; y = 0; };
          resolution = { x = 2560; y = 1440; };
        };
      };
      layouts = {
        code = {
          mid = ["1" "*"];
          left = ["3"];
          rightdown = ["2"];
          rightup = ["10"];
        };
        bug = {
          mid = ["2" "*"];
          left = ["3"];
          rightdown = ["1"];
          rightup = ["10"];
        };
        game = {
          mid = ["9"];
          left = ["3"];
          rightdown = ["2" "*"];
          rightup = ["10"];
        };
      };
    };
  };

  networking = {
    hostName = "rigel";
    hostId = "1d358a90";
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "21.11"; # Did you read the comment?
}
