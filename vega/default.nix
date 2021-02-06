{ flakes, pkgs, ... }: {
  require = [
    ../lib
    ./hardware-configuration.nix
    ./sway.nix
    ./tailscale.nix
    flakes.nixos-hardware.nixosModules.lenovo-thinkpad-t495
  ];

  my.cpu-vendor = "amd";

  boot = rec {
    kernelPackages = pkgs.linuxPackages_5_8;
    kernelModules = ["acpi_call"];
    supportedFilesystems = ["zfs"];
    zfs.requestEncryptionCredentials = true;
    extraModulePackages = [kernelPackages.acpi_call];
    kernelParams = ["acpi_backlight=native"];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking.hostId = "515b13ad";
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = true;
  networking.networkmanager.wifi.backend = "iwd";
  networking.useDHCP = false;

  networking = {
    hostName = "vega";
    iproute2.enable = true;
    firewall.checkReversePath = "loose"; # TODO: why?
  };

  environment.systemPackages = [ pkgs.zoom-us ];

  home-manager.users.dave.home.file = {
    "bin/tss" = {
      executable = true;
      text = builtins.readFile ./tailscale-switch-profile.sh;
    };
    "bin/delbr" = {
      executable = true;
      text = builtins.readFile ./delete-my-old-branches.sh;
    };
  };

  hardware.enableRedistributableFirmware = true;
  documentation.dev.enable = true;

  fonts = {
    enableDefaultFonts = true;
    # Give fonts to 32-bit binaries too (e.g. steam).
    fontconfig.cache32Bit = true;
    fonts = with pkgs; [
        google-fonts liberation_ttf opensans-ttf roboto roboto-mono
    ];
  };

  hardware = {
    opengl = {
      enable = true;
      driSupport32Bit = true; # Maybe for steam?
      extraPackages = [ pkgs.amdvlk ];
      # TODO: figure out VAAPI support
    };
    trackpoint.enable = true;
    bluetooth.enable = true;
  };

  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;
  users.users.dave.extraGroups = ["scanner" "lp" "audio" "video" "dialout"];
  nixpkgs.config.pulseaudio = true;
  location.provider = "geoclue2";

  services = {
    upower.enable = true;
    lorri.enable = true;
    timesyncd = {
      enable = true;
      servers = ["time.google.com"];
    };
    xserver = {
      enable = true;
      libinput.enable = true;
      desktopManager.gnome3.enable = true;
      displayManager.gdm.enable = true;
      videoDrivers = ["amdgpu"];
    };
    tlp.enable = true;
    acpid.enable = true;
    colord.enable = true;
    fprintd.enable = true;
    fwupd.enable = true;
    geoip-updater.enable = true;
    pipewire.enable = true;
  };

  services.printing = {
    enable = true;
    drivers = [ ];
  };
  services.avahi = {
    enable = true;
    nssmdns = true;
  };
  virtualisation.virtualbox.host = {
    enable = true;
    enableExtensionPack = true;
  };
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
      gtkUsePortal = true;
    };
  };

  services.udev.extraRules = ''
    SUBSYSTEM=="tty", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6015", MODE="664", GROUP="dialout"
    ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6015", MODE="664", GROUP="dialout"
  '';

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "20.03"; # Did you read the comment?
}
