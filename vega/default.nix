{ flakes, pkgs, ... }: {
  require = [
    ../lib
    ./hardware-configuration.nix
    flakes.nixos-hardware.nixosModules.lenovo-thinkpad-t495
  ];

  my.cpu-vendor = "amd";

  boot = rec {
    kernelPackages = pkgs.linuxPackages_latest;
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
    firewall = {
      enable = true;
      allowPing = true;
      checkReversePath = "loose";
    };
  };

  nix = {
    buildMachines = [{
      hostName = "acrux";
      system = "x86_64-linux";
      maxJobs = 8;
      speedFactor = 2;
      supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
      mandatoryFeatures = [ ];
    }];
    distributedBuilds = true;
    extraOptions = "builders-use-substitutes = true";
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
  environment.systemPackages = with pkgs; [
    pavucontrol
    google-chrome
    emacs
    direnv
    steam
  ];

  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;
  users.users.dave.extraGroups = ["scanner" "lp" "audio" "video"];
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
    emacs.enable = true;
    fprintd.enable = true;
    fwupd.enable = true;
    geoip-updater.enable = true;
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
  
  systemd.services.tailscaled = {
    after = [ "network-pre.target" ];
    wants = [ "network-pre.target" ];
    wantedBy = [ "multi-user.target" ];

    unitConfig = {
      StartLimitIntervalSec = 0;
      StartLimitBurst = 0;
    };

    path = [ pkgs.openresolv pkgs.iptables pkgs.iproute ];

    environment = {
      #TS_DEBUG_CONTROL_FLAGS = "v6-overlay";
    };
    serviceConfig = {
      ExecStart =
        "/home/dave/tail/corp/out/native/oss/cmd/tailscaled/tailscaled --port 41641";

      RuntimeDirectory = "tailscale";
      RuntimeDirectoryMode = 755;

      StateDirectory = "tailscale";
      StateDirectoryMode = 750;

      CacheDirectory = "tailscale";
      CacheDirectoryMode = 750;

      Restart = "on-failure";
    };
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "20.03"; # Did you read the comment?
}
