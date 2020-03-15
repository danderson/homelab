{
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = true;
  networking.networkmanager.wifi.backend = "iwd";
  programs.nm-applet.enable = true;
  networking.useDHCP = false;
}
