{config, lib, pkgs, ...}:
{
  config = lib.mkIf config.my.desktop {
    # ZFS is great.
    boot.supportedFilesystems = ["zfs"];
    boot.zfs.requestEncryptionCredentials = true;

    # mDNS is necessary for things like printers.
    my.mdns = true;

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
    documentation.dev.enable = true;

    # Noises and stuff.
    sound.enable = true;
    hardware.pulseaudio.enable = true;
    hardware.pulseaudio.support32Bit = true;
    nixpkgs.config.pulseaudio = true;

    # X11-based display things.
    services.xserver = {
      enable = true;
      libinput.enable = true;
      displayManager.gdm.enable = true;
    };
    fonts = {
      enableDefaultFonts = true;
      fontconfig.cache32Bit = true;
      fonts = with pkgs; [
        google-fonts liberation_ttf opensans-ttf roboto roboto-mono
      ];
    };
    hardware.opengl = {
      enable = true;
      driSupport32Bit = true;
    };

    # Printing - mostly, doesn't handle magic IPP Everywhere
    # configuration, but it's not bad.
    services.printing.enable = true;
    programs.system-config-printer.enable = true;

    # gnome-keyring for the secrets management service. Also adds its
    # password prompter GUIs to the session bus's service list, so it
    # can fire interactive prompts for auth.
    services.gnome.gnome-keyring.enable = true;
  };
}
