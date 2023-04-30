{
  imports = [
    ./alacritty.nix
    ./bash.nix
    ./direnv.nix
    #./emacs.nix
    ./emacs2.nix
    ./git.nix
    ./go.nix
    ./options.nix
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
