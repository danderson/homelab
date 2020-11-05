{ pkgs, ... }:
{
  programs.zsh.enable = true;
  # Add zsh autocompletes from all installed software to zsh universe.
  environment.pathsToLink = [ "/share/zsh" ];
}
