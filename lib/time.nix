{
  services.chrony = {
    enable = true;
    servers = [
      "time1.google.com"
      "time2.google.com"
      "time3.google.com"
      "time4.google.com"
    ];
    extraConfig = ''
      rtcsync
    '';
  };
}
