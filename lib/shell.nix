{ pkgs, ... }: {
  environment.shells = [ pkgs.bashInteractive pkgs.zsh ];
  programs.zsh.enable = true;
}
