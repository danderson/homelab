{
  programs.ssh = {
    enable = false;
    # TODO: moar
    controlMaster = "auto";
    controlPersist = "10m";
  };
}
