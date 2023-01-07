{
  imports = [
    ./alacritty.nix
    ./bash.nix
    ./direnv.nix
    ./emacs.nix
    ./git.nix
    ./go.nix
    ./programs.nix
    ./ssh.nix
    ./wm.nix
    ./zsh.nix
  ];

  # Shell prompt: powerline? starship?
  # zathura?

  fonts.fontconfig.enable = true;

  home.stateVersion = "21.11";
}
