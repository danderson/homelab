{config, lib, pkgs, ...}:
{
  config = lib.mkIf config.my.desktop {
    # mDNS is necessary for things like printers.
    my.mdns = true;

    boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_5_15;

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
    hardware.pulseaudio.enable = false;
    hardware.pulseaudio.support32Bit = false;
    nixpkgs.config.pulseaudio = true;

    # X11-based display things.
    services.xserver = {
      enable = true;
      libinput.enable = true;
      displayManager.gdm.enable = true;
      windowManager.i3.enable = true;
    };

    fonts = {
      enableDefaultFonts = true;
      fontconfig.cache32Bit = true;
      fonts = with pkgs; [
        google-fonts liberation_ttf open-sans roboto roboto-mono
      ];
    };
    hardware.opengl = {
      enable = true;
      driSupport32Bit = true;
    };
    environment.systemPackages = [ pkgs.alacritty ];

    # Printing - mostly, doesn't handle magic IPP Everywhere
    # configuration, but it's not bad.
    services.printing.enable = true;
    programs.system-config-printer.enable = true;

    # gnome-keyring for the secrets management service. Also adds its
    # password prompter GUIs to the session bus's service list, so it
    # can fire interactive prompts for auth.
    services.gnome.gnome-keyring.enable = true;

    # EXPERIMENT: getting sway to work properly, maybe.
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
    xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };
    programs.sway = {
      enable = true;
    };
    services.flatpak.enable = true;
  };
}
