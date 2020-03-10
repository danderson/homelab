{
  networking.networkmanager.enable = false;
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.wireless.networks.Shnookums.psk = "businesscatandsausagecat";
  networking.useDHCP = false;
  networking.interfaces.enp3s0f0.useDHCP = true;
  networking.interfaces.enp5s0.useDHCP = true;
  networking.interfaces.wlp1s0.useDHCP = true;
}
