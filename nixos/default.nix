{ flakes, pkgs, ... }: {
  require = [
    ../lib
    ./hardware-configuration.nix
    ./i3.nix
    #./tailscale.nix
  ];

  nixpkgs.overlays = [
    (final: prev: {
      firmwareLinuxNonfree = flakes.nixos-unstable.legacyPackages.x86_64-linux.firmwareLinuxNonfree;
    })
  ];

  # TODO: autorandr?

  # zpool create -O recordsize=128K -O compression=on -O atime=off -O xattr=sa -O encryption=aes-256-gcm -O keyformat=passphrase -o ashift=12 -m none data /dev/disk/by-partuuid/...
  # zfs create -o mountpoint=none data/local
  # zfs create -o mountpoint=legacy data/local/root
  # zfs create -o mountpoint=legacy data/local/nix
  # zfs create -o mountpoint=legacy data/local/etc.nixos
  # zfs create -o mountpoint=none data/safe
  # zfs create -o mountpoint=legacy data/safe/home
  # zfs create -o mountpoint=legacy data/safe/persist

  my.cpu-vendor = "amd";
  my.mdns = true;

  boot = rec {
    kernelPackages = pkgs.linuxPackages_5_11;
    supportedFilesystems = ["zfs"];
    zfs.requestEncryptionCredentials = true;
    extraModulePackages = [kernelPackages.acpi_call kernelPackages.v4l2loopback];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking = {
    hostName = "nixos";
    hostId = "5c13d618";
    networkmanager = {
      enable = true;
      wifi.powersave = true;
      wifi.backend = "iwd";
    };
    # Install iproute2 configuration files in /etc.
    iproute2.enable = true;
    #firewall.checkReversePath = "loose"; # TODO: why?
  };

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
    bluetooth.enable = true;
  };

  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;
  nixpkgs.config.pulseaudio = true;

  services = {
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
    fwupd.enable = true;
    printing.enable = true;
  };

  virtualisation.virtualbox.host = {
    enable = false; # TODO: enable
    enableExtensionPack = true;
  };
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };

  # udev rule to allow the "dialout" group to speak to my Lattice FPGA
  # board over its USB-serial chip.
  services.udev.extraRules = ''
    SUBSYSTEM=="tty", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6015", MODE="664", GROUP="dialout"
    ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6015", MODE="664", GROUP="dialout"
  '';

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "20.09"; # Did you read the comment?
}
