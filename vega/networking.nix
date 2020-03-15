{
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = true;
  networking.networkmanager.wifi.backend = "iwd";
  programs.nm-applet.enable = true;
  networking.useDHCP = false;
  networking.interfaces.enp3s0f0.useDHCP = true;
  networking.interfaces.enp5s0.useDHCP = true;
  networking.interfaces.wlp1s0.useDHCP = true;
}
