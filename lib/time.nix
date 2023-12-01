{lib, config, ...} : {
  services.chrony = {
    enable = true;
    servers = [
      "time1.google.com"
      "time2.google.com"
      "time3.google.com"
      "time4.google.com"
    ];
    extraConfig = lib.mkIf (config.system.nixos.release == "23.05") ''
      rtcsync
    '';
  };
}
