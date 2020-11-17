{
  programs.ssh = {
    enable = true;
    # TODO: moar
    controlMaster = "auto";
    controlPersist = "10m";
  };
}
