{
  imports = [
    ./alacritty.nix
    ./bash.nix
    ./direnv.nix
    ./emacs.nix
    ./git.nix
    ./go.nix
    ./i3.nix
    ./programs.nix
    ./ssh.nix
    ./zsh.nix
  ];

  # Shell prompt: powerline? starship?
  # zathura?

  home.stateVersion = "20.09";
}
