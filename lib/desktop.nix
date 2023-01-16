{ config, lib, pkgs, ... }: lib.mkIf config.my.desktop {
  my = {
    mdns = true; # make printer/scanner discovery work
    # Desktop hardware tends to need bleeding edge kernels.
    kernel = "latest";
    # VMs and containers are useful.
    vms = true;
    docker = true;
  };

  # Wifi and Bluetooth.
  networking.networkmanager = {
    enable = true;
    wifi.powersave = true;
    wifi.backend = "iwd";
  };
  networking.iproute2.enable = true;
  hardware.bluetooth.enable = true;

  # Modern hardware tends to need fancy firmware.
  hardware.enableRedistributableFirmware = true;

  # For the hacking.
  documentation = {
    man.enable = true;
    doc.enable = true;
    dev.enable = true;
    info.enable = true;
    nixos.enable = true;
  };

  # Noises and stuff.
  sound.enable = true;
  hardware.pulseaudio.support32Bit = false;
  nixpkgs.config.pulseaudio = true;
  security.rtkit.enable = true; # makes pipewire happy
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # X11-based display things.
  services.xserver = {
    enable = true;
    libinput.enable = true;
    displayManager.gdm.enable = true;
    windowManager.i3.enable = true;
  };
  programs.sway.enable = true;
  # Make more wayland things like screensharing work.
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  fonts = {
    enableDefaultFonts = true;
    fontDir.enable = true;
    fontconfig.cache32Bit = true;
    fonts = with pkgs; [
      google-fonts
      liberation_ttf
      open-sans
      roboto
      roboto-mono
      vistafonts
    ];
  };
  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
  };
  environment.systemPackages = [ pkgs.alacritty ];

  # Printing
  services.printing.enable = true;
  programs.system-config-printer.enable = true;

  # gnome-keyring for the secrets management service. Also adds its
  # password prompter GUIs to the session bus's service list, so it
  # can fire interactive prompts for auth.
  services.gnome.gnome-keyring.enable = true;

  # Flatpak is useful to get a couple things that aren't packaged for
  # NixOS, like Parsec.
  services.flatpak.enable = true;
}
