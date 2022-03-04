{ config, lib, ...}: {
  services.udev.extraRules = lib.mkIf config.my.ulxs ''
    # FPGA dev board
    SUBSYSTEM=="tty", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6015", MODE="664", GROUP="dialout"
    ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6015", MODE="664", GROUP="dialout"
  '';
}
