{ flakes, pkgs, ... }: {
  require = [
    ../lib
    ./hardware-configuration.nix
    ./i3.nix
    ./tailscale.nix
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
  home-manager.users.dave.my.battlestation = true;

  boot = rec {
    kernelPackages = pkgs.linuxPackages_5_11;
    supportedFilesystems = ["zfs"];
    zfs.requestEncryptionCredentials = true;
    kernelModules = ["i2c-dev" "i2c-i801"];
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
    enable = true;
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


    #---------------------------------------------------------------#
    #  OpenRGB udev rules                                           #
    #                                                               #
    #   Adam Honse (CalcProgrammer1)                    5/29/2020   #
    #---------------------------------------------------------------#

    #---------------------------------------------------------------#
    #  User I2C/SMBus Access                                        #
    #---------------------------------------------------------------#
    KERNEL=="i2c-[0-99]*", TAG+="uaccess"

    #---------------------------------------------------------------#
    #  Super I/O Access                                             #
    #---------------------------------------------------------------#
    KERNEL=="port", TAG+="uaccess"

    #---------------------------------------------------------------#
    #  User hidraw Access                                           #
    #---------------------------------------------------------------#
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", TAG+="uaccess"

    #---------------------------------------------------------------#
    #  AMD Wraith Prism                                             #
    #---------------------------------------------------------------#
    SUBSYSTEMS=="usb", ATTR{idVendor}=="2516", ATTR{idProduct}=="0051", TAG+="uaccess"

    #---------------------------------------------------------------#
    #  Aorus Devices                                                #
    #---------------------------------------------------------------#
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1044", ATTR{idProduct}=="7a42", TAG+="uaccess"

    #---------------------------------------------------------------#
    #  ASRock Devices                                               #
    #                                                               #
    #   ASRock Polychrome USB                                       #
    #   ASRock Deskmini Addressable LED Strip                       #
    #---------------------------------------------------------------#
    SUBSYSTEMS=="usb", ATTR{idVendor}=="26CE", ATTR{idProduct}=="01A2", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="26CE", ATTR{idProduct}=="01A6", TAG+="uaccess"
    
    #---------------------------------------------------------------#
    #  ASUS Aura Core Devices                                       #
    #---------------------------------------------------------------#
    SUBSYSTEMS=="usb", ATTR{idVendor}=="0b05", ATTR{idProduct}=="1854", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="0b05", ATTR{idProduct}=="1869", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="0b05", ATTR{idProduct}=="1866", TAG+="uaccess"
    
    #---------------------------------------------------------------#
    #  ASUS Aura USB Devices                                        #
    #---------------------------------------------------------------#
    SUBSYSTEMS=="usb", ATTR{idVendor}=="0b05", ATTR{idProduct}=="1867", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="0b05", ATTR{idProduct}=="1872", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="0b05", ATTR{idProduct}=="1889", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="0b05", ATTR{idProduct}=="18a3", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="0b05", ATTR{idProduct}=="18f3", TAG+="uaccess"
    
    #---------------------------------------------------------------#
    #  ASUS TUF Laptops (faustus)                                   #
    #---------------------------------------------------------------#
    ACTION=="add", SUBSYSTEM=="platform", KERNEL=="faustus", RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/bus/platform/devices/%k/kbbl/kbbl_blue"
    ACTION=="add", SUBSYSTEM=="platform", KERNEL=="faustus", RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/bus/platform/devices/%k/kbbl/kbbl_flags"
    ACTION=="add", SUBSYSTEM=="platform", KERNEL=="faustus", RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/bus/platform/devices/%k/kbbl/kbbl_green"
    ACTION=="add", SUBSYSTEM=="platform", KERNEL=="faustus", RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/bus/platform/devices/%k/kbbl/kbbl_mode"
    ACTION=="add", SUBSYSTEM=="platform", KERNEL=="faustus", RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/bus/platform/devices/%k/kbbl/kbbl_red"
    ACTION=="add", SUBSYSTEM=="platform", KERNEL=="faustus", RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/bus/platform/devices/%k/kbbl/kbbl_set"
    ACTION=="add", SUBSYSTEM=="platform", KERNEL=="faustus", RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/bus/platform/devices/%k/kbbl/kbbl_speed"
    
    #---------------------------------------------------------------#
    #  Cooler Master Peripheral Devices                             #
    #                                                               #
    #  Mousemats:                                                   #
    #       Cooler Master MP750                                     #
    #---------------------------------------------------------------#
    SUBSYSTEMS=="usb", ATTR{idVendor}=="2516", ATTR{idProduct}=="0109", TAG+="uaccess"
    
    #---------------------------------------------------------------#
    #  Corsair Hydro Series Devices                                 #
    #                                                               #
    #       Corsair H100i Pro RGB                                   #
    #       Corsair H115i Pro RGB                                   #
    #       Corsair H150i Pro RGB                                   #
    #---------------------------------------------------------------#
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1b1c", ATTR{idProduct}=="0c15", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1b1c", ATTR{idProduct}=="0c13", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1b1c", ATTR{idProduct}=="0c12", TAG+="uaccess"
    
    #---------------------------------------------------------------#
    #  Corsair Lighting Node Devices                                #
    #                                                               #
    #       Corsair Lighting Node Core                              #
    #       Corsair Lighting Node Pro                               #
    #       Corsair Commander Pro                                   #
    #       Corsair LS100                                           #
    #       Corsair 1000D Obsidian                                  #
    #       Corsair Spec Omega RGB                                  #
    #       Corsair LT100                                           #
    #---------------------------------------------------------------#
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1b1c", ATTR{idProduct}=="0c1a", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1b1c", ATTR{idProduct}=="0c0b", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1b1c", ATTR{idProduct}=="0c10", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1b1c", ATTR{idProduct}=="0c1e", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1b1c", ATTR{idProduct}=="1d00", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1b1c", ATTR{idProduct}=="1d04", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1b1c", ATTR{idProduct}=="0a32", TAG+="uaccess"
    
    #---------------------------------------------------------------#
    #  Corsair Peripheral Devices                                   #
    #                                                               #
    #  Keyboards:                                                   #
    #       Corsair K55 RGB                                         #
    #       Corsair K65 RGB                                         #
    #       Corsair K65 RGB Lux                                     #
    #       Corsair K65 RGB Rapidfire                               #
    #       Corsair K68 RGB                                         #
    #       Corsair K70 RGB                                         #
    #       Corsair K70 RGB Lux                                     #
    #       Corsair K70 RGB Rapidfire                               #
    #       Corsair K70 RGB MK2                                     #
    #       Corsair K70 RGB MK2 SE                                  #
    #       Corsair K70 RGB MK2 LP                                  #
    #       Corsair K95 RGB                                         #
    #       Corsair K95 Platinum                                    #
    #       Corsair Strafe                                          #
    #       Corsair Strafe MK2                                      #
    #                                                               #
    #  Mice:                                                        #
    #       Corsair M65 Pro                                         #
    #       Corsair M65 RGB Elite                                   #
    #                                                               #
    #  Mousemats:                                                   #
    #       Corsair MM800 RGB Polaris                               #
    #                                                               #
    #  Headset Stands:                                              #
    #       Corsair ST100                                           #
    #---------------------------------------------------------------#
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1b1c", ATTR{idProduct}=="1b3d", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1b1c", ATTR{idProduct}=="1b17", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1b1c", ATTR{idProduct}=="1b37", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1b1c", ATTR{idProduct}=="1b39", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1b1c", ATTR{idProduct}=="1b4f", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1b1c", ATTR{idProduct}=="1b13", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1b1c", ATTR{idProduct}=="1b33", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1b1c", ATTR{idProduct}=="1b38", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1b1c", ATTR{idProduct}=="1b49", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1b1c", ATTR{idProduct}=="1b6b", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1b1c", ATTR{idProduct}=="1b55", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1b1c", ATTR{idProduct}=="1b11", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1b1c", ATTR{idProduct}=="1b2d", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1b1c", ATTR{idProduct}=="1b20", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1b1c", ATTR{idProduct}=="1b48", TAG+="uaccess"
    
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1b1c", ATTR{idProduct}=="1b2e", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1b1c", ATTR{idProduct}=="1b5a", TAG+="uaccess"
    
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1b1c", ATTR{idProduct}=="1b3b", TAG+="uaccess"
    
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1b1c", ATTR{idProduct}=="0a34", TAG+="uaccess"
    
    #---------------------------------------------------------------#
    #  HyperX Peripheral Devices                                    #
    #                                                               #
    #  Keyboards:                                                   #
    #       HyperX Alloy Elite                                      #
    #                                                               #
    #  Mice:                                                        #
    #       HyperX Pulsefire Surge                                  #
    #                                                               #
    #  Mousemats:                                                   #
    #       HyperX Fury Ultra                                       #
    #---------------------------------------------------------------#
    SUBSYSTEMS=="usb", ATTR{idVendor}=="0951", ATTR{idProduct}=="16be", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="0951", ATTR{idProduct}=="16d3", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="0951", ATTR{idProduct}=="1705", TAG+="uaccess"
    
    #---------------------------------------------------------------#
    #  Lian Li Uni Hub                                              #
    #---------------------------------------------------------------#
    SUBSYSTEMS=="usb", ATTR{idVendor}=="0cf2", ATTR{idProduct}=="7750", TAG+="uaccess"
    
    #---------------------------------------------------------------#
    #  Logitech Peripheral Devices                                  #
    #                                                               #
    #   Keyboards:                                                  #
    #       Logitech G213                                           #
    #       Logitech G512                                           #
    #       Logitech G512 RGB                                       #
    #       Logitech G610                                           #
    #       Logitech G810 #1                                        #
    #       Logitech G810 #2                                        #
    #                                                               #
    #  Mice:                                                        #
    #       Logitech G203 Prodigy                                   #
    #       Logitech G203 Lightsync                                 #
    #       Logitech G403 Prodigy                                   #
    #       Logitech G403 Hero                                      #
    #       Logitech G502 Proteus Spectrum                          #
    #       Logitech G Lightspeed Wireless Gaming Mouse             #
    #       Logitech G Pro Wireless Gaming Mouse (Wired)            #
    #                                                               #
    #  Mousemats:                                                   #
    #       Logitech G Powerplay Mousepad with Lightspeed           #
    #                                                               #
    #---------------------------------------------------------------#
    SUBSYSTEMS=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c336", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c342", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c33c", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c333", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c331", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c337", TAG+="uaccess"
    
    SUBSYSTEMS=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c084", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c092", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c083", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c08f", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c332", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c08b", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c539", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c088", TAG+="uaccess"
    
    SUBSYSTEMS=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c53a", TAG+="uaccess"
    
    #---------------------------------------------------------------#
    #  Metadot Das Keyboard 4Q + 5Q                                 #
    #---------------------------------------------------------------#
    SUBSYSTEMS=="usb", ATTR{idVendor}=="24f0", ATTR{idProduct}=="2037", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="24f0", ATTR{idProduct}=="202b", TAG+="uaccess"
    
    #---------------------------------------------------------------#
    #  MSI Mysticlight                                              #
    #---------------------------------------------------------------#
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1462", ATTR{idProduct}=="3EA4", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1462", ATTR{idProduct}=="4559", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1462", ATTR{idProduct}=="7B10", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1462", ATTR{idProduct}=="7B93", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1462", ATTR{idProduct}=="7B94", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1462", ATTR{idProduct}=="7B96", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1462", ATTR{idProduct}=="7C34", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1462", ATTR{idProduct}=="7C35", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1462", ATTR{idProduct}=="7C36", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1462", ATTR{idProduct}=="7C37", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1462", ATTR{idProduct}=="7C42", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1462", ATTR{idProduct}=="7C56", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1462", ATTR{idProduct}=="7C59", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1462", ATTR{idProduct}=="7C60", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1462", ATTR{idProduct}=="7C67", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1462", ATTR{idProduct}=="7C70", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1462", ATTR{idProduct}=="7C71", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1462", ATTR{idProduct}=="7C73", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1462", ATTR{idProduct}=="7C75", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1462", ATTR{idProduct}=="7C76", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1462", ATTR{idProduct}=="7C77", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1462", ATTR{idProduct}=="7C79", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1462", ATTR{idProduct}=="7C80", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1462", ATTR{idProduct}=="7C81", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1462", ATTR{idProduct}=="7C82", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1462", ATTR{idProduct}=="7C83", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1462", ATTR{idProduct}=="7C84", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1462", ATTR{idProduct}=="7C85", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1462", ATTR{idProduct}=="7C86", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1462", ATTR{idProduct}=="7C87", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1462", ATTR{idProduct}=="7C88", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1462", ATTR{idProduct}=="7C89", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1462", ATTR{idProduct}=="7C90", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1462", ATTR{idProduct}=="7C91", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1462", ATTR{idProduct}=="7C92", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1462", ATTR{idProduct}=="7C94", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1462", ATTR{idProduct}=="7C95", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1462", ATTR{idProduct}=="7C96", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1462", ATTR{idProduct}=="7C98", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1462", ATTR{idProduct}=="7C99", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1462", ATTR{idProduct}=="905D", TAG+="uaccess"
    
    #---------------------------------------------------------------#
    #  MSI/SteelSeries 3-Zone Laptop Keyboard                       #
    #---------------------------------------------------------------#
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1770", ATTR{idProduct}=="FF00", TAG+="uaccess"
    
    #---------------------------------------------------------------#
    #  NZXT Hue+                                                    #
    #---------------------------------------------------------------#
    KERNEL=="ttyACM[0-9]*", ATTR{idVendor}=="04D8", ATTR{idProduct}=="00DF", TAG+="uaccess"
    
    #---------------------------------------------------------------#
    #  NZXT Hue 2 Devices                                           #
    #                                                               #
    #       NZXT Hue 2                                              #
    #       NZXT Smart Device V2                                    #
    #---------------------------------------------------------------#
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1e71", ATTR{idProduct}=="2001", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1e71", ATTR{idProduct}=="2006", TAG+="uaccess"
    
    #---------------------------------------------------------------#
    #  NZXT Kraken                                                  #
    #---------------------------------------------------------------#
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1e71", ATTR{idProduct}=="170e", TAG+="uaccess"
    
    #---------------------------------------------------------------#
    #  Redragon Peripheral Devices                                  #
    #                                                               #
    #  Keyboards:                                                   #
    #       Redragon K550 Yama                                      #
    #       Redragon K552 Kumara                                    #
    #       Redragon K556 Devarajas                                 #
    #       Tecware Phantom Elite                                   #
    #                                                               #
    #  Mice:                                                        #
    #       Redragon M711 Cobra                                     #
    #       Redragon M715 Dagger                                    #
    #---------------------------------------------------------------#
    SUBSYSTEMS=="usb", ATTR{idVendor}=="0c45", ATTR{idProduct}=="5204", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="0c45", ATTR{idProduct}=="5104", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="0c45", ATTR{idProduct}=="5004", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="0c45", ATTR{idProduct}=="652f", TAG+="uaccess"
    
    SUBSYSTEMS=="usb", ATTR{idVendor}=="04d9", ATTR{idProduct}=="fc30", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="04d9", ATTR{idProduct}=="fc39", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="04d9", ATTR{idProduct}=="fc4d", TAG+="uaccess"
    
    #---------------------------------------------------------------#
    #  Gigabyte/Aorus RGB Fusion 2 USB                              #
    #---------------------------------------------------------------#
    SUBSYSTEMS=="usb", ATTR{idVendor}=="048d", ATTR{idProduct}=="8297", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="048d", ATTR{idProduct}=="5702", TAG+="uaccess"
    
    #---------------------------------------------------------------#
    #  Sinowealth USB                                               #
    #  Glorious Model O / O-                                        #
    #  Glorious Model D / D-                                        #
    #  Everest GT-100 RGB                                           #
    #---------------------------------------------------------------#
    SUBSYSTEMS=="usb", ATTR{idVendor}=="258a", ATTR{idProduct}=="0036", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="258a", ATTR{idProduct}=="0033", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="258a", ATTR{idProduct}=="0029", TAG+="uaccess"
    
    #---------------------------------------------------------------#
    #  SteelSeries Peripheral Devices                               #
    #                                                               #
    #  Mice:                                                        #
    #       SteelSeries Rival 100                                   #
    #       SteelSeries Rival 100 DotA 2 Edition                    #
    #       SteelSeries Rival 105                                   #
    #       SteelSeries Rival 110                                   #
    #       SteelSeries Rival 300                                   #
    #       Acer Predator Gaming Mouse (Rival 300)                  #
    #       SteelSeries Rival 300 CS:GO Fade Edition                #
    #       SteelSeries Rival 300 CS:GO Fade Edition (stm32)        #
    #       SteelSeries Rival 300 CS:GO Hyperbeast Edition          #
    #       SteelSeries Rival 300 Dota 2 Edition                    #
    #       SteelSeries Rival 300 HP Omen Edition                   #
    #  Headsets:                                                    #
    #       SteelSeries Siberia 350                                 #
    #---------------------------------------------------------------#
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1038", ATTR{idProduct}=="1702", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1038", ATTR{idProduct}=="170c", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1038", ATTR{idProduct}=="1814", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1038", ATTR{idProduct}=="1729", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1038", ATTR{idProduct}=="1384", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1038", ATTR{idProduct}=="1714", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1038", ATTR{idProduct}=="1394", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1038", ATTR{idProduct}=="1716", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1038", ATTR{idProduct}=="171a", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1038", ATTR{idProduct}=="1392", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1038", ATTR{idProduct}=="1718", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="1038", ATTR{idProduct}=="1229", TAG+="uaccess"
    
    
    #---------------------------------------------------------------#
    #  Thermaltake Poseidon Z RGB Keyboard                          #
    #---------------------------------------------------------------#
    SUBSYSTEMS=="usb", ATTR{idVendor}=="264a", ATTR{idProduct}=="3006", TAG+="uaccess"
    
    #---------------------------------------------------------------#
    #  Thermaltake Riing Controllers                                #
    #---------------------------------------------------------------#
    SUBSYSTEMS=="usb", ATTR{idVendor}=="264a", ATTR{idProduct}=="1FA[5-9]", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="264a", ATTR{idProduct}=="1FA[A-F]", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="264a", ATTR{idProduct}=="1FB[0-5]", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTR{idVendor}=="264a", ATTR{idProduct}=="226[0-3]", TAG+="uaccess"
  '';

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "20.09"; # Did you read the comment?
}
