{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    conntrack-tools
    dmidecode
    dstat
    efibootmgr
    efivar
    file
    ipmitool
    lm_sensors
    lsof
    mosh
    pciutils
    psmisc
    rename
    screen
    smartmontools
    sysstat
    tcpdump
    wget
  ];

  programs = {
    iotop.enable = true;
    iftop.enable = true;
    mtr.enable = true;
  };
}
