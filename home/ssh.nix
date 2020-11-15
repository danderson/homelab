{
  programs.ssh = {
    enable = true;
    # TODO: moar
    controlMaster = "auto";
    controlPersist = "10m";

    matchBlocks = {
      acrux = {
        host = "acrux acrux.universe.tf";
        hostname = "192.168.1.2";
        port = 42222;
      };

      atlas = {
        host = "atlas atlas.universe.tf";
        hostname = "atlas.universe.tf";
        port = 42222;
      };

      vega = {
        host = "vega vega.universe.tf";
        hostname = "localhost"; # TODO: make this less silly.
        port = 42222;
      };
    };
  };
}
