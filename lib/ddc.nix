{ config, lib, ... }: lib.mkIf config.my.ddc {
  boot.kernelModules = ["i2c-dev"];
  services.udev.extraRules = ''
    # RGB controllers
    KERNEL=="i2c-[0-99]*", TAG+="uaccess"
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", TAG+="uaccess"
  '';
}
