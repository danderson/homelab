{ pkgs, ... }: {
  environment.shells = [ pkgs.bashInteractive pkgs.zsh ];
}
