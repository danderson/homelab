{
  programs.ssh = {
    enable = true;
    extraConfig = import ./private.nix;
  };
}
